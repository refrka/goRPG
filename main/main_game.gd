extends Control

var main_game_root: SceneHandler.Root

func _ready() -> void:
	main_game_root = SceneHandler.add_root(self)
	_connect_signals()
	_connect_buttons()
	gui_input.connect(_select_bg)

func _connect_signals() -> void:
	Signals.PLAYER_profile_closed.connect(func():%MenuButton.visible = true)

func _connect_buttons() -> void:
	%MenuList.visible = false
	%QuitConfirm.visible = false
	%MenuButton.pressed.connect(_show_game_menu)
	%MenuSaveButton.pressed.connect(_save_game)
	%MenuProfileButton.pressed.connect(_open_profile)
	%MenuQuitButton.pressed.connect(_quit_game)
	%QuitSaveButton.pressed.connect(_save_game)
	%QuitQuitButton.pressed.connect(_quit_game.bind(true))

func _hide_game_menu() -> void:
	if %MenuButton.pressed.is_connected(_hide_game_menu):
		%MenuButton.pressed.disconnect(_hide_game_menu)
		%MenuButton.pressed.connect(_show_game_menu)
	%SaveConfirmLabel.text = ""
	%QuitConfirm.visible = false
	%MenuList.visible = false

func _open_profile() -> void:
	%MenuList.visible = false
	%MenuButton.visible = false
	%MenuButton.pressed.disconnect(_hide_game_menu)
	%MenuButton.pressed.connect(_show_game_menu)
	SceneHandler.add_scene(Enums.SceneKey.PLAYER_PROFILE, main_game_root)

func _quit_game(_confirmed:=false) -> void:
	if !_confirmed:
		%QuitConfirm.visible = !%QuitConfirm.visible
		return
	queue_free()
	Signals.GAME_quit.emit()

func _save_game() -> void:
	%SaveConfirmLabel.text = "Saved!"
	SaveHandler.save()

func _select_bg(input: InputEvent) -> void:
	if input.is_action_pressed("select"):
		_hide_game_menu()

func _show_game_menu() -> void:
	if %MenuButton.pressed.is_connected(_show_game_menu):
		%MenuButton.pressed.disconnect(_show_game_menu)
		%MenuButton.pressed.connect(_hide_game_menu)
	%MenuList.visible = true