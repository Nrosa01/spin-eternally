@tool
extends Area2D

@onready var path: Path2D = %Path2D

func _ready() -> void:
	position_at_start()
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		position_at_start()

func position_at_start():
	position = path.curve.get_point_position(0)
