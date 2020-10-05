extends Node2D

var Pickup = preload("res://scenes/Pickup.gd")
var Pain = preload("res://scenes/Pain.gd")

var current_track = null
var track_coords = null
var cw
var in_out = 1
var v = Vector2(-300, 60)
var target_rotation
var fly_rotation_speed = 0.0
var track_jumped_from

func _ready():
    randomize()
    position = G.tilesize * Vector2(1, 10)
    if cw == 1:
        $Sprite.flip_h = true
    G.camera = $Camera2D

# Update the turning direction on the current track
# cw == 1 means the tiles are traversed in list order,
# cw == -1 means they are traversed in reverse order.
# in_out has a 1/-1 convention.
func update_cw(tile, in_out):
    # Only change direction when changing loops
    if tile.get_parent() != track_jumped_from:
        cw = 2 * (randi() % 2 - 0.5) # -1 or 1
#    var from_tile = self.position - tile.position
#    var prev_tile = tile.get_prev()
#    var next_tile = tile.get_next()

# Sets in_out and cw/ccw (1, 0)
func determine_state_on_landing(tile):
#    var from_tile = (self.position + v) - tile.position
#    if from_tile.x > 0:
#        if from_tile.y < 0: # Q0
#            in_out = tile.in_outs[0]
#        else: # Q3
#            in_out = tile.in_outs[3]
#    else:
#        if from_tile.y < 0: # Q1
#            in_out = tile.in_outs[1]
#        else: # Q2
#            in_out = tile.in_outs[2]
#    in_out = 1 # always out, the other plan failed.
    update_cw(tile, in_out)

func set_track_coords(tcs):
    self.track_coords = tcs
    self.position = current_track.position_from_coords(track_coords)
    self.scale.y = in_out

func _physics_process(delta):
    var prev_pos = position
    if current_track == null: # Flying
        self.position += v * delta
        self.rotation += fly_rotation_speed * delta
    else: # Move along the track
        if not $CartSound.playing:
            $CartSound.play()
        var coords_and_rotation = current_track.move_along(track_coords, cw, delta)
        self.set_track_coords(coords_and_rotation[0])
        self.target_rotation = coords_and_rotation[1]
        rotation = G.lerp_angle(rotation, target_rotation, G.rot_speed * delta)
    if current_track != null: # on track, maybe actions
        if (Input.is_action_just_pressed("jump") or \
            Input.is_action_just_pressed("jump_far")):
            var now_overlapping = $Area2D.get_overlapping_areas()
            if len(now_overlapping) == 0: # Only allow jumping while not overlapping
                if $CartSound.playing:
                    $CartSound.stop()
                if randi() % 2 == 0:
                    $JumpSound1.play()
                else:
                    $JumpSound2.play()
                v = (position - prev_pos) / delta
                var ride_vec = (position - prev_pos).normalized()
                var up_vec = Vector2(0.0, -1.0).rotated(rotation)
                var jump_vec
                if abs(ride_vec.angle_to(up_vec)) < 0.3 * PI:
                    jump_vec = Vector2(0.0, -1.0).rotated(rotation)
                else:
                    jump_vec = Vector2(0.0, -1.0).rotated(target_rotation)
                jump_vec *= in_out
                if Input.is_action_just_pressed("jump"):
                    v = G.trackspeed * ride_vec + G.jumpspeed * jump_vec
                if Input.is_action_just_pressed("jump_far"):
                    v = 1.5 * G.trackspeed * ride_vec + 0.3 * G.jumpspeed * jump_vec
                fly_rotation_speed = 10.0 * randf() - 5.0
                track_jumped_from = current_track
                current_track = null
            else:
                print("Cannot jump, overlap!")
        elif Input.is_action_just_pressed("switch"):
            in_out *= -1
    if position.y < G.min_car_y:
        position.y = G.max_car_y
    elif position.y > G.max_car_y:
        position.y = G.min_car_y

func _on_Area2D_area_entered(area):
    var area_owner = area.get_parent()
    if area_owner is Pickup:
        pass
    elif area_owner is Pain:
        pass
    elif current_track == null:
        var current_tile = area_owner
        current_track = current_tile.get_parent()
        if randi() % 2 == 0:
            $LandSound1.play()
        else:
            $LandSound2.play()
        track_coords = current_track.get_track_coords(current_tile)
        determine_state_on_landing(current_tile)
        flip(cw == 1)
        self.position = current_track.position_from_coords(track_coords)

func _on_Boglin_area_entered(area):
    var area_owner = area.get_parent()
    if area_owner is Pickup:
        print("Pickup!")
        area_owner.remove()
        G.add_ruby()
    elif area_owner is Pain:
        print("You Died!")
        
func flip(do_flip):
    $Sprite.flip_h = do_flip
    if do_flip:
        $Boglin.scale.x = -1
    else:
        $Boglin.scale.x = 1
