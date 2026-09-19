class_name Player
extends RefCounted

var id:int
var name:String
var hand:Array[Card]
var is_ai:bool

func _init(p_id:int, p_name:String, p_is_ai:bool) -> void:
	id = p_id
	name = p_name
	hand = []
	is_ai = p_is_ai

func add_card(card:Card):
	hand.append(card)

func remove_card(card:Card):
	hand.erase(card)

func has_no_cards():
	return hand.is_empty()

func has_valid_move(top_card: Card, active_color: Enums.CardColor) -> bool:
	for card in hand:
		if Utils.is_valid_move(card, top_card, active_color):
			return true
	return false

func get_valid_moves(top_card:Card, active_color:Enums.CardColor):
	var valid_moves = []
	for card in hand:
		if Utils.is_valid_move(card, top_card, active_color):
			valid_moves.append(card)
	return valid_moves

func _to_string() -> String:
	var result := "Player %d (%s)" % [id, name]
	result += "\n  AI: %s" % is_ai
	result += "\n  Hand (%d):" % hand.size()

	for card in hand:
		result += "\n    " + str(card)
	result += "\n\n"

	return result
