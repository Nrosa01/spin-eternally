extends CharacterBody2D

# Basic config
@export var config: PlayerConfig
var line_renderer : Line2D

var initial_position : Vector2
var final_position : Vector2
var shoot_force : float

@onready var trayectory_line: Line2D = $Trayectory

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
		var clamped_distance = clamp(distance, 0.0, config.max_slide_distance)
		shoot_force = pow(clamped_distance / config.max_slide_distance, 2) * config.max_force
		shoot_force = max(shoot_force, config.min_force)

		var adjusted_final_position = initial_position + (final_position - initial_position).normalized() * clamped_distance
		line_renderer.points[1] = adjusted_final_position

		line_renderer.visible = distance >= config.minimum_required_slide_distance
		
		trayectory_line.draw_trayectory(get_shoot_force())

	elif Input.is_action_just_released("click"):
		velocity += get_shoot_force()
		trayectory_line.hide()
		line_renderer.hide()

func get_shoot_force() -> Vector2:
		var distance = initial_position.distance_to(final_position)

		distance = min(distance, config.max_slide_distance)

		if distance >= config.minimum_required_slide_distance:
			var direction = (initial_position - final_position).normalized()
			return direction * shoot_force * (distance / config.max_slide_distance)
		else: 
			return Vector2.ZERO

func _physics_process(delta):
	velocity += (config.fall_multiplier - 1) * -Vector2(0, -1) * config.gravity * delta
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if not collision: return
	
	if abs(collision.get_normal().x) <= 0.001:
		velocity = velocity.slide(collision.get_normal()) * config.friction
	else:	
		velocity = velocity.bounce(collision.get_normal()) * config.bounce_multiplier
