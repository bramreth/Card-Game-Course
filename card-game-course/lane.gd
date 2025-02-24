extends Node3D
class_name Lane

signal selected(node: Lane)

@onready var highlight: MeshInstance3D = $Highlight
@onready var card_slot: Node3D = $CardSlot

func add_card(card: Node3D) -> void:
	var card_parent = card.get_parent()
	card.reparent(card_slot, false)
	card.owner = self
	card.transform = card_slot.transform
	if card_parent.has_method("sort_hand"):
		card_parent.sort_hand()
	
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if is_empty():
			selected.emit(self)

func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func is_empty() -> bool:
	return card_slot.get_child_count() == 0

func toggle_highlight(is_highlighted: bool) -> void:
	highlight.visible = is_highlighted
