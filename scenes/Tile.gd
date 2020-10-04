extends "res://scenes/Wrapping.gd"

var coords
var in_outs
var next_t
var prev_t
var sprite_corner = preload("res://images/round_rail.png")
var sprite_horz = preload("res://images/horizontal_rail.png")
var sprite_vert = preload("res://images/vertical_rail.png")
var track
var collision_area

func _ready():
    collision_area = $Area2D

func set_coords(c):
    self.coords = c
    self.position = G.tilesize * c

func set_in_outs(in_outs):
    self.in_outs = in_outs

func set_prev_and_next(prev_t, next_t):
    self.prev_t = prev_t
    self.next_t = next_t
    set_sprite()

func set_sprite():
    var to_next = next_t.position - position
    var to_prev = prev_t.position - position
    if to_next.x > 0:
        if to_prev.y < 0:
            the_texture = sprite_corner
            the_rotation = PI
        elif to_prev.y > 0:
            the_texture = sprite_corner
            the_rotation = -0.5 * PI
        else:
            the_texture = sprite_horz
    elif to_next.x < 0:
        if to_prev.y < 0:
            the_texture = sprite_corner
            the_rotation = 0.5 * PI
        elif to_prev.y > 0:
            the_texture = sprite_corner
        else:
            the_texture = sprite_horz
    elif to_next.y < 0:
        if to_prev.x < 0:
            the_texture = sprite_corner
            the_rotation = 0.5 * PI
        elif to_prev.x > 0:
            the_texture = sprite_corner
            the_rotation = PI
        else:
            the_texture = sprite_vert
    elif to_next.y > 0:
        if to_prev.x < 0:
            the_texture = sprite_corner
        elif to_prev.x > 0:
            the_texture = sprite_corner
            the_rotation = -0.5 * PI
        else:
            the_texture = sprite_vert
    for spr in sprite_copies:
        spr.texture = the_texture
        spr.rotation = the_rotation
