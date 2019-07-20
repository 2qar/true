extends KinematicBody2D

onready var colors : Node2D = get_node("/root/colors")
export(int, "Red", "Blue", "Green") var color
var level_color : int

export(int) var move_speed
export(int) var jump_height

var movement : Vector2
onready var start : Vector2 = position
onready var start_color : int = color

func _ready():
	$Sprite.texture = colors.sprites[color]

func _physics_process(delta):
	movement.y += 10
	
	if Input.is_action_just_pressed("left"):
		$Sprite.texture = colors.sprites[color]
		set_sprite(2)
	if Input.is_action_just_pressed("right"):
		set_sprite(1)

	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("left"):
			movement.x = -move_speed
		if Input.is_action_pressed("right"):
			movement.x = move_speed
	else:
		movement.x = 0
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		set_sprite(0)
		movement.y = -jump_height

	movement = move_and_slide(movement, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name != colors.names[color]:
			restart()

	if color == level_color:
		restart()

func set_sprite(c: int):
	$Sprite.texture = colors.sprites[c]
	color = c

func restart():
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