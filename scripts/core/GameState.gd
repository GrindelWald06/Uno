class_name GameState
extends RefCounted

var players:Array[Player]
var deck:Deck
var discard:DiscardPile
var current_player_id:int
var direction:int
var skip:bool
var active_color:Enums.CardColor
var pending_draw_count:int
var current_phase:Enums.GamePhase

func _init() -> void:
	pass

func start_game():
	#Setup Deck
	deck = Deck.new()
	
	#Setup players
	players = []
	for id in range(Config.NUMBER_OF_PLAYERS):
		players.append(Player.new(id, "player_%d"%id, true))
	for i in range(7):
		for player in players:
			player.add_card(deck.draw_card())
	current_player_id = randi_range(0, Config.NUMBER_OF_PLAYERS-1)
	
	#Setup discard
	discard = DiscardPile.new()
	discard.push(deck.draw_card())
	print("First card: %s" % discard.top_card())
	active_color = discard.top_card().color
	
	#Setup game
	current_phase = Enums.GamePhase.WAITING
	direction = 1
	skip = false
	pending_draw_count = 0

func start_turn():
	var current_player = players[current_player_id]
	print("Player %s's turn" % current_player.name)
	if not current_player.has_valid_move(discard.top_card(), active_color):
		print("Player %s has no valid card" % current_player.name)
		draw_card_for_player(current_player)
	else:
		var playable_cards = current_player.get_valid_moves(discard.top_card(), active_color)
		if pending_draw_count > 0:
			var drawn_cards = deck.draw_cards(pending_draw_count)
			for card in drawn_cards:
				current_player.add_card(card)
			print("Player %s draws %d cards" % [current_player.name, pending_draw_count])
			pending_draw_count = 0
		var card_to_play = prompt_card(playable_cards)
		current_player.remove_card(card_to_play)
		play_card(current_player, card_to_play)
		if current_player.has_no_cards():
			print("Player %s Won!!!!" % current_player.name)
			return
	advance_turn()

func play_card(player:Player, card:Card):
	print("Player %s plays %s" % [player.name, card])
	apply_effect(player, card)
	discard.push(card)

func apply_effect(player:Player, card:Card):
	if card.type == Enums.CardType.SKIP:
		print("Next player's turn is skipped")
		skip = true
		active_color = card.color
	elif card.type == Enums.CardType.REVERSE:
		print("Direction of play is reversed")
		direction *= -1
		active_color = card.color
	elif card.type == Enums.CardType.DRAW_TWO:
		print("Next player draws two cards")
		pending_draw_count += 2
		active_color = card.color
	elif card.type == Enums.CardType.WILD:
		prompt_color(player)
	elif card.type == Enums.CardType.WILD_DRAW_FOUR:
		print("Next player draws four cards")
		pending_draw_count += 4
		prompt_color(player)
	elif card.type == Enums.CardType.NUMBER:
		active_color = card.color

func advance_turn():
	var step = 1
	if skip:
		step = 2
		skip = false
	if direction == 1:
		current_player_id = (current_player_id + step) % Config.NUMBER_OF_PLAYERS
	else:
		current_player_id = (current_player_id - step + Config.NUMBER_OF_PLAYERS) % Config.NUMBER_OF_PLAYERS
	start_turn()

func draw_card_for_player(player:Player):
	print("Player %s draws a card" % player.name)
	var drawn_card = deck.draw_card()
	if Utils.is_valid_move(drawn_card, discard.top_card(), active_color):
		play_card(player, drawn_card)
	else:
		player.add_card(drawn_card)

func prompt_color(_player:Player):
	active_color = Consts.VALID_COLORS.pick_random()
	print("Player %s chose a color" % _player.name)

func prompt_card(cards:Array):
	return cards.pick_random()
