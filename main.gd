extends Control

onready var viewports = [get_node("background/Viewport"), get_node("inactive/Viewport"), get_node("active/Viewport")]

func _ready():
	add_to_group("main")
	get_tree().call_group("switcheroo", "connect", "swap_player", self, "_on_swap_player")
	get_tree().call_group("switcheroo", "connect", "shift_worlds", self, "_on_shift_worlds")
	
	var player = viewports[2].get_node("world/player")
	player.set_enabled(true)

func _on_swap_player(player : KinematicBody2D):
	var new_player = viewports[1].get_child(0).get_node("player")
	new_player.set_enabled(true)
	new_player.position = player.position
	player.set_enabled(false)
	player.queue_free()

func _shift_world(old_parent : Node, new_parent : Node):
	var world = old_parent.get_child(0)
	world.get_parent().remove_child(world)
	new_parent.add_child(world)

func _on_shift_worlds():
	viewports[2].get_child(0).get_node("Camera2D").current = false
	viewports[2].get_child(0).queue_free()
	_shift_world(viewports[1], viewports[2])
	_shift_world(viewports[0], viewports[1])
