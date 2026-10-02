extends AnimatedSprite2D

@onready var body = get_parent()


func _process(_delta: float) -> void:
	flip_h = body.facing < 0

	if body.is_dashing or not body.is_on_floor():
		play("jump")
	elif abs(body.velocity.x) > 10.0:
		play("run")
	else:
		play("idle")
