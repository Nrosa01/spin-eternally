extends PhysicAlgorithm
class_name BasicPhysicAlgorithm

func move_body(body: CharacterBody2D, config: PhysicsConfig, delta: float) -> void:
	body.velocity += (config.fall_multiplier - 1) * -Vector2(0, -1) * config.gravity * delta
	var collision: KinematicCollision2D = body.move_and_collide(body.velocity * delta)
	if not collision:
		return

	if abs(collision.get_normal().x) <= 0.001:
		body.velocity = body.velocity.slide(collision.get_normal()) * config.friction
	else:
		body.velocity = body.velocity.bounce(collision.get_normal()) * config.bounce_multiplier
	
	# I need to do this shit for is_on_floor func to work, it seems handling the collision and manually sliding makes
	# the callback not get called
	var temp: Vector2 = body.velocity
	body.velocity = body.velocity.normalized() * 0.1
	body.move_and_slide()
	body.velocity = temp
