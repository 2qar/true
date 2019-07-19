extends Area2D

export(int, "Red", "Blue", "Green") var switch_color

func _ready():
	$rotate.play("rotate")

func _on_switcheroo_body_entered(body):
	if body.name == "player":
		body.set_sprite(switch_color)
		body.start_color = switch_color
		body.start = position
		
		$expand.interpolate_property($mask, "texture_scale", $mask.texture_scale, 30, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$expand.start()