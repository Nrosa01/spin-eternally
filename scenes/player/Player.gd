extends CharacterBody2D

# Basic config
@export var config: PlayerConfig
var line_renderer: Line2D

var shoot_force: float

@onready var trayectory_line: Line2D = $Trayectory
@onready var drag_handler: DragHandler = $DragHandler

func _ready():
	line_renderer = $Line2D
	line_renderer.visible = false

	# Suscribirse a las señales del DragHandler
	drag_handler.drag_started.connect(_on_drag_started)
	drag_handler.dragged.connect(_on_dragged)
	drag_handler.drag_finished.connect(_on_drag_finished)

@warning_ignore("shadowed_variable_base_class")
func _on_drag_started(position: Vector2):
	line_renderer.points = [position, position]
	line_renderer.visible = true

func _on_dragged(current_position: Vector2, direction: Vector2, distance: float):
	var clamped_distance = clamp(distance, 0.0, config.max_slide_distance)
	shoot_force = pow(clamped_distance / config.max_slide_distance, 2) * config.max_force
	shoot_force = max(shoot_force, config.min_force)

	var adjusted_final_position: Vector2 = line_renderer.points[0] + (current_position - line_renderer.points[0]).normalized() * clamped_distance
	line_renderer.points[1] = adjusted_final_position

	line_renderer.visible = distance >= config.minimum_required_slide_distance
	
	trayectory_line.draw_trayectory(get_shoot_force(direction, distance))

func _on_drag_finished(_position: Vector2, direction: Vector2, distance: float):
	velocity += get_shoot_force(direction, distance)
	trayectory_line.hide()
	line_renderer.hide()

func get_shoot_force(direction: Vector2, drag_distance: float) -> Vector2:
	drag_distance = min(drag_distance, config.max_slide_distance)

	if drag_distance >= config.minimum_required_slide_distance:
		return direction * shoot_force * (drag_distance / config.max_slide_distance)
	else:
		return Vector2.ZERO

func _physics_process(delta):
	velocity += (config.fall_multiplier - 1) * -Vector2(0, -1) * config.gravity * delta
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if not collision:
		return

	if abs(collision.get_normal().x) <= 0.001:
		velocity = velocity.slide(collision.get_normal()) * config.friction
	else:
		velocity = velocity.bounce(collision.get_normal()) * config.bounce_multiplier
