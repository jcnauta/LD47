extends Node2D

var Track = preload("res://scenes/Track.tscn")
var LevelBin = preload("res://LevelBin.gd")

var level_bins = []
var tracks = []
var items = []
var wrap_width

func _init(shapes, offsets, ww):
    wrap_width = ww
    for idx in len(shapes):
        var the_shape = shapes[idx]
        var the_offsets = offsets[idx]
        for off in the_offsets:
            var track_coords = []
            for jdx in len(the_shape):
                track_coords.append(the_shape[jdx] + off)
            var track = Track.instance()
            track.generate_tiles(track_coords)
            tracks.append(track)
            add_child(track)

func _process(delta):
    for track in tracks:
        track.update_wrap()
    for item in items:
        item.update_wrap()

func add_level_bin(x_min):
    var new_bin = LevelBin.new([x_min, x_min + wrap_width])
    for track in tracks:
        track.add_to_bin(new_bin)
    for item in items:
        item.add_to_bin(new_bin)
    add_child(new_bin)

func remove_level_bin(bin):
    remove_child(bin)
    bin.queue_free()
