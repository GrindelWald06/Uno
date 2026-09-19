class_name DiscardPileUI extends Control

@onready var _top_card_display: CardUI = $TopCardDisplay

var top_card: Card = null

func set_top_card(card:Card):
	_top_card_display.set_card_data(card)
	top_card = card
