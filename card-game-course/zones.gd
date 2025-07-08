extends Node3D

signal lane_selected(node: Lane)

@onready var hand: Hand = $Hand

@onready var left_lane: Lane = $Lanes/LeftLane
@onready var middle_lane: Node3D = $Lanes/MiddleLane
@onready var right_lane: Lane = $Lanes/RightLane
@onready var pass_button: Node3D = $"../PassButton"

@onready var lanes := [left_lane, middle_lane, right_lane]

@onready var player_health_pool: HealthPool = $"../PlayerHealthPool"
@onready var enemy_health_pool: HealthPool = $"../EnemyHealthPool"
@onready var game_over_window: CanvasLayer = $"../GameOverWindow"

func _ready() -> void:
	for card in get_tree().get_nodes_in_group("card"):
		card.play_card.connect(play_card)
	for lane in lanes:
		lane.selected.connect(
			func(node):
				lane_selected.emit(node)
		)
	pass_button.change_phase.connect(start_phase)

func play_card(card: Node3D) -> void:
	if pass_button.is_player_main_phase() == false:
		return
	cancel_targetting()
	for current_lane in lanes:
		if current_lane.is_empty():
			current_lane.toggle_highlight(true)
	hand.tuck_cards()
	var lane = await lane_selected
	if not lane == null:
		lane.add_card(card)
	for current_lane in lanes:
		current_lane.toggle_highlight(false)
	hand.untuck_cards()
	
func cancel_targetting() -> void:
	lane_selected.emit(null)
	
func start_phase() -> void:
	cancel_targetting()
	if pass_button.is_player_main_phase():
		hand.draw_card()
	elif pass_button.is_player_combat_phase():
		player_start_combat()
	elif pass_button.is_enemy_main_phase():
		await get_tree().create_timer(1.0).timeout
		pass_button.pass_phase()
	elif pass_button.is_enemy_combat_phase():
		await get_tree().create_timer(1.0).timeout
		pass_button.pass_phase()

func player_start_combat() -> void:
	var tween = create_tween()
	for lane in lanes:
		lane.start_attack(tween)
	tween.tween_callback(check_health_pools.bind(tween))
	tween.tween_callback(pass_button.pass_phase)

func check_health_pools(tween: Tween) -> void:
	if enemy_health_pool.health <= 0:
		game_over_window.open_window(true)
		tween.kill()
