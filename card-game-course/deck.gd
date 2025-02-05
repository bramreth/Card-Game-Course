extends Node3D
class_name Deck

const CARD = preload("res://card.tscn")

@onready var card_slot: Node3D = $CardSlot

@export var card_list: Array[CardResource]

func _ready() -> void:
	card_list.shuffle()
	for card_resource in card_list:
		var new_card = CARD.instantiate()
		new_card.card_resource = card_resource
		card_slot.add_child(new_card)
		new_card.owner = self
		new_card.global_position += Vector3.UP * 0.025 * new_card.get_index()

func get_top_card() -> Card:
	if card_slot.get_children().is_empty():
		return null
	return card_slot.get_children().back()
