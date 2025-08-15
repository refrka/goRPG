extends Node

func _ready() -> void:

	var game_root = SceneHandler.add_root(self)
	SceneHandler.add_scene(Enums.SceneKey.MAIN_MENU, game_root)

	if !Debug.check_log(Enums.ErrorKey.GAME_START):
		Signals.GAME_started.emit()
		
	Signals.DEBUG_print_errors.emit()
