extends CPUParticles2D

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()
