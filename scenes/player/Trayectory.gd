extends Line2D

@export var gravity: float = 980;
@export var max_force : float = 700.0
@export var min_force : float = 100.0
@export var max_slide_distance : float = 30.0
@export var minimum_required_slide_distance : float = 2.5
@export var bounce_multiplier: float = 0.6
@export var friction: float = 0.85
@export var fall_multiplier : float = 2.5

@export var trayectory_distance: float = 400.0

@onready var test_body: CharacterBody2D = $CharacterBody2D

func draw_trayectory(force: Vector2) -> void:
	if force.length() < 0.001:
		hide()
		return
	
	show()
	reset_body()	
	clear_points()
	var current_dist = 0
	var current_pos = test_body.global_position
	add_point(to_local(current_pos))
	test_body.velocity += force
	var delta = get_physics_process_delta_time()
	
	while current_dist < trayectory_distance:
		# Get the new post moving the simulation body
		var new_pos = move_body(delta)
		add_point(to_local(new_pos))
		
		# Add the distance to the new point
		current_dist += (new_pos - current_pos).length()

func reset_body() -> void:
	test_body.global_position = owner.global_position
	test_body.velocity = owner.velocity

func move_body(delta: float) -> Vector2:
	test_body.velocity += (fall_multiplier - 1) * -Vector2(0, -1) * gravity * delta
	var collision: KinematicCollision2D = test_body.move_and_collide(test_body.velocity * delta)
	if not collision: return test_body.global_position
	
	if abs(collision.get_normal().x) <= 0.001:
		return test_body.global_position
	else:	
		test_body.velocity = test_body.velocity.bounce(collision.get_normal()) * bounce_multiplier

	return test_body.global_position
