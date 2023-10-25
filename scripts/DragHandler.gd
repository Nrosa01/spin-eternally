extends Node2D
class_name DragHandler


var click_start_position = Vector2(0, 0)
var drag_distance = Vector2(0, 0)

# How much distance should be dragged to re-emit the signal
var drag_threshold = 1.0

var last_mouse_position = Vector2(0, 0)

signal drag_started(position: Vector2)
signal dragged(current_position: Vector2, distance: Vector2)
signal drag_finished(position: Vector2, distance: Vector2)

func _input(event):
	if Input.is_action_just_pressed("click"):
		click_start_position = get_global_mouse_position()
		last_mouse_position = click_start_position
		drag_started.emit(click_start_position)
		drag_distance = Vector2(0, 0)
	elif Input.is_action_just_released("click"):
		drag_finished.emit(get_global_mouse_position(), drag_distance)

	if Input.is_action_pressed("click"):
		var current_position = get_global_mouse_position()
		
		if (current_position - last_mouse_position).length() < drag_threshold: return
		
		var distance = click_start_position - current_position
		last_mouse_position = current_position
		if distance.length() > drag_threshold:
			drag_distance = distance
			dragged.emit(current_position, drag_distance)
