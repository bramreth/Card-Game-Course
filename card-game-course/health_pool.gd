extends Node3D
class_name HealthPool

@onready var label_3d: Label3D = $Label3D

var health := 5:
	set(value):
		health = value
		label_3d.text = str(health)
