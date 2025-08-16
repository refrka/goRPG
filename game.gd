extends Node

var game_root: SceneHandler.Root
var main_menu: Node

func _ready() -> void:
	_connect_signals() 
	game_root = SceneHandler.add_root(self)
	SceneHandler.add_scene(Enums.SceneKey.MAIN_MENU, game_root)

	if !Debug.check_log(Enums.ErrorKey.GAME_START):
		Signals.GAME_started.emit()

func _connect_signals() -> void:
	Signals.GAME_save_loaded.connect(_start_game)

func _start_game(_save: ConfigFile) -> void:
	SceneHandler.add_scene(Enums.SceneKey.MAIN_GAME, game_root)
	var play_count = SaveHandler.get_save_value("Save", "play_count")
	Signals.GAME_update_save.emit("Save", "play_count", play_count + 1)
	SaveHandler.save()

func _unhandled_input(input: InputEvent) -> void:
	if input.is_action_pressed("debug_log"):
		Debug.print_error_log()