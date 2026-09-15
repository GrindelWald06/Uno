extends Node2D

var deck:Deck
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck = Deck.new()
	print(deck.draw_cards(10))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
