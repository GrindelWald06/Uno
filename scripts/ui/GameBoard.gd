class_name GameBoard extends Control

const PlayerIndicatorScene := preload("res://scenes/ui/PlayerIndicatorUI.tscn")

@onready var _opponent_row: HBoxContainer = $OpponentRow
@onready var _discard_pile_ui: DiscardPileUI = $CenterPiles/DiscardPileUI
@onready var _draw_pile_ui: DrawPileUI = $CenterPiles/DrawPileUI
@onready var _hand_ui: HandUI = $HandUI
@onready var _color_picker_ui: ColorPickerUI = $ColorPickerUI

var _opponent_indicators: Dictionary = {}

signal card_selected(card: Card)
signal draw_pile_pressed
signal color_chosen(color: Enums.CardColor)
signal card_confirmed(card: Card)

func _ready() -> void:
	_hand_ui.card_selected.connect(func(card): card_selected.emit(card))
	_hand_ui.card_confirmed.connect(func(card): card_confirmed.emit(card))
	_draw_pile_ui.draw_pile_pressed.connect(func(): draw_pile_pressed.emit())
	_color_picker_ui.color_chosen.connect(func(color): color_chosen.emit(color))

func setup_opponents(opponents:Array[Player]) -> void:
	_clear_opponents()
	for player in opponents:
		var indicator = PlayerIndicatorScene.instantiate()
		_opponent_row.add_child(indicator)
		indicator.set_player_info(player.name, player.hand.size())
		_opponent_indicators[player] = indicator

func _clear_opponents() -> void:
	for indicator in _opponent_row.get_children():
		indicator.queue_free()
	_opponent_indicators.clear()

func update_opponent_count(player: Player, count: int) -> void:
	if _opponent_indicators.has(player):
		_opponent_indicators[player].set_player_info(player.name, count)

func set_active_player(player: Player) -> void:
	for p in _opponent_indicators:
		_opponent_indicators[p].set_active(p == player)

func set_hand(cards: Array[Card]) -> void:
	_hand_ui.set_hand(cards)

func set_playable_cards(valid_cards: Array[Card]) -> void:
	_hand_ui.set_playable_cards(valid_cards)

func clear_hand_selection() -> void:
	_hand_ui.clear_selection()

func get_selected_card() -> Card:
	return _hand_ui.get_selected_card()

func set_discard_top_card(card: Card) -> void:
	_discard_pile_ui.set_top_card(card)

func set_draw_pile_count(count: int) -> void:
	_draw_pile_ui.set_count(count)

func show_color_picker() -> void:
	_color_picker_ui.show_picker()

func hide_color_picker() -> void:
	_color_picker_ui.hide_picker()

func set_hand_interactive(interactive: bool) -> void:
	_hand_ui.set_interactive(interactive)
