extends Node2D

var Wrapping = preload("res://scenes/Wrapping.gd")

var limits = []
var sprite_copies = {}

func _init(lims):
    limits = lims
    position.x = limits[0]

func add_sprite_child(spr, original):
    add_child(spr)
    sprite_copies[spr] = original

func remove():
    var children = get_children()
    for c in children:
        var original = sprite_copies.get(c, null)
        if original != null and original is Wrapping:
            original.remove_sprite_copy(c)
        else:
            c.queue_free()
    queue_free()
