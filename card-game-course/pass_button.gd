extends Node3D

enum phases {
	MAIN,
	COMBAT
}

enum actors {
	PLAYER,
	ENEMY
}

var active_player := actors.PLAYER
var current_phase := phases.COMBAT

@onready var button_red: MeshInstance3D = $button_base_red2/button_base_red/button_red
@onready var green_material: StandardMaterial3D = button_red.get("surface_material_override/0")

signal change_phase

func _ready() -> void:
	current_phase = phases.MAIN
	active_player = actors.PLAYER
	change_phase.emit()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Click") and is_player_main_phase():
		pass_phase()

func pass_phase() -> void:
	match current_phase:
		phases.MAIN:
			current_phase = phases.COMBAT
		phases.COMBAT:
			current_phase = phases.MAIN
			active_player = actors.ENEMY if active_player == actors.PLAYER else actors.PLAYER
	if is_player_main_phase():
		button_red.set("surface_material_override/0", green_material)
	else:
		button_red.set("surface_material_override/0", null)
	change_phase.emit()
			
func is_player_main_phase() -> bool:
	return active_player == actors.PLAYER and current_phase == phases.MAIN
			
func is_player_combat_phase() -> bool:
	return active_player == actors.PLAYER and current_phase == phases.COMBAT
			
func is_enemy_main_phase() -> bool:
	return active_player == actors.ENEMY and current_phase == phases.MAIN
			
func is_enemy_combat_phase() -> bool:
	return active_player == actors.ENEMY and current_phase == phases.COMBAT
