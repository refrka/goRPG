extends Node

var game_root: SceneHandler.Root

func _ready() -> void:
	_connect_signals() 
	game_root = SceneHandler.add_root(self)
	SceneHandler.add_scene(Enums.SceneKey.MAIN_MENU, game_root)

	if !Debug.check_log(Enums.ErrorKey.GAME_START):
		Signals.GAME_started.emit()

func _connect_signals() -> void:
	Signals.GAME_new_game_created.connect(_start_new_game)

func _start_new_game() -> void:
	SceneHandler.add_scene(Enums.SceneKey.MAIN_GAME, game_root)
