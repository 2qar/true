extends Node2D

var pressed : bool

func _ready():
	$key.position = Vector2(0, 0)

func _on_press_timeout():
	if not pressed:
		pressed = true
		$key.position.y = 1
	else:
		pressed = false
		$key.position.y = 0
