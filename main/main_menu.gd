extends Control

func _ready() -> void:
	_connect_signals()
	%MainMenu.visible = true
	%NewGameMenu.visible = false

func _connect_signals() -> void:
	%NewGameButton.pressed.connect(_on_menu_button_pressed.bind(_new_game))
	%LoadGameButton.pressed.connect(_on_menu_button_pressed.bind(_load_game))
	%NameEntry.text_submitted.connect(_on_name_submitted)
	%CreateGameButton.pressed.connect(_on_name_submitted.bind(%NameEntry.text))

func _load_game() -> void:
	pass

func _new_game() -> void:
	%MainMenu.visible = false
	%NewGameMenu.visible = true
	%NameEntry.edit()

func _on_menu_button_pressed(_callable: Callable) -> void:
	_callable.call()

func _on_name_submitted(_name: String) -> void:
	SaveHandler.create_save(_name)
	print(SaveHandler.save_list)