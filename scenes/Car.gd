extends Node2D

var Pickup = preload("res://scenes/Pickup.gd")

var current_track = null
var track_coords = null
var cw
var in_out
var v = Vector2(500, 0)
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
func update_cw(tile, in_out):
#    var from_tile = self.position - tile.position
#    var prev_tile = tile.get_prev()
#    var next_tile = tile.get_next()
    if tile.get_parent() != track_jumped_from:
        cw = 2 * (randi() % 2 - 0.5) # -1 or 1

# Sets in_out and cw/ccw (1, 0)
func update_track_state(tile):
    var from_tile = self.position - tile.position
    if from_tile.x > 0:
        if from_tile.y < 0: # Q0
            in_out = tile.in_outs[0]
            
        else: # Q3
            in_out = tile.in_outs[3]
    else:
        if from_tile.y < 0: # Q1
            in_out = tile.in_outs[1]
        else: # Q2
            in_out = tile.in_outs[2]
    update_cw(tile, in_out)

func set_track_coords(tcs):
    self.track_coords = tcs
    self.position = current_track.position_from_coords(track_coords)

func _physics_process(delta):
    var prev_pos = position
    if current_track == null:
        self.position += v * delta
        self.rotation += fly_rotation_speed * delta
    else:
        if not $CartSound.playing:
            $CartSound.play()
        var coords_and_rotation = current_track.move_along(track_coords, cw, delta)
        self.set_track_coords(coords_and_rotation[0])
        self.target_rotation = coords_and_rotation[1]
        rotation = G.lerp_angle(rotation, target_rotation, G.rot_speed * delta)
    if Input.is_action_just_pressed("jump") and current_track != null:
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
        v = G.trackspeed * ride_vec + G.jumpspeed * jump_vec
        fly_rotation_speed = 10.0 * randf() - 5.0
        track_jumped_from = current_track
        current_track = null
    if position.y < G.min_car_y:
        position.y = G.max_car_y
    elif position.y > G.max_car_y:
        position.y = G.min_car_y

func _on_Area2D_area_entered(area):
    var area_owner = area.get_parent()
    if area_owner is Pickup:
        pass
    elif current_track == null:
        var current_tile = area_owner
        current_track = current_tile.get_parent()
        if randi() % 2 == 0:
            $LandSound1.play()
        else:
            $LandSound2.play()
        track_coords = current_track.get_track_coords(current_tile)
        update_track_state(current_tile)
        if cw == 1:
            $Sprite.flip_h = true
        self.position = current_track.position_from_coords(track_coords)

func _on_Boglin_area_entered(area):
    var area_owner = area.get_parent()
    if area_owner is Pickup:
        print("Pickup!")
        area_owner.remove()
        G.set_next_level(G.next_lvl_idx + 1)
