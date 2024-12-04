@tool
extends Node3D

const _1_BERRY = preload("res://Assets/1Berry.png")
const GATHERER = preload("res://Assets/gatherer.png")

@export var card_resource: CardResource:
	set(value):
		card_resource = value
		setup_card(card_resource)

@onready var cube_002: MeshInstance3D = $card/Cube_002
@onready var card_name: Label3D = $CardName
@onready var power_label: Label3D = $PowerLabel
@onready var health_label: Label3D = $HealthLabel
@onready var ability_texture: Sprite3D = $AbilityTexture
@onready var cost_texture: Sprite3D = $CostTexture

func setup_card(resource_in: CardResource) -> void:
	if not is_inside_tree():
		await ready
	card_name.text = resource_in.card_name
	power_label.text = str(resource_in.power)
	health_label.text = str(resource_in.health)
	
	match resource_in.cost:
		1:
			cost_texture.texture = _1_BERRY
		_:
			cost_texture.texture = null
			
	match resource_in.ability:
		CardResource.ability_types.GATHERER:
			ability_texture.texture = GATHERER
		_:
			ability_texture.texture = null
			
	cube_002.material_override.set("albedo_texture", resource_in.card_art)
