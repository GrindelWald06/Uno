class_name ColorPickerUI extends Control

signal color_chosen(color: Enums.CardColor)

@onready var _red_button: Button = $ButtonGrid/RedButton
@onready var _yellow_button: Button = $ButtonGrid/YellowButton
@onready var _green_button: Button = $ButtonGrid/GreenButton
@onready var _blue_button: Button = $ButtonGrid/BlueButton

func _ready() -> void:
	_red_button.pressed.connect(_on_color_button_pressed.bind(Enums.CardColor.RED))
	_yellow_button.pressed.connect(_on_color_button_pressed.bind(Enums.CardColor.YELLOW))
	_green_button.pressed.connect(_on_color_button_pressed.bind(Enums.CardColor.GREEN))
	_blue_button.pressed.connect(_on_color_button_pressed.bind(Enums.CardColor.BLUE))

func _on_color_button_pressed(color: Enums.CardColor) -> void:
	hide_picker()
	color_chosen.emit(color)

func show_picker() -> void:
	visible = true

func hide_picker() -> void:
	visible = false
