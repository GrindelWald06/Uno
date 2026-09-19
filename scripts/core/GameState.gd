class_name GameState extends RefCounted

signal turn_started(player: Player)
signal player_drew_card(player: Player, card: Card)
signal card_played(player: Player, card: Card)
signal color_choice_needed(player: Player)
signal awaiting_human_move(player: Player, valid_moves: Array)
signal awaiting_human_draw(player: Player)
signal round_over(winner: Player)

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
		var is_ai := id != 0
		var player_name := "You" if id == 0 else "player_%d" % id
		players.append(Player.new(id, player_name, is_ai))

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
	turn_started.emit(current_player)
	print("Player %s's turn" % current_player.name)
	if not current_player.has_valid_move(discard.top_card(), active_color):
		print("Player %s has no valid card" % current_player.name)
		if current_player.is_ai:
			draw_card_for_player(current_player)
			advance_turn()
		else:
			awaiting_human_draw.emit(current_player)
		return

	var playable_cards = current_player.get_valid_moves(discard.top_card(), active_color)
	if pending_draw_count > 0:
		var drawn_cards = deck.draw_cards(pending_draw_count)
		for card in drawn_cards:
			current_player.add_card(card)
		print("Player %s draws %d cards" % [current_player.name, pending_draw_count])
		pending_draw_count = 0

	if current_player.is_ai:
		var card_to_play = prompt_card(playable_cards)
		resolve_card_choice(current_player, card_to_play)
	else:
		awaiting_human_move.emit(current_player, playable_cards)

func resolve_card_choice(player: Player, card: Card) -> void:
	player.remove_card(card)
	play_card(player, card)

	var needs_color_choice := (card.type == Enums.CardType.WILD or card.type == Enums.CardType.WILD_DRAW_FOUR) and not player.is_ai
	if needs_color_choice:
		return  # Paused — waiting on submit_human_color() before this turn can finish.

	_finish_turn_after_play(player)

func _finish_turn_after_play(player: Player) -> void:
	if player.has_no_cards():
		print("Player %s Won!!!!" % player.name)
		round_over.emit(player)
		return

	advance_turn()

func submit_human_color(color: Enums.CardColor) -> void:
	active_color = color
	var current_player = players[current_player_id]
	_finish_turn_after_play(current_player)

func play_card(player:Player, card:Card):
	print("Player %s plays %s" % [player.name, card])
	apply_effect(player, card)
	discard.push(card)
	card_played.emit(player, card)

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
		if player.is_ai:
			prompt_color(player)
		else:
			color_choice_needed.emit(player)
	elif card.type == Enums.CardType.WILD_DRAW_FOUR:
		print("Next player draws four cards")
		pending_draw_count += 4
		if player.is_ai:
			prompt_color(player)
		else:
			color_choice_needed.emit(player)
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
	player_drew_card.emit(player, drawn_card)
	if Utils.is_valid_move(drawn_card, discard.top_card(), active_color):
		play_card(player, drawn_card)
	else:
		player.add_card(drawn_card)

func prompt_color(_player:Player):
	active_color = Consts.VALID_COLORS.pick_random()
	print("Player %s chose a color" % _player.name)

func prompt_card(cards:Array):
	return cards.pick_random()

func submit_human_card(card: Card) -> void:
	var current_player = players[current_player_id]
	resolve_card_choice(current_player, card)

func submit_human_draw() -> void:
	var current_player = players[current_player_id]
	draw_card_for_player(current_player)
	advance_turn()
