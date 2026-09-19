class_name GameController extends Node

@export var game_board: GameBoard

var game_state: GameState
var human_player: Player

var _awaiting_draw: bool = false


func _ready() -> void:
	game_state = GameState.new()

	game_state.turn_started.connect(_on_turn_started)
	game_state.card_played.connect(_on_card_played)
	game_state.player_drew_card.connect(_on_player_drew_card)
	game_state.awaiting_human_move.connect(_on_awaiting_human_move)
	game_state.awaiting_human_draw.connect(_on_awaiting_human_draw)
	game_state.color_choice_needed.connect(_on_color_choice_needed)
	game_state.round_over.connect(_on_round_over)

	game_board.card_confirmed.connect(_on_card_confirmed)
	game_board.draw_pile_pressed.connect(_on_draw_pile_pressed)
	game_board.color_chosen.connect(_on_color_chosen)

	game_state.start_game()
	human_player = game_state.players.filter(func(p): return not p.is_ai)[0]
	_setup_initial_board()

	game_state.start_turn()


func _setup_initial_board() -> void:
	var opponents: Array[Player] = game_state.players.filter(func(p): return p != human_player)
	game_board.setup_opponents(opponents)
	game_board.set_hand(human_player.hand)
	game_board.set_discard_top_card(game_state.discard.top_card())
	game_board.set_draw_pile_count(game_state.deck.cards.size())
	game_board.set_hand_interactive(false)


func _on_card_confirmed(card: Card) -> void:
	if card == null:
		return
	game_state.submit_human_card(card)

func _on_draw_pile_pressed() -> void:
	if not _awaiting_draw:
		return
	game_state.submit_human_draw()

func _on_color_chosen(color: Enums.CardColor) -> void:
	game_state.submit_human_color(color)



func _on_turn_started(player: Player) -> void:
	game_board.set_active_player(player)
	_awaiting_draw = false
	game_board.set_hand_interactive(false)

func _on_card_played(player: Player, _card: Card) -> void:
	game_board.set_discard_top_card(game_state.discard.top_card())
	if player == human_player:
		game_board.set_hand(human_player.hand)
	else:
		game_board.update_opponent_count(player, player.hand.size())

func _on_player_drew_card(player: Player, _card: Card) -> void:
	game_board.set_draw_pile_count(game_state.deck.cards.size())
	if player == human_player:
		game_board.set_hand(human_player.hand)
	else:
		game_board.update_opponent_count(player, player.hand.size())

func _on_awaiting_human_move(_player: Player, valid_moves: Array) -> void:
	game_board.set_hand_interactive(true)
	var typed_moves: Array[Card] = []
	typed_moves.assign(valid_moves)
	game_board.set_playable_cards(typed_moves)

func _on_awaiting_human_draw(_player: Player) -> void:
	_awaiting_draw = true

func _on_color_choice_needed(_player: Player) -> void:
	game_board.show_color_picker()

func _on_round_over(winner: Player) -> void:
	print("Game over! %s wins!" % winner.name)
	game_board.set_hand_interactive(false)
