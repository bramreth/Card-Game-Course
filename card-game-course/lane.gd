extends Node3D

signal selected(node: Node3D)

@onready var card_slot: Node3D = $CardSlot

func add_card(card: Node3D) -> void:
	var card_parent = card.get_parent()
	card.reparent(card_slot, false)
	card.transform = card_slot.transform
	if card_parent.has_method("sort_hand"):
		card_parent.sort_hand()
	
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		selected.emit(self)

func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
