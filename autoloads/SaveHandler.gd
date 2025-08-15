extends Node

var root_dir:= "user://"
var save_dir:= "saves/"
var save_path:= root_dir + save_dir
var dir = DirAccess.open(root_dir)
var save_count: int:
	get:
		if _validate_save_dir():
			var _dir = DirAccess.open(save_path)
			var count = 0
			for file in _dir.get_files():
				var save_file = _dir.load(file)
				if save_file.get_value("Save", "Game", Reference.GAME_NAME):
					count += 1
			return count
		else: return 0

var active_save: ConfigFile
var save_list: Array:
	get:
		var list = []
		if _validate_save_dir():
			var _dir = DirAccess.open(save_path)
			for file in _dir.get_files():
				var save_file = ConfigFile.new()
				save_file.load(file)
				if save_file.get_value("Save", "Game", Reference.GAME_NAME):
					list.append(save_file)
		return list

class Save:
	var name: String
	var path: String
	var save_data: ConfigFile
	func _init() -> void:
		pass

func create_save(_name: String) -> void:
	active_save = ConfigFile.new()
	if !_validate_save_dir():
		if !_create_save_dir():
			Debug.log_error(Enums.ErrorKey.SAVE_DIR)
			return
	active_save.set_value("Save", "Game", Reference.GAME_NAME)
	active_save.set_value("Player", "name", _name)
	active_save.save(save_path + _name + ".ini")
	

func _create_save_dir() -> bool:
	return dir.make_dir(save_dir)

func _validate_save_dir() -> bool:
	return dir.dir_exists(save_dir)

	