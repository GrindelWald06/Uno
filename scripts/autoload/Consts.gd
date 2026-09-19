extends Node

const VALID_COLORS = [
	Enums.CardColor.RED,
	Enums.CardColor.YELLOW,
	Enums.CardColor.GREEN,
	Enums.CardColor.BLUE
]

const COLOR_MAP := {
	Enums.CardColor.RED: Color(0.85, 0.15, 0.15),
	Enums.CardColor.YELLOW: Color(0.95, 0.8, 0.1),
	Enums.CardColor.GREEN: Color(0.15, 0.6, 0.25),
	Enums.CardColor.BLUE: Color(0.1, 0.35, 0.75),
	Enums.CardColor.WILD: Color(0.15, 0.15, 0.15),
}
