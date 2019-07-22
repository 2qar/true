extends Control

onready var viewports = [get_node("background/Viewport"), get_node("inactive/Viewport"), get_node("active/Viewport")]
var bg_world_num : int

func _ready():
	add_to_group("main")
	get_tree().call_group("switcheroo", "connect", "swap_player", self, "_on_swap_player")
	get_tree().call_group("switcheroo", "connect", "shift_worlds", self, "_on_shift_worlds")
	
	var player = viewports[2].get_child(0).get_node("player")
	player.set_enabled(true)

func _on_swap_player(player : KinematicBody2D):
	var world = viewports[1].get_child(0)
	if world:
		var new_player = world.get_node("player")
		new_player.set_enabled(true)
		new_player.position = player.position
	player.set_enabled(false)
	player.queue_free()

func _shift_world(old_parent : Node, new_parent : Node):
	var world = old_parent.get_child(0)
	if world:
		world.get_parent().remove_child(world)
		new_parent.add_child(world)

func _on_shift_worlds():
	viewports[2].get_child(0).get_node("Camera2D").current = false
	viewports[2].get_child(0).queue_free()
	_shift_world(viewports[1], viewports[2])
	_shift_world(viewports[0], viewports[1])
	bg_world_num += 1
	var world = load("res://scenes/levels/world%d.tscn" % bg_world_num)
	if world:
		viewports[0].add_child(world.instance())
		var switcheroo = viewports[0].get_child(0).get_node("switcheroo")
		switcheroo.connect("swap_player", self, "_on_swap_player")
		switcheroo.connect("shift_worlds", self, "_on_shift_worlds")
