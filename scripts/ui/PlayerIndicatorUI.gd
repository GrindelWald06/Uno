class_name PlayerIndicatorUI extends PanelContainer

@onready var _name_label: Label = $Content/NameLabel
@onready var _count_label: Label = $Content/CountLabel

var player_name:String = ""
var card_count:int = 0
var is_active:bool = false

var _base_style: StyleBoxFlat

func _ready() -> void:
	_base_style = get_theme_stylebox("panel")


func set_player_info(player_display_name: String, count: int) -> void:
	player_name = player_display_name
	card_count = count
	_name_label.text = player_display_name
	_count_label.text = "%d cards" % count
	
func set_active(active: bool) -> void:
	is_active = active
	var style: StyleBoxFlat = _base_style.duplicate()
	if active:
		style.border_width_left = 3
		style.border_width_top = 3
		style.border_width_right = 3
		style.border_width_bottom = 3
		style.border_color = Color(1.0, 0.9, 0.2)
	add_theme_stylebox_override("panel", style)
