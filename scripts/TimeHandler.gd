extends Node


var time_scale: float = 1: 
	set(new_value):
		time_scale = new_value
		Engine.time_scale = new_value
		RenderingServer.global_shader_parameter_set("time_scale", new_value)


func frameFreeze(new_time_scale, duration, managed: bool = true) -> void:
	var time_scale_copy = self.time_scale
	self.time_scale = new_time_scale
	await get_tree().create_timer(duration * new_time_scale).timeout
	self.time_scale = time_scale_copy
	pass
