extends Control

func _ready() -> void:
	_connect_signals()
	%MenuList.visible = false
	%MenuButton.pressed.connect(_show_game_menu)
	%MenuSaveButton.pressed.connect(_save_game)
	%MenuQuitButton.pressed.connect(_quit_game)
	gui_input.connect(_select_bg)

func _connect_signals() -> void:
	pass

func _hide_game_menu() -> void:
	if %MenuButton.pressed.is_connected(_hide_game_menu):
		%MenuButton.pressed.disconnect(_hide_game_menu)
		%MenuButton.pressed.connect(_show_game_menu)
	%MenuList.visible = false

func _quit_game() -> void:
	queue_free()
	Signals.GAME_quit.emit()

func _save_game() -> void:
	SaveHandler.save()

func _select_bg(input: InputEvent) -> void:
	if input.is_action_pressed("select"):
		_hide_game_menu()

func _show_game_menu() -> void:
	if %MenuButton.pressed.is_connected(_show_game_menu):
		%MenuButton.pressed.disconnect(_show_game_menu)
		%MenuButton.pressed.connect(_hide_game_menu)
	%MenuList.visible = true