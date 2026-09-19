class_name DrawPileUI extends Control

signal draw_pile_pressed

@onready var count_label: Label = $CountLabel

var card_count:int = 0

func set_count(count:int):
	card_count = count
	count_label.text = str(count)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		draw_pile_pressed.emit()
