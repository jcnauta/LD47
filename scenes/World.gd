extends Node2D

var Track = preload("res://scenes/Track.tscn")
var Car = preload("res://scenes/Car.tscn")
var Level = preload("res://Level.gd")
var LevelBin = preload("res://LevelBin.gd")

var lvl_0_data = preload("res://levels/0.gd")
var lvl_1_data = preload("res://levels/1.gd")
var lvl_5_data = preload("res://levels/5.gd")

var levels = []
var x_to_bin = {}
var min_x_binned = 0
var max_x_binned = 0

var car

func _ready():
    create_levels()
    for level in G.levels:
        add_child(level)
    G.set_next_level(0)
    car = Car.instance()
    add_child(car)

func get_left_bin():
    return x_to_bin.get(get_min_x_bin_key(), null)

func get_right_bin():
    return x_to_bin.get(get_max_x_bin_key(), null)

func get_min_x_bin_key():
    var min_x = INF
    for x in x_to_bin.keys():
        if x < min_x: min_x = x
    return min_x

func get_max_x_bin_key():
    var max_x = -INF
    for x in x_to_bin.keys():
        if x > max_x: max_x = x
    return max_x

func update_min_max_binned():
    min_x_binned = INF
    max_x_binned = -INF
    for x in x_to_bin.keys():
        if x < min_x_binned:
            min_x_binned = x
        var bin_right_x = x_to_bin[x]["limits"][1]
        if bin_right_x  > max_x_binned:
            max_x_binned = bin_right_x

func erase_left_bin():
    var left_bin = get_left_bin()
    left_bin.get_parent().remove_level_bin(left_bin)
    x_to_bin.erase(get_min_x_bin_key())
    update_min_max_binned()

func erase_right_bin():
    print("Erasing right bin!")
    var right_bin = get_right_bin()
    right_bin.get_parent().remove_level_bin(right_bin)
    var max_x = get_max_x_bin_key()
    x_to_bin.erase(max_x)
    update_min_max_binned()

func _process(delta):
    var cam_center = G.camera.get_camera_screen_center()
    var margins = [cam_center.x - G.halfscreensize.x - G.bin_margin, 
            cam_center.x + G.halfscreensize.x + G.bin_margin]
    # Remove bins if required
    var left_bin = get_left_bin()
    if left_bin != null:
        var new_min_x_binned = min_x_binned + left_bin.get_parent().wrap_width
        if new_min_x_binned < margins[0]: # remove leftmost bin
            erase_left_bin()
    var right_bin = get_right_bin()
    if right_bin != null:
        var new_max_x_binned = right_bin.position.x
        if new_max_x_binned > margins[1]: # remove rightmost bin
            erase_right_bin()
#            right_bin.get_parent().remove_level_bin(right_bin)
#            var lvl = right_bin.get_parent()
#            if lvl != null:
#                lvl.remove_level_bin(right_bin)
#            max_x_binned = new_max_x_binned
    # Add bins if required
    var next_level = G.levels[G.next_lvl_idx]
    var width = next_level.wrap_width
    if margins[0] < min_x_binned:
        var new_x = min_x_binned - width
        var new_bin = next_level.add_level_bin(new_x)
        min_x_binned = new_x
        x_to_bin[new_x] = new_bin
    if margins[1] > max_x_binned:
        var new_x = max_x_binned
        var new_bin = next_level.add_level_bin(new_x)
        max_x_binned = max_x_binned + width
        x_to_bin[new_x] = new_bin

func create_levels():
    var rect_shape = [
        Vector2(0, 0),
        Vector2(6, 0),
        Vector2(6, 5),
        Vector2(0, 5)
    ]
    var plus_shape= [
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
    var small_shape = [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(1, 1),
        Vector2(0, 1)
    ]
    var rect_offsets_0 = [Vector2(3, 1), Vector2(10, 8), Vector2(22, 2)]
    var plus_offsets_0 = [Vector2(3, 15), Vector2(12, 16), Vector2(22, 14)]
    var ruby_coords = [Vector2(0, 4), Vector2(4, 12)]
    var pain_coords = [Vector2(0, 15), Vector2(15, 4)]
    var level_0 = Level.new()
    level_0.build_from_data(lvl_0_data.new().tracks)
    # BIG PLUSES
    var plus_offsets = [Vector2(3, 1), Vector2(10, 8), Vector2(22, 2),
            Vector2(3, 15), Vector2(12, 16), Vector2(22, 14)]
    var level_1 = Level.new()
    level_1.build_from_data(lvl_1_data.new().tracks)
    var level_5 = Level.new()
    level_5.build_from_data(lvl_5_data.new().tracks)
    G.levels = [level_0, level_1, level_5]
