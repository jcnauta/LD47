extends Node2D

var coords
var in_outs

func set_coords(c):
    self.coords = c
    self.position = G.tilesize * c

func set_in_outs(in_outs):
    self.in_outs = in_outs

#func _process(delta):
#    var cam_center = G.camera.get_camera_screen_center()
#    if position.x > cam_center.x + G.wrap_width * G.tilesize:
#        position.x -= G.level_tile_width * G.tilesize
#    elif position.x < cam_center.x - G.wrap_width * G.tilesize:
#        position.x += G.level_tile_width * G.tilesize
