extends Node2D

var sprites = []
var running = []
var jumping = []
var colors : PoolColorArray = []
var names = ["red", "blue", "green"]
var deaths : int

func _ready():
	for name in ["red", "blue", "green"]:
		var sprite = load("res://sprites/%s.png" % name)
		sprites.append(sprite)
		running.append(load("res://sprites/%s_run.png" % name))
		jumping.append(load("res://sprites/%s_jump.png" % name))
		var data = sprite.get_data()
		data.lock()
		colors.append(data.get_pixel(4, 4))
		data.unlock()