extends Node2D

var sprite_copies = []
var wrap_width
var wrap_limits = []
var the_texture
var the_rotation = 0.0

func add_to_bin(bin):
    var new_sprite = Sprite.new()
    new_sprite.texture = the_texture
    new_sprite.rotation = the_rotation
    new_sprite.position = position
    bin.add_child(new_sprite)
    sprite_copies.append(new_sprite)

#func set_wrap_limits(limits):
#    wrap_limits = limits
#
#func set_wrap_width(ww):
#    wrap_width = ww

#func draw_copies_wrapped(margins, wrap_width, the_texture, the_rotation = 0.0):
#    var N_copies_left = floor((margins[0].x - position.x) / wrap_width)
#    var N_copies_right = ceil((margins[1].x - position.x) / wrap_width)
#    var to_remove = []
#    # Remove far-away copies
#    for k in sprite_copies.keys():
#        if not k in range(N_copies_left, N_copies_right + 1): # if far away, remove
#            to_remove.append(k)
#            # update level area limits
#            G.tighten_level_limits()
#        else: # if outside current level_area limits, also remove
#            var maybe_out_x = position.x + k * wrap_width
#            var keep = false
#            for l in wrap_limits:
#                if maybe_out_x > l[0] and maybe_out_x < l[1]:
#                    keep = true
#            if keep == false:
#                to_remove.append(k)
#    for r in to_remove:
#        sprite_copies.erase(r)
#    # Add new copies
#    for N in range(N_copies_left, N_copies_right + 1):
#        if not sprite_copies.has(N):
#            var maybe_out_x = position.x + N * wrap_width
#            var allowed = false
#            for l in wrap_limits:
#                if maybe_out_x > l[0] and maybe_out_x < l[1]:
#                    allowed = true
#            if allowed:
#                var new_sprite = Sprite.new()
#                new_sprite.texture = the_texture
#                new_sprite.rotation = the_rotation
#                new_sprite.position = N * Vector2(wrap_width, 0)
#                add_child(new_sprite)
#                sprite_copies[N] = new_sprite

func update_collision_position(cam_center):
    # Identify the sprite-position closest to the center that is currently visible
    if len(sprite_copies) == 0:
        $Area2D.get_node("CollisionShape2D").disabled = true
    else:
        $Area2D.get_node("CollisionShape2D").disabled = false
        var min_d = INF
        var collision_spr
        for spr in sprite_copies:
            var d_N = abs(spr.get_parent().position.x + spr.position.x - cam_center.x)
            if d_N < min_d:
                collision_spr = spr
                min_d = d_N
        $Area2D.position.x = collision_spr.get_parent().position.x
