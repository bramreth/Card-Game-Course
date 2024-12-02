@tool
extends Node3D

@export var height_curve: Curve
@export var width_cuve: Curve
@export var rotation_curve: Curve

func _ready() -> void:
	sort_hand()

func sort_hand() -> void:
	for card in get_children():
		var hand_ratio = 0.5
		if get_child_count() > 1:
			hand_ratio = float(card.get_index()) / float(get_child_count() - 1)
		card.position.x = width_cuve.sample(hand_ratio) * get_hand_width()
		card.position.y = height_curve.sample(hand_ratio)
		card.position.z = card.get_index() * 0.02
		card.rotation_degrees.z = rotation_curve.sample(hand_ratio)

func get_hand_width() -> float:
	match get_child_count():
		2:
			return 0.75
		3:
			return 1.25
		4:
			return 1.75
		_:
			return 2.0
