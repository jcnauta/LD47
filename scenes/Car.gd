extends Node2D

var current_track = null
var track_coords = null
var cw
var in_out
var fly_v = Vector2(4, 0)

func _ready():
    position = G.tilesize * Vector2(1, 7)
    if cw == 1:
        $Sprite.flip_h = true

# Returns [in_out, cw/ccw (1, 0)]
func update_track_state(tile):
    print(tile.in_outs)
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
    cw = 1

func set_track_coords(tcs):
    self.track_coords = tcs
    self.position = current_track.global_position_from_coords(track_coords)

func _physics_process(delta):
    if current_track == null:
        self.position += fly_v
    else:
        var coords_and_rotation = current_track.move_along(track_coords, cw)
        self.set_track_coords(coords_and_rotation[0])
        self.rotation = coords_and_rotation[1]

func _on_Area2D_area_entered(area):
    if current_track == null:
        var current_tile = area.get_parent()
        current_track = current_tile.get_parent()
        track_coords = current_track.get_track_coords(current_tile)
        update_track_state(current_tile)
        print("in out: " + str(in_out))
        print("cw: " + str(cw))
        if cw == 1:
            $Sprite.flip_h = true
        self.position = current_track.global_position_from_coords(track_coords)
