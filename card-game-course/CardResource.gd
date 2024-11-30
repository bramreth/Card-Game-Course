extends Resource
class_name CardResource

enum ability_types {
	NONE,
	GATHERER
}

@export var card_name: String
@export var power: int
@export var health: int
@export var cost: int
@export var ability: ability_types
@export var card_art: Texture
