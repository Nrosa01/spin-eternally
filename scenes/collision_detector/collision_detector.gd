extends Node2D
class_name CollisionDector

var _is_on_floor: bool = false
var _is_on_left_wall: bool = false
var _is_on_right_wall: bool = false
var _is_on_ceiling: bool = false

func is_on_floor() -> bool:
	return _is_on_floor

func is_on_left_wall() -> bool:
	return _is_on_left_wall

func is_on_right_wall() -> bool:
	return _is_on_right_wall

func is_on_ceiling() -> bool:
	return _is_on_ceiling

func _on_up_area_2d_body_entered(body: Node2D) -> void:
	_is_on_ceiling = true

func _on_up_area_2d_body_exited(body: Node2D) -> void:
	_is_on_ceiling = false

func _on_right_area_2d_body_entered(body: Node2D) -> void:
	_is_on_right_wall = true

func _on_right_area_2d_body_exited(body: Node2D) -> void:
	_is_on_right_wall = false

func _on_left_area_2d_body_entered(body: Node2D) -> void:
	_is_on_left_wall = true

func _on_left_area_2d_body_exited(body: Node2D) -> void:
	_is_on_left_wall = false

func _on_down_area_2d_body_entered(body: Node2D) -> void:
	_is_on_floor = true

func _on_down_area_2d_body_exited(body: Node2D) -> void:
	_is_on_floor = false
