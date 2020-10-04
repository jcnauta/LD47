extends Node2D

var coords
var in_outs
var next_t
var prev_t
var sprite_corner = preload("res://images/round_rail.png")
var sprite_horz = preload("res://images/horizontal_rail.png")
var sprite_vert = preload("res://images/vertical_rail.png")

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
    print("setting sprite!")
    var to_next = next_t.position - position
    var to_prev = prev_t.position - position
    if to_next.x > 0:
        if to_prev.y < 0:
            $Sprite.texture = sprite_corner
            rotation = PI
        elif to_prev.y > 0:
            $Sprite.texture = sprite_corner
            rotation = -0.5 * PI
        else:
            $Sprite.texture = sprite_horz
    elif to_next.x < 0:
        if to_prev.y < 0:
            $Sprite.texture = sprite_corner
            rotation = 0.5 * PI
        elif to_prev.y > 0:
            $Sprite.texture = sprite_corner
        else:
            $Sprite.texture = sprite_horz
    elif to_next.y < 0:
        if to_prev.x < 0:
            $Sprite.texture = sprite_corner
            rotation = 0.5 * PI
        elif to_prev.x > 0:
            $Sprite.texture = sprite_corner
            rotation = PI
        else:
            $Sprite.texture = sprite_vert
    elif to_next.y > 0:
        if to_prev.x < 0:
            $Sprite.texture = sprite_corner
        elif to_prev.x > 0:
            $Sprite.texture = sprite_corner
            rotation = -0.5 * PI
        else:
            $Sprite.texture = sprite_vert
