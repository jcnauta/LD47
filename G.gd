extends Node

var tilesize = 32
var flyspeed = 150
var trackspeed = 300
var jumpspeed = 200
var rot_speed = 12

var min_car_y = -100
var max_car_y = 1100

var wrap_width
var level_tile_width

var camera

func set_level_width(level_tile_width):
    self.level_tile_width = level_tile_width
    wrap_width = floor(level_tile_width / 2) + 1

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    var result = fmod(2 * difference, max_angle) - difference
    return result

func lerp_angle(from, to, step):
    var dir = sign(short_angle_dist(from, to))
    var result = from + dir * step
    var short_angle = short_angle_dist(result, to)
    if sign(short_angle) == dir:
        return result
    else:
        return to
