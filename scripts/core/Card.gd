class_name Card
extends RefCounted
## Represents a single Uno card. Pure data + helpers — no scene, no visuals.

var color: Enums.CardColor
var type: Enums.CardType
var value: int = -1


func _init(p_color: Enums.CardColor, p_type: Enums.CardType, p_value: int = -1) -> void:
	color = p_color
	type = p_type
	value = p_value

func is_wild() -> bool:
	return type == Enums.CardType.WILD or type == Enums.CardType.WILD_DRAW_FOUR

func is_action_card() -> bool:
	return type != Enums.CardType.NUMBER

func _to_string() -> String:
	var color_name = Enums.CardColor.keys()[color]
	match type:
		Enums.CardType.NUMBER:
			return "%s %d" % [color_name, value]
		Enums.CardType.SKIP:
			return "%s Skip" % color_name
		Enums.CardType.REVERSE:
			return "%s Reverse" % color_name
		Enums.CardType.DRAW_TWO:
			return "%s Draw Two" % color_name
		Enums.CardType.WILD:
			return "Wild"
		Enums.CardType.WILD_DRAW_FOUR:
			return "Wild Draw Four"
	return "Unknown Card"


## Builds one full, standard 108-card Uno deck (unshuffled).
## Composition per color (Red/Yellow/Green/Blue):
##   one 0, two each of 1-9, two Skip, two Reverse, two Draw Two  -> 25 cards
## Times 4 colors -> 100 cards
## Plus 4 Wild + 4 Wild Draw Four -> 108 cards total.
static func create_full_deck() -> Array[Card]:
	var cards: Array[Card] = []
	var colors := [Enums.CardColor.RED, Enums.CardColor.YELLOW, Enums.CardColor.GREEN, Enums.CardColor.BLUE]

	for c in colors:
		# One 0 card per color.
		cards.append(Card.new(c, Enums.CardType.NUMBER, 0))

		# Two each of 1-9 per color.
		for n in range(1, 10):
			cards.append(Card.new(c, Enums.CardType.NUMBER, n))
			cards.append(Card.new(c, Enums.CardType.NUMBER, n))

		# Two each of Skip, Reverse, Draw Two per color.
		for i in range(2):
			cards.append(Card.new(c, Enums.CardType.SKIP))
			cards.append(Card.new(c, Enums.CardType.REVERSE))
			cards.append(Card.new(c, Enums.CardType.DRAW_TWO))

	# 4 Wild + 4 Wild Draw Four (no color assigned yet).
	for i in range(4):
		cards.append(Card.new(Enums.CardColor.WILD, Enums.CardType.WILD))
		cards.append(Card.new(Enums.CardColor.WILD, Enums.CardType.WILD_DRAW_FOUR))

	return cards
