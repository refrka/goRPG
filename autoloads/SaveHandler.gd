extends Node

var root_dir:= "user://"
var save_dir:= "saves/"
var save_path:= root_dir + save_dir
var dir = DirAccess.open(root_dir)


var active_save: Dictionary
var save_list: Array:
	get:
		save_list = []
		if _validate_save_dir():
			var _dir = DirAccess.open(save_path)
			for _save in _dir.get_files():
				var save_file = FileAccess.open(save_path + _save, FileAccess.READ)
				var save_file_string = save_file.get_as_text()
				if _validate_save_file(save_file_string):
					var save_data = JSON.new()
					save_data.parse(save_file_string)
					save_list.append(save_data.data)
		return save_list

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	Signals.GAME_save_loaded.connect(_set_active_save)
	Signals.GAME_update_save.connect(update_save)

func create_new_save(_name: String) -> Dictionary:
	if !_validate_save_dir():
		if !_create_save_dir():
			Debug.log_error(Enums.ErrorKey.SAVE_DIR_CREATE)
	var new_save = _new_save_template(_name)
	var new_save_string = _serialize_save_data(new_save)
	if !_write_data_to_file(new_save_string):
		Debug.log_error(Enums.ErrorKey.SAVE_WRITE_FAIL)
		new_save = {}
	return new_save

func delete_save(save_data: Dictionary) -> bool:
	var save_name = save_data["player"]["name"]
	var _save_path = save_path + save_name + ".txt"
	var delete_error:= false
	if !_validate_save_dir():
		return false
	if !dir.file_exists(_save_path):
		delete_error = true
	else:
		dir.remove(_save_path)
	if delete_error == true:
		Debug.log_error(Enums.ErrorKey.SAVE_DELETE)
		return false
	else:
		return true

func load_save(_save_data: Dictionary) -> void:
	Signals.GAME_save_loaded.emit(_save_data)

func save() -> void:
	var save_name = active_save["player"]["name"]
	if !validate_save(save_name):
		Debug.log_error(Enums.ErrorKey.SAVE_MISSING)
		return
	var _save_path = save_path + save_name + ".txt"
	dir.remove(_save_path)
	var save_data_string = _serialize_save_data(active_save)
	if !_write_data_to_file(save_data_string):
		Debug.log_error(Enums.ErrorKey.SAVE_WRITE_FAIL)
	else:
		Signals.GAME_saved.emit()

func save_value(section: String, key: String, value: Variant) -> void:
	if active_save.has(section):
		active_save[section][key] = value
	save()

func update_save(section: String, key: String, value: Variant) -> void:
	pass

func validate_save(_name: String) -> bool:
	var save_file = FileAccess.open(save_path + _name + ".txt", FileAccess.READ)
	if save_file == null:
		return false
	else:
		return true
	



func _create_save_dir() -> bool:
	var new_dir_error = dir.make_dir(save_dir)
	if new_dir_error:
		return false
	else:
		return true

func _get_name_from_data(json_data: String) -> String:
	var parsed_data = JSON.parse_string(json_data)
	return parsed_data["player"]["name"]

func _new_save_template(_name: String) -> Dictionary: # Create a new .txt file via JSON
	var new_save = Reference.save_template.duplicate()
	new_save["player"]["name"] = _name
	return new_save

func _serialize_save_data(_data: Dictionary) -> String:
	var json = JSON.stringify(_data)
	return json

func _set_active_save(_save_data: Dictionary) -> void:
	active_save = _save_data

func _validate_save_dir() -> bool:
	if !dir.dir_exists(save_dir):
		Debug.log_error(Enums.ErrorKey.SAVE_DIR)
		return false
	return true

func _validate_save_file(json_string: String) -> bool:
	var json = JSON.new()
	json.parse(json_string)
	if json.data["game"] == "goRPG":
		return true
	else:
		return false

func _write_data_to_file(json_data: String) -> bool:
	var _name = _get_name_from_data(json_data)
	var save_file = FileAccess.open(save_path + _name + ".txt", FileAccess.WRITE)
	var error = save_file.store_string(json_data)
	return error

