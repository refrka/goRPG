extends Control

var new_game: NewGame
var save_row = preload("res://main/save_row.tscn")

class NewGame:
	var name: String:
		set(value):
			if _validate_name(value):
				name_error()
				create_button.disabled = true
			else:
				error_label.text = ""
				create_button.disabled = false
			name = value
	var name_entry: LineEdit
	var error_label: RichTextLabel
	var create_button: Button
	func _init(_name_entry: LineEdit, _error_label: RichTextLabel, _create_button: Button) -> void:
		name_entry = _name_entry
		error_label = _error_label
		create_button = _create_button
		name_entry.text_changed.connect(_set_name)
	func _set_name(_name: String) -> void:
		name = _name
	func _validate_name(_name: String) -> bool:
		return SaveHandler.validate_save(_name)
	func name_error() -> void:
		error_label.text = "The entered name is invalid."

func _ready() -> void:
	new_game = NewGame.new(%NameEntry, %NameEntryError, %CreateGameButton)
	_connect_signals()
	_show(%MainMenu)

func _connect_signals() -> void:
	%NewGameButton.pressed.connect(_new_game)
	%LoadGameButton.pressed.connect(_load_game)
	%NameEntry.text_submitted.connect(_on_name_submitted)
	%CreateGameButton.pressed.connect(func():%NameEntry.text_submitted.emit(%NameEntry.text))
	%BackButton.pressed.connect(_main_menu)

func _load_game() -> void:
	_show(%LoadGameMenu)
	var count = 0
	for save in SaveHandler.save_list:
		count += 1
		var hbox = _create_save_row(save)
		%SaveList.add_child(hbox)
		
func _create_save_row(save: ConfigFile) -> HBoxContainer:
	var row = save_row.instantiate()
	var row_label = row.find_child("SaveName")
	var row_button = row.find_child("DeleteButton")
	row_button.pressed.connect(_delete_menu.bind(save))
	row_label.text = save.get_value("Player", "name")
	return row

func _delete_menu(save: ConfigFile) -> void:
	var save_name = save.get_value("Player", "name")
	%DeleteLabel.text = "Are you sure you want to delete the save '%s'?" % save_name
	%DeleteButton.pressed.connect(_delete_save.bind(save))
	_show(%DeleteSaveMenu)

func _delete_save(save: ConfigFile) -> void:
	print("_delete_save main_menu.gd")
	var save_name = save.get_value("Player", "name")
	if !SaveHandler.validate_save(save_name):
		Debug.log_error(Enums.ErrorKey.SAVE_LIST_MISSING)
		return
	if SaveHandler.delete_save(save):
		print("deleted")
		%DeleteLabel.text = "Save deleted"
		%DeleteButton.visible = false

func _main_menu() -> void:
	_show(%MainMenu)

func _new_game() -> void:
	_show(%NewGameMenu)
	%NameEntry.edit()

func _on_menu_button_pressed(_callable: Callable) -> void:
	_callable.call()

func _on_name_submitted(_name: String) -> void:
	if _name == "":
		new_game.name_error()
		return
	SaveHandler.create_save(_name)
	if new_game == SaveHandler.active_save:
		Signals.GAME_new_game_created.emit()
	visible = false
	
func _show(menu: Node) -> void:
	for child in get_children():
		child.visible = false
	if menu != %MainMenu:
		%BackButtonNode.visible = true
	else:
		%BackButtonNode.visible = false
	menu.visible = true
