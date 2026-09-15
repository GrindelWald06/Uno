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

func has_valid_move(top_card:Card, active_color:Card.CardColor):
	for card in hand:
		if card.color == top_card.color or card.color == active_color:
			return true
	return false

func get_valid_move(top_card:Card, active_color:Card.CardColor):
	var valid_moves = []
	for card in hand:
		if card.color == top_card.color or card.color == active_color:
			valid_moves.append(card)
	return valid_moves
