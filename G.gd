extends Node

var tilesize = 32

#var trackspeed = 100
#var jumpspeed = 100
var trackspeed = 250
var jumpspeed = 250

var rot_speed = 12

var min_car_y = -80
var max_car_y = 720

var halfscreensize = Vector2(480, 320)
var screensize = Vector2(960, 640)

var levels = []
var next_lvl_idx
var next_lvl
var rubies = 0
var ruby_goal = 0

var bin_margin = 0
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

func add_ruby():
    rubies += 1
    print("You now have " + str(rubies) + " rubies. Goal: " + str(ruby_goal))
    if rubies == ruby_goal:
        G.set_next_level(G.next_lvl_idx + 1)

func set_next_level(nli):
    next_lvl_idx = nli % len(levels)
    next_lvl = levels[next_lvl_idx]
    ruby_goal += len(next_lvl.get_rubies())

func reset():
    rubies = 0
    ruby_goal = 0
