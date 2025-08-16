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
		save_list = []
		if _validate_save_dir():
			var _dir = DirAccess.open(save_path)
			for file in _dir.get_files():
				var save_file = ConfigFile.new()
				save_file.load(save_path + file)
				save_list.append(save_file)
		return save_list

class Save:
	var name: String
	var path: String
	var save_data: ConfigFile
	func _init() -> void:
		pass

func create_save(_name: String) -> ConfigFile:
	active_save = ConfigFile.new()
	if !_validate_save_dir():
		if !_create_save_dir():
			Debug.log_error(Enums.ErrorKey.SAVE_DIR)
			return
	active_save.set_value("Save", "Game", Reference.GAME_NAME)
	active_save.set_value("Player", "name", _name)
	active_save.save(save_path + _name + ".ini")
	return active_save

func delete_save(save: ConfigFile) -> bool:
	var _save_name = save.get_value("Player", "name")
	var _save_path = save_path + _save_name + ".ini"
	var delete: bool
	if !dir.file_exists(_save_path):
		delete = false
		print("no dir")
	if !dir.remove(_save_path):
		delete = false
		print("no file at path")
	else: 
		delete = true
	if delete == false:
		Debug.log_error(Enums.ErrorKey.SAVE_DELETE)
		return false
	else:
		return true


func load_save(_name: String) -> void:
	for save in save_list:
		var save_name = save.get_value("Player", "name")
		if save_name == _name:
			active_save = save

func validate_save(_name: String) -> bool:
	var valid:= false
	for save in save_list:
		var data = _load_data(save)
		if data["name"] == _name:
			valid = true
	return valid
	

func _create_save_dir() -> bool:
	var new_dir_error = dir.make_dir(save_dir)
	if new_dir_error:
		return false
	else:
		return true

func _load_data(save_file: ConfigFile) -> Dictionary:
	var save_data = {}
	save_data["name"] = save_file.get_value("Player", "name", null)
	return save_data


func _validate_save_dir() -> bool:
	return dir.dir_exists(save_dir)

	