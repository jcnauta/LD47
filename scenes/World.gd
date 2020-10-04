extends Node2D

var Track = preload("res://scenes/Track.tscn")
var Car = preload("res://scenes/Car.tscn")
var Cam = preload("res://scenes/Cam.tscn")

var tracks = []
var car

func _ready():
#    var coords1 = [
#        Vector2(0, 0),
#        Vector2(3, 0),
#        Vector2(3, 4),
#        Vector2(6, 4),
#        Vector2(6, 6),
#        Vector2(0, 6)
#    ]
#    for c_idx in len(coords1):
#        coords1[c_idx] += Vector2(7, 3)
#    var track1 = Track.instance()
#    track1.generate_tiles(coords1)
#    tracks.append(track1)
#    add_child(track1)
    var rect_coords = [
        Vector2(0, 0),
        Vector2(6, 0),
        Vector2(6, 2),
        Vector2(0, 2)
    ]
    var plus_coords = [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(1, 2),
        Vector2(3, 2),
        Vector2(3, 4),
        Vector2(1, 4),
        Vector2(1, 6),
        Vector2(-1, 6),
        Vector2(-1, 4),
        Vector2(-3, 4),
        Vector2(-3, 2),
        Vector2(-1, 2),
        Vector2(-1, 0)
    ]
    var coords_list = []
#    var offsets_list = [Vector2(3, 1), Vector2(5, 5), Vector2(22, 2),
#            Vector2(3, 15), Vector2(12, 10), Vector2(22, 14)]
    var offsets_list = [Vector2(3, 1), Vector2(10, 8), Vector2(22, 2),
            Vector2(3, 15), Vector2(12, 16), Vector2(22, 14)]
    for off in offsets_list:
        var new_coords = []
        for idx in len(plus_coords):
            new_coords.append(plus_coords[idx] + off)
        coords_list.append(new_coords)
        var track = Track.instance()
        track.generate_tiles(new_coords)
        tracks.append(track)
        add_child(track)
    
    car = Car.instance()
    add_child(car)

    G.set_level_width(90)
