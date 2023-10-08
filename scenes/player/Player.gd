extends CharacterBody2D

# Basic config
@export var gravity: float = 980;
@export var max_force : float = 700.0
@export var min_force : float = 100.0
@export var max_slide_distance : float = 30.0
@export var minimum_required_slide_distance : float = 2.5
@export var bounce_multiplier: float = 0.6
@export var friction: float = 0.85
var line_renderer : Line2D

# Modifiers
@export var fall_multiplier : float = 2.5

var initial_position : Vector2
var final_position : Vector2
var shoot_force : float

func _ready():
	line_renderer = $Line2D
	line_renderer.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		initial_position = get_global_mouse_position()
		line_renderer.points = [initial_position, initial_position]
		line_renderer.visible = true

	elif Input.is_action_pressed("click"):
		final_position = get_global_mouse_position()
		var distance = initial_position.distance_to(final_position)
		var clamped_distance = clamp(distance, 0.0, max_slide_distance)
		shoot_force = pow(clamped_distance / max_slide_distance, 2) * max_force
		shoot_force = max(shoot_force, min_force)

		var adjusted_final_position = initial_position + (final_position - initial_position).normalized() * clamped_distance
		line_renderer.points[1] = adjusted_final_position

		line_renderer.visible = distance >= minimum_required_slide_distance

	elif Input.is_action_just_released("click"):
		var distance = initial_position.distance_to(final_position)

		distance = min(distance, max_slide_distance)

		if distance >= minimum_required_slide_distance:
			var direction = (initial_position - final_position).normalized()
			velocity += direction * shoot_force * (distance / max_slide_distance)

		line_renderer.visible = false

func _physics_process(delta):
	velocity += (fall_multiplier - 1) * -Vector2(0, -1) * gravity * delta
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if not collision: return
	
	if abs(collision.get_normal().x) <= 0.001:
		velocity = velocity.slide(collision.get_normal()) * friction
	else:	
		velocity = velocity.bounce(collision.get_normal()) * bounce_multiplier
