@tool
extends Node3D
class_name Hand

@export var deck: Deck
@export var height_curve: Curve
@export var width_cuve: Curve
@export var rotation_curve: Curve

@onready var rest_position = position
var tuck_position := Vector3(0, -0.5, 0.75)

func _ready() -> void:
	sort_hand()

func sort_hand() -> void:
	for card in get_children():
		var hand_ratio = 0.5
		if get_child_count() > 1:
			hand_ratio = float(card.get_index()) / float(get_child_count() - 1)
		var offset = Vector3.ZERO
		offset.x += width_cuve.sample(hand_ratio) * get_hand_width()
		offset.y += height_curve.sample(hand_ratio)
		offset.z += card.get_index() * 0.1
		card.target_position = global_position + global_basis * offset
		card.target_rotation = global_rotation.rotated(
			Vector3.FORWARD, 
			deg_to_rad(rotation_curve.sample(hand_ratio))
			)

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
			
func draw_card() -> void:
	var card = deck.get_top_card()
	if card == null:
		# We can make the player lose if they run out of cards here.
		return
	card.reparent(self, true)
	card.owner = self
	sort_hand()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		draw_card()
	
func tuck_cards() -> void:
	position = rest_position + tuck_position
	sort_hand()
	
func untuck_cards() -> void:
	position = rest_position
	sort_hand()
