class_name CardUI extends Control

signal card_pressed(card: Card)

const HOVER_LIFT := 12.0
const SELECT_LIFT := 20.0

var _is_hovered: bool = false

@onready var _background: Panel = $Background
@onready var _label: Label = $Label

var card_data: Card
var _is_selected: bool = false

func _ready() -> void:
	if card_data != null:
		_refresh_visuals()

func set_card_data(card: Card) -> void:
	card_data = card
	if is_node_ready():
		_refresh_visuals()

func set_selected(selected: bool) -> void:
	_is_selected = selected
	_refresh_visuals()
	var target_y := -SELECT_LIFT if selected else (-HOVER_LIFT if _is_hovered else 0.0)
	var tween := create_tween()
	tween.tween_property(self, "position:y", target_y, 0.12)

func _refresh_visuals() -> void:
	if card_data == null:
		return

	var style := StyleBoxFlat.new()
	style.bg_color = Consts.COLOR_MAP.get(card_data.color, Color.PURPLE)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.border_color = Color(1.0, 0.9, 0.2) if _is_selected else Color.WHITE
	_background.add_theme_stylebox_override("panel", style)

	_label.text = _get_display_text(card_data)


func _get_display_text(card: Card) -> String:
	match card.type:
		Enums.CardType.NUMBER:
			return str(card.value)
		Enums.CardType.SKIP:
			return "⦸"
		Enums.CardType.REVERSE:
			return "⟲"
		Enums.CardType.DRAW_TWO:
			return "+2"
		Enums.CardType.WILD:
			return "W"
		Enums.CardType.WILD_DRAW_FOUR:
			return "+4"
	return "?"


func _on_mouse_entered() -> void:
	_is_hovered = true
	if _is_selected:
		return
	var tween := create_tween()
	tween.tween_property(self, "position:y", -HOVER_LIFT, 0.08)


func _on_mouse_exited() -> void:
	_is_hovered = false
	if _is_selected:
		return
	var tween := create_tween()
	tween.tween_property(self, "position:y", 0.0, 0.08)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_pressed.emit(card_data)
