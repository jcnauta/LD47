extends Node2D

var coords
var in_outs
var next_t
var prev_t
var sprite_corner = preload("res://images/round_rail.png")
var sprite_horz = preload("res://images/horizontal_rail.png")
var sprite_vert = preload("res://images/vertical_rail.png")
var the_texture
var the_rotation = 0.0
var sprite_copies = {}
var wrap_width
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
    print(the_rotation)
    print(the_texture)
    for spr in sprite_copies:
        spr.texture = the_texture
        print("set rotation")
        print(the_rotation)
        spr.rotation = the_rotation

func draw_copies(margins):
    var N_copies_left = floor((margins[0].x - position.x) / track.wrap_width)
    var N_copies_right = ceil((margins[1].x - position.x) / track.wrap_width)
    # Remove far-away copies
    var to_remove = []
    for k in sprite_copies.keys():
        if not k in range(N_copies_left, N_copies_right + 1):
            to_remove.append(k)
    for r in to_remove:
        sprite_copies.erase(r)
    for N in range(N_copies_left, N_copies_right + 1):
        if not sprite_copies.has(N):
            var new_sprite = Sprite.new()
            new_sprite.texture = the_texture
            new_sprite.rotation = the_rotation
            new_sprite.position = N * Vector2(track.wrap_width, 0)
            add_child(new_sprite)
            sprite_copies[N] = new_sprite

func update_collision_position(cam_center):
    # Identify the sprite-position closest to the center
    var N = (cam_center.x - position.x) / track.wrap_width
    var N_left = floor(N)
    var N_right = ceil(N)
    var d_left = abs(position.x + N_left * track.wrap_width - cam_center.x)
    var d_right = abs(position.x + N_right * track.wrap_width - cam_center.x)
    if d_left < d_right:
        $Area2D.position.x = N_left * track.wrap_width
    else:
        $Area2D.position.x = N_right * track.wrap_width
