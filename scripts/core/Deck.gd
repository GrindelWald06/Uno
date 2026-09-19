class_name Deck
extends RefCounted

var cards: Array[Card] = []

func _init():
	cards = Card.create_full_deck()
	shuffle()

func shuffle():
	cards.shuffle()

func draw_card():
	return cards.pop_back()

func draw_cards(n):
	var drawn_cards = []
	for i in range(n):
		drawn_cards.append(self.draw_card())
	return drawn_cards

func is_empty():
	return cards.is_empty()

func reshuffle_from_discard(discard_pile):
	cards.append_array(discard_pile.reshuffle())
	self.shuffle()

func _to_string() -> String:
	return "Current deck:\n" + "\n".join(cards.map(str))
