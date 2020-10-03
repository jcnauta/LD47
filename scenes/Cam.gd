extends Node2D

var target

var margins_x = [-50, 50]
var margins_y = [-50, 50]
var smoothing = 4

func set_target(target):
    self.target = target

func _process(delta):
    var d = target.position - self.position
    if d.x > margins_x[1]:
        self.position += smoothing * (d.x - margins_x[1])
    elif d.x < margins_x[0]:
        self.position += smoothing * (d.x - margins_x[0])
