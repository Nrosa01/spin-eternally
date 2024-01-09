extends PhysicAlgorithm
class_name BasicPhysicAlgorithm

func move_body(body: CharacterBody2D, config: PhysicsConfig, time_scale: float) -> KinematicCollision2D:
	body.velocity -= Vector2(0, -1) * config.gravity * time_scale
	var collision: KinematicCollision2D = body.move_and_collide(body.velocity * time_scale)
	if not collision:
		return

	handle_collision(collision, body, config, time_scale)
	
	# This is ugly but it's the only thing that works
	var temp: Vector2 = body.velocity
	body.velocity = Vector2.ZERO
	body.move_and_slide()
	body.velocity = temp
	
	return collision

func handle_collision(collision: KinematicCollision2D, body: CharacterBody2D, config: PhysicsConfig, time_scale: float):
	var collider := collision.get_collider()
	if collider is TileMap:
		var tilemap := collider as TileMap
		var cell_pos := collision.get_position() / tilemap.cell_quadrant_size
		# var cell_index := tilemap.get_cell
		print(tilemap.get_cell_atlas_coords (1, cell_pos))
#		tilemap.set_cell(1, cell_pos, -1)
#		tilemap.set_cell(2, cell_pos, -1)
		pass
	
	if abs(collision.get_normal().x) <= 0.001:
		body.velocity = body.velocity.slide(collision.get_normal()) * config.friction
	else:
		body.velocity = body.velocity.bounce(collision.get_normal()) * config.bounce_multiplier
	pass
