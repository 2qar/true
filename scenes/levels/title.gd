extends Node2D

var started : bool

func _ready():
	if get_parent().name != "root":
		set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("jump") and not started:
		started = true
		$key.visible = false
		$start.play()
		$start_timer.start()
		yield($start_timer, "timeout")
		get_tree().change_scene("res://scenes/main.tscn")
