extends Area2D

export(int, "Red", "Blue", "Green") var switch_color

signal swap_player
signal shift_worlds

func _ready():
	add_to_group("switcheroo")
	$rotate.play("rotate")

func _on_switcheroo_body_entered(body):
	if body.name == "player":
		body.stop_moving()

		emit_signal("swap_player", body)
		$expand.interpolate_property($mask, "texture_scale", $mask.texture_scale, 30, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$expand.start()
		yield($expand, "tween_completed")

		emit_signal("shift_worlds")
