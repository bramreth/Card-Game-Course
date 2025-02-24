extends Node3D

signal lane_selected(node: Lane)

@onready var hand: Hand = $Hand

@onready var left_lane: Lane = $Lanes/LeftLane
@onready var middle_lane: Node3D = $Lanes/MiddleLane
@onready var right_lane: Lane = $Lanes/RightLane

@onready var lanes := [left_lane, middle_lane, right_lane]

func _ready() -> void:
	for card in get_tree().get_nodes_in_group("card"):
		card.play_card.connect(play_card)
	for lane in lanes:
		lane.selected.connect(
			func(node):
				lane_selected.emit(node)
		)

func play_card(card: Node3D) -> void:
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
