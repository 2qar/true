extends Node2D

func _ready():
	if get_parent().name != "root":
		$player.set_enabled(false)