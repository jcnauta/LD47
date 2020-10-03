extends Node2D

var Track = preload("res://scenes/Track.tscn")
var Car = preload("res://scenes/Car.tscn")

var tracks = []
var car

func _ready():
    
    var track0 = Track.instance()
    var coords0 = [
        Vector2(0, 0),
        Vector2(0, 4),
        Vector2(3, 4),
        Vector2(3, 0)
    ]
    track0.generate_tiles(coords0)
    tracks.append(track0)
    add_child(track0)
    var coords1 = [
        Vector2(0, 0),
        Vector2(3, 0),
        Vector2(3, 4),
        Vector2(6, 4),
        Vector2(6, 6),
        Vector2(0, 6)
    ]
    for c_idx in len(coords1):
        coords1[c_idx] += Vector2(7, 3)
    var track1 = Track.instance()
    track1.generate_tiles(coords1)
    tracks.append(track1)
    add_child(track1)
    car = Car.instance()
    add_child(car)
