extends Node

const ITEM_TYPE = Enums.ItemType
const GAME_NAME:= "goRPG"
const SAVE_COUNT_MAX = 5
const SceneKey = Enums.SceneKey

var item_type_ref = {
	ITEM_TYPE.ITEM_TYPE_A: "item_type_A",
	ITEM_TYPE.ITEM_TYPE_B: "item_type_B",
	ITEM_TYPE.WEAPONS: "weapons",
}

var save_template = {
	"game": "goRPG",
	"player": {},
	"inventory": {
		"item_type_A": [
			"item_A",
			"item_B",
		],
		"item_type_B": [
			"item_C",
			"item_D",
		],
		"weapons": [
			"sword",
		]
		
	}
}

var scene_ref = {
	SceneKey.MAIN_MENU: {
		"path": "res://main/main_menu.tscn",
		"name": "Main Menu"
	},
	SceneKey.MAIN_GAME: {
		"path": "res://main/main_game.tscn",
		"name": "Main Game"
	},
	SceneKey.PLAYER_PROFILE: {
		"path": "res://player/player_profile.tscn",
		"name": "Player Profile"
	},
}

func get_scene_path(key: SceneKey) -> String:
	if scene_ref.has(key):
		return scene_ref[key]["path"]
	else:
		return ""