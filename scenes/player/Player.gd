extends CharacterBody2D

# Basic config
@export var config: PhysicsConfig
@export var physics_algorithm: BasicPhysicAlgorithm
@export var collision_handler: CollisionHandler
@onready var line_renderer: Line2D = $CanvasLayer/DragLine

# "Jump" settings
@export var jump_count = 1
@onready var _jump_count = jump_count

var shoot_force: float

@onready var trayectory_line: Line2D = $Trayectory
@onready var drag_handler: DragHandler = $DragHandler
@onready var raycaster: RayCast2D = $RayCast2D
@onready var collision_detector: CollisionDector = $CollisionDetector

func raycast_in_dir(direction: Vector2, distance: float) -> bool:
	raycaster.target_position = direction * distance
	raycaster.force_raycast_update()
	return raycaster.is_colliding()

func _ready():
	line_renderer.visible = false

	# Suscribirse a las señales del DragHandler
	drag_handler.drag_started.connect(_on_drag_started)
	drag_handler.dragged.connect(_on_dragged)
	drag_handler.drag_finished.connect(_on_drag_finished)

func _on_drag_started(drag_start_position: Vector2):
	line_renderer.points = [drag_start_position, drag_start_position]
	line_renderer.visible = true
	TimeHandler.time_scale = 0.055	

func _on_dragged(_current_position: Vector2, direction: Vector2, distance: float):
	var clamped_distance = clamp(distance, 0.0, config.max_slide_distance)
	shoot_force = pow(clamped_distance / config.max_slide_distance, 2) * config.max_force
	shoot_force = max(shoot_force, config.min_force)

	line_renderer.points[1] = line_renderer.points[0] - clamped_distance * direction
	line_renderer.visible = distance >= config.minimum_required_slide_distance
	
	if raycast_in_dir(direction, 10) and collision_detector.is_on_floor():
		direction = direction * -1
		direction.x *= -1
		line_renderer.modulate = Color.RED
	else:
		line_renderer.modulate = Color.WHITE
	
	if _jump_count <= 0:
		line_renderer.modulate = Color.GREEN
	
	trayectory_line.draw_trayectory(get_shoot_force(direction, distance))

func _on_drag_finished(_position: Vector2, direction: Vector2, distance: float):
	_jump_count -= 1
	
	if raycast_in_dir(direction, 10) and collision_detector.is_on_floor():
		direction = direction * -1
		direction.x *= -1
		line_renderer.modulate = Color.RED
		# Gain extra jump
		_jump_count = 1
	else:
		line_renderer.modulate = Color.WHITE
	
	TimeHandler.time_scale = 1		
	velocity = get_shoot_force(direction, distance)	
	trayectory_line.hide()
	line_renderer.hide()

func get_shoot_force(direction: Vector2, drag_distance: float) -> Vector2:
	drag_distance = min(drag_distance, config.max_slide_distance)

	if drag_distance >= config.minimum_required_slide_distance:
		return direction * shoot_force * (drag_distance / config.max_slide_distance)
	else:
		return Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			TimeHandler.time_scale = 0.1	
			trayectory_line.draw_trayectory(get_shoot_force(Vector2.ZERO, 0))

## Due to how Godot handles collisions, if you don't use move_and_slide
## you need to do this to register collisions
func fix_collisions():
	var temp: Vector2 = velocity
	velocity = Vector2.ZERO
	move_and_slide()
	velocity = temp

func _physics_process(_delta):	
	%Direction.text = str(collision_detector.is_on_floor())
	var collision = physics_algorithm.move_body(self, config, TimeHandler.time_scale)
	if collision:
		if collision_handler.get_tilemap_data(collision).bouncable:
			_jump_count = 1
		
		collision_handler.handle_collision(collision, self, config, TimeHandler.time_scale)
	fix_collisions()
