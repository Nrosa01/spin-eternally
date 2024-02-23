extends PhysicAlgorithm
class_name BasicPhysicAlgorithm

func move_body(body: CharacterBody2D, config: PhysicsConfig, time_scale: float) -> KinematicCollision2D:
	body.velocity -= config.gravity_direction * config.gravity * time_scale * config.air_friction
	var collision: KinematicCollision2D = body.move_and_collide(body.velocity * time_scale)
	return collision
