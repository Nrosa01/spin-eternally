extends PhysicAlgorithm
class_name BasicPhysicAlgorithm

func move_body(body: CharacterBody2D, config: PhysicsConfig, time_scale: float) -> void:
	body.velocity -= Vector2(0, -1) * config.gravity * time_scale
	var collision: KinematicCollision2D = body.move_and_collide(body.velocity * time_scale)
	if not collision:
		return

	if abs(collision.get_normal().x) <= 0.001:
		body.velocity = body.velocity.slide(collision.get_normal()) * config.friction
	else:
		body.velocity = body.velocity.bounce(collision.get_normal()) * config.bounce_multiplier
	
	# This is ugly but it's the only thing that works
	var temp: Vector2 = body.velocity
	body.velocity = Vector2.ZERO
	body.move_and_slide()
	body.velocity = temp
