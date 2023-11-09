extends Line2D

@export var config: PhysicsConfig
@export var physics_algorithm: BasicPhysicAlgorithm

@export var trayectory_distance: float = 400.0
@export var max_points: int = 50

@onready var test_body: CharacterBody2D = $CharacterBody2D

func draw_trayectory(force: Vector2) -> void:
	if force.length() < 0.001:
		hide()
		return
	
	show()
	reset_body()	
	clear_points()
	var current_dist: float = 0
	var current_pos := test_body.global_position
	add_point(to_local(current_pos))
	test_body.velocity += force
	var delta := get_physics_process_delta_time()
	var i := 0
	
	while current_dist < trayectory_distance and i < max_points:
		# Get the new post moving the simulation body
		var new_pos = move_body(delta)
		add_point(to_local(new_pos))
		
		# Add the distance to the new point
		current_dist += (new_pos - current_pos).length()
		i += 1

func reset_body() -> void:
	test_body.global_position = owner.global_position
	test_body.velocity = owner.velocity

func move_body(delta: float) -> Vector2:
	physics_algorithm.move_body(test_body, config, delta)
	return test_body.global_position
