extends Node3D
class_name Lane

signal selected(node: Lane)

@export var defending_health: HealthPool
@export var defending_lane: Lane

@onready var highlight: MeshInstance3D = $Highlight
@onready var card_slot: Node3D = $CardSlot

func add_card(card: Node3D) -> void:
	var card_parent = card.get_parent()
	card.reparent(card_slot, true)
	card.owner = self
	card.target_rotation = card_slot.global_rotation
	card.target_position = card_slot.global_position
			
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
	
func start_attack(tween: Tween) -> void:
	if is_empty() == false:
		tween.tween_callback(toggle_highlight.bind(true))
		tween.tween_interval(0.5)
		tween.tween_callback(toggle_highlight.bind(false))
		tween.tween_callback(deal_damage)
	tween.tween_interval(0.25)
		
func deal_damage() -> void:
	if is_empty():
		return
	var card = card_slot.get_child(0) as Card
	var power = card.card_resource.power
	defending_health.health -= power
	
