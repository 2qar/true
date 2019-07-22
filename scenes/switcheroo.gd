extends Area2D

signal swap_player
signal shift_worlds

func _ready():
	add_to_group("switcheroo")
	$rotate.play("rotate")

func _on_switcheroo_body_entered(body):
	if body.name == "player":
		$CollisionShape2D.call_deferred("set_disabled", true)
		body.stop_moving()

		$swap_sound.play()
		emit_signal("swap_player", body)
		$expand.interpolate_property($mask, "texture_scale", $mask.texture_scale, 30, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$expand.start()
		yield($expand, "tween_completed")

		emit_signal("shift_worlds")
