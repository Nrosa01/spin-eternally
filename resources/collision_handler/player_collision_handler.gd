extends CollisionHandler

func handle_collision(collision: KinematicCollision2D, body: CharacterBody2D, config: PhysicsConfig, time_scale: float):
	var collider := collision.get_collider()
	var tile_custom_data: TerrainMaterial = get_tilemap_data(collision)
	
	# show_tile_collision(collision)
	
	#if tile_custom_data:
		#print("Material ", tile_custom_data.name)
	
	if abs(collision.get_normal().x) <= 0.001:
		body.velocity = body.velocity.slide(collision.get_normal()) * config.friction
	else:
		body.velocity = body.velocity.bounce(collision.get_normal()) * config.bounce_multiplier
	pass