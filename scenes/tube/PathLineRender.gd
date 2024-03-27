@tool
extends Line2D

@onready var path: Path2D = %Path2D

func _ready() -> void:
	recreate_line()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		recreate_line()

func recreate_line():
	var path_point_count: int = path.curve.point_count
	clear_points()
	
	for point in path_point_count:
		add_point(path.curve.get_point_position(point))
	
