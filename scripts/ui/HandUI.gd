class_name HandUI extends Control

signal card_selected(card: Card)
signal card_confirmed(card: Card)

const CardUIScene := preload("res://scenes/ui/CardUI.tscn")

@onready var _card_container: HBoxContainer = $CardContainer

var _card_nodes: Dictionary = {}
var _selected_card: Card = null

func set_hand(cards:Array[Card]):
	_clear()
	for card in cards:
		add_card(card)

func add_card(card):
	var card_ui = CardUIScene.instantiate()
	_card_container.add_child(card_ui)
	card_ui.set_card_data(card)
	card_ui.card_pressed.connect(_on_card_pressed.bind(card_ui))
	_card_nodes[card] = card_ui

func _clear():
	for child in _card_container.get_children():
		child.queue_free()
	_card_nodes.clear()
	_selected_card = null

func _on_card_pressed(card:Card, card_ui:CardUI):
	# If the card was already selected, unselect it
	if _selected_card == card:
		card_confirmed.emit(card)
		return

	# If a card in hand was already selected, unselect it
	if _selected_card != null and _card_nodes.has(_selected_card):
		_card_nodes[_selected_card].set_selected(false)
	
	card_ui.set_selected(true)
	_selected_card = card
	card_selected.emit(card)

func get_selected_card():
	return _selected_card

func clear_selection() -> void:
	if _selected_card != null and _card_nodes.has(_selected_card):
		_card_nodes[_selected_card].set_selected(false)
	_selected_card = null
	card_selected.emit(null)

func set_playable_cards(valid_cards: Array[Card]) -> void:
	for card in _card_nodes:
		var card_ui: CardUI = _card_nodes[card]
		var playable = valid_cards.is_empty() or card in valid_cards
		card_ui.modulate.a = 1.0 if playable else 0.4
		card_ui.mouse_filter = Control.MOUSE_FILTER_STOP if playable else Control.MOUSE_FILTER_IGNORE

func set_interactive(interactive: bool) -> void:
	for card in _card_nodes:
		var card_ui: CardUI = _card_nodes[card]
		card_ui.modulate.a = 1.0 if interactive else 0.5
		card_ui.mouse_filter = Control.MOUSE_FILTER_STOP if interactive else Control.MOUSE_FILTER_IGNORE
