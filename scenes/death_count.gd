extends Node2D

onready var colors = get_node("/root/colors")

func _process(delta):
	$bg.text = str(colors.deaths)
	$front.text = str(colors.deaths)
