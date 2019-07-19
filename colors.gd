extends Node2D

var sprites = []
var colors : PoolColorArray = []
var names = ["red", "blue", "green"]

func _ready():
	for name in ["red", "blue", "green"]:
		var sprite = load("res://" + name + ".png")
		sprites.append(sprite)
		var data = sprite.get_data()
		data.lock()
		colors.append(data.get_pixel(4, 4))
		data.unlock()