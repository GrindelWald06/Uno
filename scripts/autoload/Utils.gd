extends Node

func is_valid_move(card: Card, top_card: Card, active_color: Enums.CardColor) -> bool:
	# if active color is wild (at the start of the game) any card can be played
	if active_color == Enums.CardColor.WILD:
		return true

	# Wild cards can always be played
	if card.type == Enums.CardType.WILD \
	or card.type == Enums.CardType.WILD_DRAW_FOUR:
		return true

	# Match active color
	if card.color == active_color:
		return true

	# Number cards must have the same number
	if card.type == Enums.CardType.NUMBER \
	and top_card.type == Enums.CardType.NUMBER:
		return card.value == top_card.value

	# Action cards can be played if they have the same type
	if card.type == top_card.type:
		return true

	return false
