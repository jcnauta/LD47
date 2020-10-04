extends Node2D

var Track = preload("res://scenes/Track.tscn")
var Car = preload("res://scenes/Car.tscn")
var Pickup = preload("res://scenes/Pickup.tscn")
var Level = preload("res://Level.gd")
var LevelBin = preload("res://LevelBin.gd")

var x_to_bin = {}
var min_x_binned = 0
var max_x_binned = 0
var levels
var car

func _ready():
    levels = create_levels()
    for level in levels:
        add_child(level)
    levels[0].add_level_bin(0)
    car = Car.instance()
    add_child(car)

func get_left_bin():
    return x_to_bin.get(min_x_binned, null)

func get_right_bin():
    var max_x = -INF
    for x in x_to_bin.keys():
        if x > max_x: x = max_x
    return x_to_bin.get(max_x, null)

func _process(delta):
    var cam_center = G.camera.get_camera_screen_center()
    var margins = [cam_center.x - G.halfscreensize.x - G.bin_margin, 
            cam_center.x + G.halfscreensize.x + G.bin_margin]
    # Remove bins if required
    var left_bin = get_left_bin()
    if left_bin != null:
        var new_min_x_binned = min_x_binned + left_bin.get_parent().wrap_width
        if new_min_x_binned < margins[0]: # remove leftmost bin
            left_bin.get_parent().remove_level_bin(left_bin)
    var right_bin = get_right_bin()
    if right_bin != null:
        var new_max_x_binned = right_bin.position
        if new_max_x_binned > margins[1].x: # remove rightmost bin
            right_bin.get_parent().remove_level_bin(right_bin)
    # Add bins if required
    var next_level = levels[G.next_lvl_idx]
    var width = next_level.wrap_width
    if margins[0] < min_x_binned:
        next_level.add_level_bin(min_x_binned - width)
        min_x_binned = min_x_binned - width
    if margins[1] > max_x_binned:
        next_level.add_level_bin(max_x_binned + width)
        max_x_binned = max_x_binned + width

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
    var rect_offsets = [Vector2(3, 1), Vector2(10, 8), Vector2(22, 2),
                Vector2(3, 15), Vector2(12, 16), Vector2(22, 14)]
    var level_0 = Level.new([rect_shape], [rect_offsets], 900)
    # BIG PLUSES
    var plus_offsets = [Vector2(3, 1), Vector2(10, 8), Vector2(22, 2),
            Vector2(3, 15), Vector2(12, 16), Vector2(22, 14)]
    var level_1 = Level.new([plus_shape], [plus_offsets], 1200)
    var levels = [level_0, level_1]
    return levels
