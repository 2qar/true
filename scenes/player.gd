extends KinematicBody2D

onready var death_particles = preload("res://scenes/death_particles.tscn")
onready var colors : Node2D = get_node("/root/colors")
export(int, "Red", "Blue", "Green") var color
var level_color : int

export(int) var move_speed
export(int) var jump_height

var movement : Vector2
onready var start : Vector2 = position
onready var start_color : int = color

var jumping : bool

onready var step_time = $step_timer.wait_time

func _ready():
	$Sprite.texture = colors.sprites[color]

func _process(delta):
	if $Sprite.hframes > 1 and $run_timer.is_stopped():
		if $Sprite.frame < $Sprite.hframes - 1:
			$Sprite.frame += 1
		else:
			$Sprite.frame = 0
		$run_timer.start()
		yield($run_timer, "timeout")
		$run_timer.stop()

	if $step_timer.is_stopped() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and is_on_floor():
		if color == 0:
			$step_timer.wait_time = $run_timer.wait_time
		else:
			$step_timer.wait_time = step_time
		$step.play()
		$step_timer.start()
		yield($step_timer, "timeout")
		$step_timer.stop()

func _physics_process(delta):
	movement.y += 10

	# AAAAAAAAAA
	if movement.x != 0 and color == 0 and is_on_floor() and $Sprite.texture != colors.running[0]:
		set_run(0)
	
	if Input.is_action_just_pressed("left"):
		set_run(2)
	if Input.is_action_just_pressed("right"):
		set_run(1)
	if Input.is_action_just_released("right"):
		if color == 1:
			set_sprite(1)
		elif color == 0:
			set_sprite(0)
		movement.x = 0
	elif Input.is_action_just_released("left"):
		if color == 2:
			set_sprite(2)
		elif color == 0:
			set_sprite(0)
		movement.x = 0

	if Input.is_action_pressed("left"):
		if color != 0 and not jumping:
			$Sprite.texture = colors.running[2]
			$Sprite.hframes = colors.running[2].get_width() / 8
			color = 2
		movement.x = -move_speed
	if Input.is_action_pressed("right"):
		if color != 0 and not jumping:
			$Sprite.texture = colors.running[1]
			$Sprite.hframes = colors.running[1].get_width() / 8
			color = 1
		movement.x = move_speed

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		set_sprite(0)
		movement.y = -jump_height
		jumping = true
		$jump.play()

	movement = move_and_slide(movement, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name != colors.names[color]:
			restart()
		elif jumping and is_on_floor():
			jumping = false
			set_sprite(color)

	if color == level_color:
		restart()

	if movement.y != 0:
		$Sprite.texture = colors.jumping[color]
		$Sprite.hframes = 1
		$Sprite.frame = 0
	elif movement.y == 0 and movement.x == 0 and $Sprite.texture != colors.sprites[color]:
		set_sprite(color)

func set_sprite(c: int):
	color = c
	$Sprite.texture = colors.sprites[c]
	$Sprite.hframes = 1
	$Sprite.frame = 0

func set_run(c: int):
	color = c
	var run = colors.running[c]
	$Sprite.texture = run
	$Sprite.frame = 0
	$Sprite.hframes = run.get_width() / 8

func restart():
	var explosion : CPUParticles2D = death_particles.instance()
	get_parent().add_child(explosion)
	explosion.position = position
	explosion.color = colors.colors[color]
	explosion.emitting = true
	$hit.play()
	colors.deaths += 1
	movement = Vector2()
	position = start
	set_sprite(start_color)
	Input.action_release("left")
	Input.action_release("right")

func stop_moving():
	Input.action_release("left")
	Input.action_release("right")

func set_enabled(enabled : bool):
	set_physics_process(enabled)
	set_process(enabled)
	visible = enabled