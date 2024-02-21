extends Resource
class_name CollisionHandler

func show_tile_collision(collision: KinematicCollision2D):
	var collider := collision.get_collider()
	if collider is TileMap:
		var tilemap := collider as TileMap
		var step: Vector2 = -collision.get_normal() * tilemap.tile_set.tile_size.x * 0.5
		var world_pos := collision.get_position() + step
		var cell_pos := tilemap.local_to_map(tilemap.to_local(world_pos))
		
		world_pos = cell_pos * tilemap.tile_set.tile_size.x + Vector2i(tilemap.global_position)
		Debug.r[world_pos] = world_pos
		Debug.r2 = world_pos
				
		# tilemap.set_cell(1, cell_pos, -1)
		# tilemap.set_cell(2, cell_pos, -1)

func get_tilemap_data(collision: KinematicCollision2D, tile_layer: int = 0,  layer_name: String = "material") -> Object:
	var collider := collision.get_collider()
	if collider is TileMap:
		var tilemap := collider as TileMap
		var step: Vector2 = -collision.get_normal() * tilemap.tile_set.tile_size.x * 0.5
		var world_pos := collision.get_position() + step
		var cell_pos := tilemap.local_to_map(tilemap.to_local(world_pos))
		
		var cell_tile_data := tilemap.get_cell_tile_data(0, cell_pos)
		var data_layer_exists: bool = tilemap.tile_set.get_custom_data_layer_by_name("material") != -1
		
		if cell_tile_data and data_layer_exists:
			return cell_tile_data.get_custom_data("material")
		else:
			return null
	else:
		return null

@warning_ignore("unused_parameter")
func handle_collision(collision: KinematicCollision2D, body: CharacterBody2D, config: PhysicsConfig, time_scale: float):
	pass
