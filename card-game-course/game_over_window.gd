extends CanvasLayer

@onready var window_title: Label = $CenterContainer/PanelContainer/VBoxContainer/WindowTitle
@onready var restart_button: Button = $CenterContainer/PanelContainer/VBoxContainer/RestartButton
@onready var quit_button: Button = $CenterContainer/PanelContainer/VBoxContainer/QuitButton

func _ready() -> void:
	visible = false
	restart_button.pressed.connect(get_tree().reload_current_scene)
	quit_button.pressed.connect(get_tree().quit)

func open_window(is_winner: bool) -> void:
	visible = true
	if is_winner:
		window_title.text = "Victory"
	else:
		window_title.text = "Defeat"
