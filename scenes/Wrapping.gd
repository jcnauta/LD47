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
    bin.add_sprite_child(new_sprite, self)
#    bin.add_child(new_sprite)
    sprite_copies.append(new_sprite)

func remove_sprite_copy(spr):
    sprite_copies.remove(sprite_copies.find(spr))

func remove():
    for c in sprite_copies:
        if c != null and is_instance_valid(c):
            c.queue_free()
    sprite_copies.clear()
    queue_free()

func update_collision_position(cam_center):
    # Identify the sprite-position closest to the center that is currently visible
    var collision_children = $Area2D.get_children()
    if len(sprite_copies) == 0:
        for c in collision_children:
            c.disabled = true
    else:
        for c in collision_children:
            c.disabled = false
        var min_d = INF
        var collision_spr
        for spr in sprite_copies:
            if spr != null and is_instance_valid(spr):
                var d_N = abs(spr.get_parent().position.x + spr.position.x - cam_center.x)
                if d_N < min_d:
                    collision_spr = spr
                    min_d = d_N
        if collision_spr != null:
            $Area2D.position.x = collision_spr.get_parent().position.x
        else:
            print("Warning: collision shape should not have been null...")
