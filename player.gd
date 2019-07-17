extends KinematicBody2D

var sprites = [preload("res://red.png"), preload("res://blue.png"), preload("res://green.png")]
var modulates : PoolColorArray = []
var colors = ["red", "blue", "green"]
export(int, "Red", "Blue", "Green") var color
export(int, "Red", "Blue", "Green") var level_color

export(int) var move_speed
export(int) var jump_height

var movement : Vector2
onready var start : Vector2 = position
onready var start_color : int = color

func _ready():
	for sprite in sprites:
		var data = sprite.get_data()
		data.lock()
		modulates.append(data.get_pixel(4, 4).to_html())
		data.unlock()

	VisualServer.set_default_clear_color(modulates[level_color])
	$Sprite.texture = sprites[color]

func _physics_process(delta):
	movement.y += 10
	
	if Input.is_action_just_pressed("left"):
		$Sprite.texture = sprites[color]
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
		if collision.collider.name != colors[color]:
			restart()

	if color == level_color:
		restart()

func set_sprite(c: int):
	$Sprite.texture = sprites[c]
	color = c

func restart():
	movement = Vector2()
	position = start
	set_sprite(start_color)
	Input.action_release("left")
	Input.action_release("right")