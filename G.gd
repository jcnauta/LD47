extends Node

var tilesize = 32
var flyspeed = 300
var trackspeed = 250
var jumpspeed = 250
var rot_speed = 12

var min_car_y = -80
var max_car_y = 720

var halfscreensize = Vector2(480, 320)
var screensize = Vector2(960, 640)

var camera

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
