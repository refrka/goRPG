extends Control

var new_game: NewGame
var save_row = preload("res://main/save_row.tscn")
var selected_row: PanelContainer

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
	name = "MainMenu"
	new_game = NewGame.new(%NameEntry, %NameEntryError, %CreateGameButton)
	_connect_signals()
	_show(%MainMenu)

func _connect_signals() -> void:
	%NewGameButton.pressed.connect(_new_game)
	%LoadGameButton.pressed.connect(_load_game)
	%NameEntry.text_submitted.connect(_on_name_submitted)
	%CreateGameButton.pressed.connect(func():%NameEntry.text_submitted.emit(%NameEntry.text))
	%BackButton.pressed.connect(_main_menu)
	Signals.GAME_quit.connect(_show.bind(%MainMenu))
		
func _create_save_row(save: ConfigFile) -> PanelContainer:
	var row = save_row.instantiate()
	var row_label = row.find_child("SaveName")
	var row_button = row.find_child("DeleteButton")
	row_button.pressed.connect(_delete_menu.bind(row, save))
	row_label.text = save.get_value("Player", "name")
	row.gui_input.connect(_save_row_selected.bind(row, save))
	return row

func _delete_menu(row: PanelContainer, save: ConfigFile) -> void:
	var save_name = save.get_value("Player", "name")
	%DeleteButton.visible = true
	%DeleteLabel.text = "Are you sure you want to delete the save '%s'?" % save_name
	%DeleteButton.pressed.connect(_delete_save.bind(row, save))
	_show(%DeleteSaveMenu)

func _delete_save(row: PanelContainer, save: ConfigFile) -> void:
	var save_name = save.get_value("Player", "name")
	if !SaveHandler.validate_save(save_name):
		Debug.log_error(Enums.ErrorKey.SAVE_MISSING)
		return
	if SaveHandler.delete_save(save):
		row.queue_free()
		%DeleteLabel.text = "Save deleted"
		%DeleteButton.visible = false
		%DeleteButton.pressed.disconnect(_delete_save)

func _load_game() -> void:
	%LoadSaveButton.disabled = true
	_show(%LoadGameMenu)
	if SaveHandler.save_list.size() == 0:
		%LoadGameLabel.text = "No saves."
		%LoadSaveButton.disabled = true
	else:
		%LoadGameLabel.text = "Current saves:"
		for child in %SaveList.get_children():
			if child != %LoadGameLabel:
				%SaveList.remove_child(child)
		for save in SaveHandler.save_list:
			var hbox = _create_save_row(save)
			%SaveList.add_child(hbox)

func _load_save(save: ConfigFile) -> void:
	Signals.GAME_save_loaded.emit(save)
	visible = false

func _main_menu() -> void:
	%NameEntry.text = ""
	_show(%MainMenu)

func _new_game() -> void:
	if SaveHandler.save_list.size() >= Reference.SAVE_COUNT_MAX:
		%CreateGameButton.disabled = true
		%NameEntry.editable = false
		%NameEntryError.text = "Delete a save to make room."
	else:
		%CreateGameButton.disabled = false
		%NameEntry.editable = true
		%NameEntry.edit()
	_show(%NewGameMenu)

func _on_menu_button_pressed(_callable: Callable) -> void:
	_callable.call()

func _on_name_submitted(_name: String) -> void:
	if _name == "":
		new_game.name_error()
		return
	var new_save = SaveHandler.create_save(_name)
	if new_save == SaveHandler.active_save:
		Signals.GAME_save_loaded.emit(new_save)
	visible = false
	
func _save_row_selected(input: InputEvent, row: PanelContainer, save: ConfigFile) -> void:
	if input.is_action_pressed("select"):
		if %LoadSaveButton.pressed.has_connections():
			%LoadSaveButton.pressed.disconnect(_load_save)
		%LoadSaveButton.disabled = false
		%LoadSaveButton.pressed.connect(_load_save.bind(save))
		selected_row = row
		for _save_row in %SaveList.get_children():
			if _save_row != row:
				var _stylebox = _save_row.get_theme_stylebox("panel").duplicate()
				_stylebox.draw_center = false
				_save_row.add_theme_stylebox_override("panel", _stylebox)

		var stylebox = row.get_theme_stylebox("panel").duplicate()
		stylebox.draw_center = true
		row.add_theme_stylebox_override("panel", stylebox)

func _show(menu: Node) -> void:
	visible = true
	for child in get_children():
		child.visible = false
	if menu != %MainMenu:
		%BackButtonNode.visible = true
	else:
		%BackButtonNode.visible = false
	menu.visible = true
