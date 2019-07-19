extends Area2D

onready var colors = get_node("/root/colors").colors
export(int, "Red", "Blue", "Green") var color

func _ready():
	$color.color = colors[color]

func _on_background_body_entered(body):
	if body.name == "player":
		body.level_color = color
