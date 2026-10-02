# GameManager.gd
extends Node

var elapsed_time: float = 0.0
var is_timer_running: bool = true
var level: int = 0
var player_name 

func _ready() -> void:
	level = 1

func _process(delta: float) -> void:
	if is_timer_running:
		elapsed_time += delta
		
		if elapsed_time >= 180.0:
			save_data_to_json()
			is_timer_running = false

func save_data_to_json() -> void:
	var file_path := "user://leaderboard.json"
	var all_data: Array = []
	
	if FileAccess.file_exists(file_path):
		var read_file := FileAccess.open(file_path, FileAccess.READ)
		if read_file:
			var content := read_file.get_as_text()
			read_file.close()
			
			var parsed = JSON.parse_string(content)
			if parsed is Array:
				all_data = parsed
			elif parsed is Dictionary:
				all_data.append(parsed)

	var new_entry: Dictionary = {
		"name": player_name,
		"level": level,
		"timestamp": Time.get_datetime_string_from_system() 
	}
	all_data.append(new_entry)
	
	var write_file := FileAccess.open(file_path, FileAccess.WRITE)
	if write_file:
		write_file.store_string(JSON.stringify(all_data, "\t"))
		write_file.close()
		print("Kayıt eklendi. Toplam kayıt sayısı: ", all_data.size())
	else:
		printerr("Dosya yazma hatası: ", FileAccess.get_open_error())
		
func reset_timer() -> void:
	elapsed_time = 0.0
	is_timer_running = true
