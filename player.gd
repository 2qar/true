extends KinematicBody2D

var modulates = [Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 0.0, 1.0)]
var colors = ["red", "blue", "green"]
export(int, "Red", "Blue", "Green") var color

var movement : Vector2
onready var start : Vector2 = position
onready var start_color : int = color

func _ready():
	$Sprite.modulate = modulates[color]

func _physics_process(delta):
	movement.y += 10
	
	if Input.is_action_just_pressed("left"):
		$Sprite.modulate = Color(0.0, 1.0, 0.0, 1.0)
		color = 2
	if Input.is_action_just_pressed("right"):
		$Sprite.modulate = Color(0.0, 0.0, 1.0, 1.0)
		color = 1

	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("left"):
			movement.x = -200
		if Input.is_action_pressed("right"):
			movement.x = 200
	else:
		movement.x = 0
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
		color = 0
		movement.y = -450

	movement = move_and_slide(movement, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name != colors[color]:
			position = start
			$Sprite.modulate = modulates[start_color]
			color = start_color
			Input.action_release("left")
			Input.action_release("right")