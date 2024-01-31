extends Node2D
class_name DragHandler


var click_start_position: Vector2 = Vector2i(0, 0)
var dragging: bool = false
# How much distance should be dragged to re-emit the signal

var last_mouse_position: Vector2 = Vector2i(0, 0)

signal drag_started(drag_start: Vector2)
signal dragged(current_position: Vector2, direction: Vector2, distance: float)
signal drag_finished(drag_end: Vector2, direction: Vector2, distance: float)

#func from_screen_to_global(screen_position: Vector2i) -> Vector2:
func get_mouse_screen() -> Vector2:
	return get_viewport().get_mouse_position()
	

func on_click_handler():
	click_start_position = get_mouse_screen()
	last_mouse_position = click_start_position
	drag_started.emit(click_start_position)
	dragging = true

func on_pressed_handler():
	var current_position =get_mouse_screen()
		
	var direction_unnormalized: Vector2 = click_start_position - current_position
	var distance: float = direction_unnormalized.length()
	last_mouse_position = current_position
	dragged.emit(current_position, direction_unnormalized.normalized(), distance)

func on_released_handler():
	var direction_unnormalized: Vector2 = click_start_position - get_mouse_screen()		
	var distance: float = direction_unnormalized.length()
	drag_finished.emit(get_mouse_screen(), direction_unnormalized.normalized(), distance)
	dragging = false

func _process(_delta: float) -> void:
	if dragging:
		on_pressed_handler()

func _input(_event):
	if Input.is_action_just_pressed("click"):
		on_click_handler()
	
	elif Input.is_action_pressed("click"):
		on_pressed_handler()
	
	elif Input.is_action_just_released("click"):
		on_released_handler()
		
