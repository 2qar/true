extends Node2D

var sprites = []
var running = []
var jumping = []
var colors : PoolColorArray = []
var names = ["red", "blue", "green"]

func _ready():
	for name in ["red", "blue", "green"]:
		var sprite = load("res://%s.png" % name)
		sprites.append(sprite)
		running.append(load("res://%s_run.png" % name))
		jumping.append(load("res://%s_jump.png" % name))
		var data = sprite.get_data()
		data.lock()
		colors.append(data.get_pixel(4, 4))
		data.unlock()