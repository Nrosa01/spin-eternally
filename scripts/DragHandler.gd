extends Node2D
class_name DragHandler


var click_start_position: Vector2 = Vector2(0, 0)
# How much distance should be dragged to re-emit the signal
var drag_threshold: float = 1.0

var last_mouse_position: Vector2 = Vector2(0, 0)

signal drag_started(drag_start: Vector2)
signal dragged(current_position: Vector2, direction: Vector2, distance: float)
signal drag_finished(drag_end: Vector2, direction: Vector2, distance: float)

func on_click_handler():
	click_start_position = get_global_mouse_position()
	last_mouse_position = click_start_position
	drag_started.emit(click_start_position)

func on_pressed_handler():
	var current_position = get_global_mouse_position()
		
	if (current_position - last_mouse_position).length() < drag_threshold: return
		
	var direction_unnormalized: Vector2 = click_start_position - current_position
	var distance: float = direction_unnormalized.length()
	last_mouse_position = current_position
	if distance > drag_threshold:
		dragged.emit(current_position, direction_unnormalized.normalized(), distance)

func on_released_handler():
	var direction_unnormalized: Vector2 = click_start_position - get_global_mouse_position()		
	var distance: float = direction_unnormalized.length()
	drag_finished.emit(get_global_mouse_position(), direction_unnormalized.normalized(), distance)

func _input(_event):
	if Input.is_action_just_pressed("click"):
		on_click_handler()
	
	elif Input.is_action_pressed("click"):
		on_pressed_handler()
	
	elif Input.is_action_just_released("click"):
		on_released_handler()
		
