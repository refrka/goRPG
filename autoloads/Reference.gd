extends Node

const GAME_NAME:= "goRPG"
const SceneKey = Enums.SceneKey

var scene_ref = {
	SceneKey.MAIN_MENU: {
		"path": "res://main/main_menu.tscn",
		"name": "Main Menu"
	},
}

func get_scene_path(key: SceneKey) -> String:
	if scene_ref.has(key):
		return scene_ref[key]["path"]
	else:
		return ""