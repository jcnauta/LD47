extends "res://scenes/Wrapping.gd"

var disabled = false

func _ready():
    the_texture = load("res://icon.png")

func update_wrap():
    var cam_center = G.camera.get_camera_screen_center()
    var margins = [cam_center - G.halfscreensize, cam_center + G.halfscreensize]
    draw_copies(margins, wrap_width)
    update_collision_position(cam_center)

func draw_copies(margins, wrap_width):
    .draw_copies_wrapped(margins, wrap_width, the_texture)

func disable():
    disabled = true
    
func enable():
    disabled = false

func _process(delta):
    update_wrap()
