extends RichTextLabel

@export_group("Renk Paleti")
@export var number_color: Color = Color("00f0ff")   # Parlak Neon Cyan
@export var colon_color: Color = Color("e0f7fa")    # Buz Beyazı
@export var outline_color: Color = Color("04111f")  # Derin Gece Mavisi Kontur

@export_group("Görünüm & Font")
@export var font_size: int = 72
@export var is_running: bool = true

@export_group("Dalgalanma (Wave Efekti)")
@export var wave_amp: float = 45.0   # Harflerin yukarı-aşağı çıkış mesafesi (Eski: 16.0)
@export var wave_freq: float = 6.0   # Dalgalanmanın hızı ve ritmi (Eski: 3.5)

var elapsed_time: float = 0.0
var _last_second: int = -1


func _ready() -> void:
	bbcode_enabled = true
	fit_content = true
	scroll_active = false
	autowrap_mode = TextServer.AUTOWRAP_OFF
	
	clip_contents = false

	custom_minimum_size.x = font_size * 5.0
	custom_minimum_size.y = font_size * 2.2

	_apply_font_size()
	_update_pivot()
	resized.connect(_update_pivot)


func _apply_font_size() -> void:
	add_theme_font_size_override("normal_font_size", font_size)
	add_theme_font_size_override("bold_font_size", font_size)


func _update_pivot() -> void:
	pivot_offset = size / 2.0


func _process(delta: float) -> void:
	if not is_running:
		return

	elapsed_time += delta

	var minutes: int = int(elapsed_time / 60.0)
	var seconds: int = int(fmod(elapsed_time, 60.0))

	if seconds != _last_second:
		_last_second = seconds
		_trigger_tick_punch()

	text = _build_timer_bbcode(minutes, seconds)


func _build_timer_bbcode(mins: int, secs: int) -> String:
	var outline_w: int = maxi(int(font_size * 0.18), 4)

	var num_hex: String = "#" + number_color.to_html(false)
	var col_hex: String = "#" + colon_color.to_html(false)
	var out_hex: String = "#" + outline_color.to_html(false)

	return (
		"[center]"
		+ "[wave amp=%.1f freq=%.1f connected=1]" % [wave_amp, wave_freq]
		+ "[outline_size=%d][outline_color=%s]" % [outline_w, out_hex]
		+ " [color=%s][b]%02d[/b][/color]" % [num_hex, mins]
		+ "[pulse color=#ffffff freq=2.0 ease=-2.0][color=%s]:[/color][/pulse]" % col_hex
		+ "[color=%s][b]%02d[/b][/color] " % [num_hex, secs]
		+ "[/outline_color][/outline_size]"
		+ "[/wave]"
		+ "[/center]"
	)


func _trigger_tick_punch() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.08)
	tween.tween_property(self, "scale", Vector2.ONE, 0.12)
