extends "res://scenes/Wrapping.gd"

var coords

func _ready():
    the_texture = load("res://images/ruby1.png")
    set_coords(Vector2(0, 5))
    print(position)

func update_wrap():
    var cam_center = G.camera.get_camera_screen_center()
    update_collision_position(cam_center)

func set_coords(c):
    self.coords = c
    self.position = G.tilesize * c

func _process(delta):
    update_wrap()
