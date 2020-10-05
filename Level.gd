extends Node2D

var Pickup = preload("res://scenes/Pickup.tscn")
var PickupClass = preload("res://scenes/Pickup.gd")
var Pain = preload("res://scenes/Pain.tscn")
var Track = preload("res://scenes/Track.tscn")
var LevelBin = preload("res://LevelBin.gd")

var level_bins = []
var tracks = []
var items = []
var wrap_width

func _init(shapes, offsets, ruby_coords, pain_coords, ww):
    pass
#    wrap_width = ww
#    for idx in len(shapes):
#        var the_shape = shapes[idx]
#        var the_offsets = offsets[idx]
#        for off in the_offsets:
#            var track_coords = []
#            for jdx in len(the_shape):
#                track_coords.append(the_shape[jdx] + off)
#            var track = Track.instance()
#            track.generate_tiles(track_coords)
#            tracks.append(track)
#            add_child(track)
#    for r in ruby_coords:
#        var ruby = Pickup.instance()
#        ruby.set_coords(r)
#        items.append(ruby)
#        add_child(ruby)
#    for p in pain_coords:
#        var pain = Pain.instance()
#        pain.set_coords(p)
#        items.append(pain)
#        add_child(pain)

func get_next_track_tile(tiles, coord):
    if coord.x + 1 < len(tiles[0]) and tiles[coord.y][coord.x + 1] == 1:
        return Vector2(coord.x + 1, coord.y)
    elif coord.x - 1 >= 0 and tiles[coord.y][coord.x - 1] == 1:
        return Vector2(coord.x - 1, coord.y)
    elif coord.y + 1 < len(tiles) and tiles[coord.y + 1][coord.x] == 1:
        return Vector2(coord.x, coord.y + 1)
    elif coord.y - 1 >= 0 and tiles[coord.y - 1][coord.x] == 1:
        return Vector2(coord.x, coord.y - 1)
    else: return null

func yank_track_from_tiles(tiles):
    var track_coords = []
    for y in len(tiles):
        for x in len(tiles[0]):
            if tiles[y][x] == 1: # Start of track!
                track_coords.append(Vector2(x, y))
                tiles[y][x] = 0 # Erase the tile
                var current_coords = Vector2(x, y)
                while current_coords != null:
                    track_coords.append(current_coords)
                    tiles[current_coords.y][current_coords.x] = 0
                    current_coords = get_next_track_tile(tiles, current_coords)
                return [track_coords, []]
    return null

func build_from_data(track_layers):
    for tiles in track_layers:
        # identify tracks one by one, remove when adding to level
        wrap_width = G.tilesize * len(tiles[0])
        var new_track_coords_and_twisties = yank_track_from_tiles(tiles)
        print(new_track_coords_and_twisties)
        while new_track_coords_and_twisties != null:
            var track = Track.instance()
            track.generate_tiles(new_track_coords_and_twisties[0], new_track_coords_and_twisties[1])
            tracks.append(track)
            add_child(track)
            new_track_coords_and_twisties = yank_track_from_tiles(tiles)
            print(new_track_coords_and_twisties)

func _process(delta):
    for track in tracks:
        track.update_wrap()
    for item in items:
        if item != null and is_instance_valid(item):
            item.update_wrap()

func add_level_bin(x_min):
    var new_bin = LevelBin.new([x_min, x_min + wrap_width])
    for track in tracks:
        track.add_to_bin(new_bin)
    for item in items:
        if item != null and is_instance_valid(item):
            item.add_to_bin(new_bin)
    add_child(new_bin)
    return new_bin

func remove_level_bin(bin):
    print("removing!")
    remove_child(bin)
    bin.remove()
