extends Node3D

signal selected(node)

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		selected.emit(self)


func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
