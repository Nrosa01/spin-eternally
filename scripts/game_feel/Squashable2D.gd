extends Node2D

enum UpdateMode {IDLE, PHYSICS}

@export var max_speed := 50.0
@export var max_stretch := 1.8
@export var position_lerp_factor := 0.05  # Factor de interpolación para suavizar las posiciones
@export var update_mode := UpdateMode.IDLE

@onready var inverse_stretch := 1 / max_stretch
@onready var parent := get_parent()

@onready var target_position := global_position
@onready var previous_position := global_position

func stretch(delta):
	var velocity: Vector2 = (target_position - global_position) / delta
	var stretch_factor: float = clamp(velocity.length() / max_speed, 0, 1)
	var target_scale = lerp(Vector2.ONE, Vector2(max_stretch, inverse_stretch), stretch_factor)
	
	# Aplicar interpolación lineal para suavizar las posiciones
	target_position = lerp(parent.global_position, target_position, position_lerp_factor)
	
	parent.scale = target_scale
	
	var look_at_position: Vector2 = target_position + velocity
	parent.rotation = (look_at_position - global_position).angle()
	
	previous_position = global_position
	rotation = -parent.rotation

func _process(delta):
	if update_mode != UpdateMode.IDLE:
		return
	
	stretch(delta)
	
func _physics_process(delta):
	if update_mode != UpdateMode.PHYSICS:
		return
	
	stretch(delta)
