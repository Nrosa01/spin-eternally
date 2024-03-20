extends CharacterBody2D


# Basic physics_settings
@export_subgroup("Drag settings")
@export var max_shoot_force : float = 13.0
@export var min_shoot_force : float = 3.0
@export var max_drag_distance : float = 50.0
@export var minimum_required_slide_distance : float = 2.5

@export_subgroup("Physic settings")
@export var physics_settings: PhysicsConfig
@export var physics_algorithm: BasicPhysicAlgorithm
@export var collision_handler: CollisionHandler

@export_subgroup("")
@onready var line_renderer: Line2D = $CanvasLayer/DragLine

# "Jump" settings
@export var extra_jump_amount = 0
@onready var jump_count = extra_jump_amount + 1

var shoot_force: float

@onready var trayectory_line: Line2D = $Trayectory
@onready var drag_handler: DragHandler = $DragHandler
@onready var raycaster: RayCast2D = $RayCast2D
@onready var collision_detector: CollisionDector = $CollisionDetector

@onready var current_surface = TerrainMaterial.new()

func raycast_in_dir(direction: Vector2, distance: float) -> bool:
	raycaster.target_position = direction * distance
	raycaster.force_raycast_update()
	return raycaster.is_colliding()

func reset_jump():
	jump_count = 1 + extra_jump_amount
	
func decrease_jump_count():
	jump_count -= 1

func can_jump() -> bool:
	return jump_count > 0

func _ready():
	line_renderer.visible = false

	# Suscribirse a las señales del DragHandler
	drag_handler.drag_started.connect(_on_drag_started)
	drag_handler.dragged.connect(_on_dragged)
	drag_handler.drag_finished.connect(_on_drag_finished)

func _on_drag_started(drag_start_position: Vector2):
	line_renderer.points = [drag_start_position, drag_start_position]
	line_renderer.visible = true

func _on_dragged(_current_position: Vector2, direction: Vector2, distance: float):
	if distance > minimum_required_slide_distance:
		TimeHandler.time_scale = 0.055		
	
	var clamped_distance = clamp(distance, 0.0, max_drag_distance)
	shoot_force = pow(clamped_distance / max_drag_distance, 2) * max_shoot_force
	shoot_force = max(shoot_force, min_shoot_force)

	line_renderer.points[1] = line_renderer.points[0] - clamped_distance * direction
	line_renderer.visible = distance >= minimum_required_slide_distance
	
	if raycast_in_dir(direction, 10) and collision_detector.is_on_floor():
		direction = direction * -1
		direction.x *= -1
		line_renderer.modulate = Color.RED
	else:
		line_renderer.modulate = Color.WHITE
	
	if not can_jump():
		line_renderer.modulate = Color.GREEN
	
	trayectory_line.draw_trayectory(get_shoot_force(direction, distance))

func _on_drag_finished(_position: Vector2, direction: Vector2, distance: float):
	if distance < minimum_required_slide_distance:
		velocity.x = sign(velocity.x) * 0.1
		velocity.y = -physics_settings.gravity
		TimeHandler.time_scale = 0.75
		await get_tree().create_timer(0.25).timeout		
		TimeHandler.time_scale = 1		
	else:
		@warning_ignore("shadowed_variable")
		var can_jump := can_jump()
		decrease_jump_count()
		
		if raycast_in_dir(direction, 10) and collision_detector.is_on_floor():
			direction = direction * -1
			direction.x *= -1
			line_renderer.modulate = Color.RED
			
			if current_surface.bouncable:
				reset_jump()
		else:
			line_renderer.modulate = Color.WHITE
		
		velocity = get_shoot_force(direction, distance) if can_jump else velocity
		TimeHandler.time_scale = 1		
		
	
	# With this version, when you have no jumps left in air, an attempt to shoot results
	# in a lose of all motion. It could be useful but could also lead to problems if our
	# game is fast paced and users try to do things pretty quick
	# velocity = get_shoot_force(direction, distance) if can_jump else Vector2.ZERO
	trayectory_line.hide()
	line_renderer.hide()

func get_shoot_force(direction: Vector2, drag_distance: float) -> Vector2:
	drag_distance = min(drag_distance, max_drag_distance)

	if drag_distance >= minimum_required_slide_distance:
		return direction * shoot_force * (drag_distance / max_drag_distance)
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
	var collision = physics_algorithm.move_body(self, physics_settings, TimeHandler.time_scale)
	if collision:
		current_surface = collision_handler.get_tilemap_data(collision)
		if current_surface.bouncable:
			reset_jump()
		
		collision_handler.handle_collision(collision, self, TimeHandler.time_scale)
	fix_collisions()
