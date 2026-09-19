class_name DiscardPile
extends RefCounted

var pile:Array[Card]

func _init() -> void:
	pile = []

func top_card():
	return pile.back()

func push(card):
	pile.push_back(card)

func reshuffle() -> Array:
	var top = pile.pop_back()
	var cards_to_reshuffle = pile
	pile = [top]
	return cards_to_reshuffle

func _to_string() -> String:
	return "Current card: %s" % str(self.top_card())
