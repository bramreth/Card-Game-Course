extends Node3D

@onready var middle_lane: Node3D = $Lanes/MiddleLane

@onready var lanes := [middle_lane]

func _ready() -> void:
	for card in get_tree().get_nodes_in_group("card"):
		card.play_card.connect(play_card)

func play_card(card: Node3D) -> void:
	var lane = await middle_lane.selected
	lane.add_card(card)
