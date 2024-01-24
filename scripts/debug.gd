extends Node2D

var r: Dictionary
var r2: Vector2

func _init() -> void:
	top_level = true
	z_index = 10

func _draw():
	for pos in r:
		if pos is Vector2 or pos is Vector2i:
			draw_rect(Rect2i(pos, Vector2.ONE * 8), Color.BLUE)
			pass
	pass
	
	if r2 != Vector2.ZERO:
		draw_rect(Rect2i(r2, Vector2.ONE * 8), Color.RED)
	
	draw_circle(position, 5, Color.RED)
	
func _process(_delta: float) -> void:
	queue_redraw()
