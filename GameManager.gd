# GameManager.gd
extends Node

var elapsed_time: float = 0.0
var is_timer_running: bool = true


func _process(delta: float) -> void:
	if is_timer_running:
		elapsed_time += delta


func reset_timer() -> void:
	elapsed_time = 0.0
