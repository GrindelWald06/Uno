class_name Card
extends RefCounted
## Represents a single Uno card. Pure data + helpers — no scene, no visuals.

enum CardColor { RED, YELLOW, GREEN, BLUE, WILD }

enum CardType {
	NUMBER,
	SKIP,
	REVERSE,
	DRAW_TWO,
	WILD,
	WILD_DRAW_FOUR,
}

## The card's color. For WILD and WILD_DRAW_FOUR this starts as CardColor.WILD
## and gets reassigned to a real color once a player chooses one.
var color: CardColor

## What kind of card this is.
var type: CardType

## Only meaningful when type == Type.NUMBER (0-9). -1 otherwise.
var value: int = -1


func _init(p_color: CardColor, p_type: CardType, p_value: int = -1) -> void:
	color = p_color
	type = p_type
	value = p_value


## True for Wild and Wild Draw Four — cards not tied to a color until played.
func is_wild() -> bool:
	return type == CardType.WILD or type == CardType.WILD_DRAW_FOUR


## True for Skip, Reverse, Draw Two, Wild, Wild Draw Four.
func is_action_card() -> bool:
	return type != CardType.NUMBER


## Human-readable label, mostly for debugging/printing.
func _to_string() -> String:
	var color_name = CardColor.keys()[color]
	match type:
		CardType.NUMBER:
			return "%s %d" % [color_name, value]
		CardType.SKIP:
			return "%s Skip" % color_name
		CardType.REVERSE:
			return "%s Reverse" % color_name
		CardType.DRAW_TWO:
			return "%s Draw Two" % color_name
		CardType.WILD:
			return "Wild"
		CardType.WILD_DRAW_FOUR:
			return "Wild Draw Four"
	return "Unknown Card"


## Builds one full, standard 108-card Uno deck (unshuffled).
## Composition per color (Red/Yellow/Green/Blue):
##   one 0, two each of 1-9, two Skip, two Reverse, two Draw Two  -> 25 cards
## Times 4 colors -> 100 cards
## Plus 4 Wild + 4 Wild Draw Four -> 108 cards total.
static func create_full_deck() -> Array[Card]:
	var cards: Array[Card] = []
	var colors := [CardColor.RED, CardColor.YELLOW, CardColor.GREEN, CardColor.BLUE]

	for c in colors:
		# One 0 card per color.
		cards.append(Card.new(c, CardType.NUMBER, 0))

		# Two each of 1-9 per color.
		for n in range(1, 10):
			cards.append(Card.new(c, CardType.NUMBER, n))
			cards.append(Card.new(c, CardType.NUMBER, n))

		# Two each of Skip, Reverse, Draw Two per color.
		for i in range(2):
			cards.append(Card.new(c, CardType.SKIP))
			cards.append(Card.new(c, CardType.REVERSE))
			cards.append(Card.new(c, CardType.DRAW_TWO))

	# 4 Wild + 4 Wild Draw Four (no color assigned yet).
	for i in range(4):
		cards.append(Card.new(CardColor.WILD, CardType.WILD))
		cards.append(Card.new(CardColor.WILD, CardType.WILD_DRAW_FOUR))

	return cards
