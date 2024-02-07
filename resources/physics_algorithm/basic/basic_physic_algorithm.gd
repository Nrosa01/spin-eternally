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

func handle_collision(collision: KinematicCollision2D, body: CharacterBody2D, config: PhysicsConfig, _time_scale: float):
	var collider := collision.get_collider()
	if collider is TileMap and body.name == "Player":
		var tilemap := collider as TileMap
		var step: Vector2 = -collision.get_normal() * tilemap.tile_set.tile_size.x * 0.5
		var world_pos := collision.get_position() + step
		var cell_pos := tilemap.local_to_map(tilemap.to_local(world_pos))
		
		world_pos = cell_pos * tilemap.tile_set.tile_size.x + Vector2i(tilemap.global_position)
		Debug.r[world_pos] = world_pos
		Debug.r2 = world_pos
		
		# tilemap.set_cell(1, cell_pos, -1)
		# tilemap.set_cell(2, cell_pos, -1)
		
		
		## BOUNCABLE MANAGEMENT MUST BE DONE HERE
		#var cell_tile_data := tilemap.get_cell_tile_data(0, cell_pos)
		#var data_layer_exists: bool = tilemap.tile_set.get_custom_data_layer_by_name("Data") != -1
		
		#if cell_tile_data and data_layer_exists:
			#var tile_custom_data = cell_tile_data.get_custom_data("Data")
			#
			#if tile_custom_data:
				#print(MaterialEnum.MaterialTile.find_key(tile_custom_data.material))
		
	
	if abs(collision.get_normal().x) <= 0.001:
		body.velocity = body.velocity.slide(collision.get_normal()) * config.friction
	else:
		body.velocity = body.velocity.bounce(collision.get_normal()) * config.bounce_multiplier
	pass
