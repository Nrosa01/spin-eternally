extends Node2D

@export var tube_speed: float = 2.5
var parent_hold: Node2D
var node_in_tube: CharacterBody2D
var saved_speed: float

@onready var path_follow: PathFollow2D = %PathFollow2D

func _on_tube_entrance_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and node_in_tube == null:
		print("Started " + str(node_in_tube))
		path_follow.progress = 0
		node_in_tube = body
		saved_speed = body.velocity.length() # This is not used atm
		parent_hold = body.get_parent()
		body.reparent(path_follow)
		body.paused = true

		# Lerp body local position to 0 in 0.25 seconds
		var tween = get_tree().create_tween()
		tween.tween_property(body, "position", Vector2(0, 0), 0.25).set_trans(Tween.TRANS_CUBIC)
		
		
func get_vel() -> Vector2:
	var path: Path2D = %Path2D
	var curve: Curve2D = path.curve
	var start := curve.get_point_position(curve.point_count - 1)
	var end := curve.get_point_position(curve.point_count - 2)
	return (start - end).normalized()

func _process(_delta: float) -> void:
	if node_in_tube:
		path_follow.progress += tube_speed
		
		if path_follow.progress_ratio >= 0.99:
			node_in_tube.reparent(parent_hold)
			node_in_tube.paused = false
			node_in_tube.velocity = get_vel() * saved_speed
			node_in_tube = null
			
	

