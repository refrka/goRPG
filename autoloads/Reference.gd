extends Node

const GAME_NAME:= "goRPG"
const SAVE_COUNT_MAX = 3
const SceneKey = Enums.SceneKey

var scene_ref = {
	SceneKey.MAIN_MENU: {
		"path": "res://main/main_menu.tscn",
		"name": "Main Menu"
	},
	SceneKey.MAIN_GAME: {
		"path": "res://main/main_game.tscn",
		"name": "Main Game"
	},
}

func get_scene_path(key: SceneKey) -> String:
	if scene_ref.has(key):
		return scene_ref[key]["path"]
	else:
		return ""