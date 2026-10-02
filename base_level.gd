extends Node2D

@onready var control: Control = $Control
@onready var container: VBoxContainer = $Control/VBoxContainer
@onready var continue_btn: Button = $Control/VBoxContainer/Continue
@onready var line_edit: LineEdit = $Control/VBoxContainer/HBoxContainer/LineEdit


func _ready() -> void:
	control.process_mode = Node.PROCESS_MODE_ALWAYS
	container.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()
		get_viewport().set_input_as_handled()


func _pause_game() -> void:
	get_tree().paused = true
	container.visible = true
	continue_btn.grab_focus() 


func _resume_game() -> void:
	get_tree().paused = false
	container.visible = false


func _on_continue_pressed() -> void:
	_resume_game()


func _on_new_run_pressed() -> void:
	get_tree().paused = false
	GameManager.reset_timer()
	get_tree().change_scene_to_file("res://sample_level.tscn")
	GameManager.player_name = line_edit.text.strip_edges()


func _on_leaderboard_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level2.tscn")
