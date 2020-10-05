extends "res://scenes/Wrapping.gd"

var coords

func _ready():
    the_texture = load("res://images/axe.png")

func update_wrap():
    var cam_center = G.camera.get_camera_screen_center()
    update_collision_position(cam_center)

func set_coords(c):
    self.coords = c
    self.position = G.tilesize * c

func _process(delta):
    $Area2D.rotation -= 5.0 * delta
    for spr in sprite_copies:
        spr.rotate(-5.0 * delta)
    update_wrap()
