extends Node

var root_dir:= "user://"
var save_dir:= "saves/"
var save_path:= root_dir + save_dir
var dir = DirAccess.open(root_dir)

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

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	Signals.GAME_save_loaded.connect(_set_active_save)
	Signals.GAME_update_save.connect(update_save)

func create_save(_name: String) -> ConfigFile:
	active_save = ConfigFile.new()
	if !_validate_save_dir():
		if !_create_save_dir():
			Debug.log_error(Enums.ErrorKey.SAVE_DIR)
			return
	_set_initial_save_values(_name)
	active_save.save(save_path + _name + ".ini")
	return active_save

func delete_save(_save: ConfigFile) -> bool:
	var save_name = _save.get_value("Player", "name")
	var _save_path = save_path + save_name + ".ini"
	var delete: bool
	if !dir.file_exists(_save_path):
		delete = false
	else:
		dir.remove(_save_path)
		delete = true
	if delete == false:
		Debug.log_error(Enums.ErrorKey.SAVE_DELETE)
		return false
	else:
		return true

func get_save_value(section: String, key: String) -> Variant:
	return active_save.get_value(section, key)

func load_save(_name: String) -> void:
	for _save in save_list:
		var save_name = _save.get_value("Player", "name")
		if save_name == _name:
			active_save = _save

func save() -> void:
	var save_name = active_save.get_value("Player", "name")
	if !validate_save(save_name):
		Debug.log_error(Enums.ErrorKey.SAVE_MISSING)
		return
	var _save_path = save_path + save_name + ".ini"
	if !_validate_save_dir():
		Debug.log_error(Enums.ErrorKey.SAVE_DIR)
	dir.remove(_save_path)
	active_save.save(_save_path)

func update_save(section: String, key: String, value: Variant) -> void:
	active_save.set_value(section, key, value)

func validate_save(_name: String) -> bool:
	var valid:= false
	for _save in save_list:
		var data = _load_data(_save)
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

func _set_active_save(_save: ConfigFile) -> void:
	active_save = _save

func _set_initial_save_values(_name: String) -> void:
	active_save.set_value("Save", "game", Reference.GAME_NAME)
	active_save.set_value("Save", "play_count", 0)
	active_save.set_value("Player", "name", _name)

func _validate_save_dir() -> bool:
	return dir.dir_exists(save_dir)
	