extends Control

var new_game: NewGameModel
var save_row = preload("res://main/save_row.tscn")
var save_index:= {}

# Model for the new game creation input
class NewGameModel:
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
	new_game = NewGameModel.new(%NameEntry, %NameEntryError, %CreateGameButton)
	_connect_signals()
	_connect_buttons()
	_show(%MainMenu)

func _connect_signals() -> void:
	Signals.GAME_quit.connect(_show.bind(%MainMenu))

func _connect_buttons() -> void:
	%NewGameButton.pressed.connect(_new_game)
	%LoadGameButton.pressed.connect(_load_game)
	%NameEntry.text_submitted.connect(_on_name_submitted)
	%CreateGameButton.pressed.connect(func():%NameEntry.text_submitted.emit(%NameEntry.text))
	%BackButton.pressed.connect(_main_menu)

func _delete_menu(index: int, save_data: Dictionary) -> void:
	var save_name = save_data["player"]["name"]
	%DeleteButton.visible = true
	%DeleteLabel.text = "Are you sure you want to delete the save '%s'?" % save_name
	%DeleteButton.pressed.connect(_delete_save.bind(index, save_data))
	_show(%DeleteSaveMenu)

func _delete_save(index: int, save_data: Dictionary) -> void:
	if !SaveHandler.validate_save(save_data["player"]["name"]):
		Debug.log_error(Enums.ErrorKey.SAVE_MISSING)
		return
	if SaveHandler.delete_save(save_data):
		%ItemList.remove_item(index)
		%DeleteLabel.text = "Save deleted"
		%DeleteButton.visible = false
		if %DeleteButton.pressed.is_connected(_delete_save):
			%DeleteButton.pressed.disconnect(_delete_save)

func _load_game() -> void:
	%LoadSaveButton.disabled = true
	%DeleteSaveButton.disabled = true
	_show(%LoadGameMenu)
	if SaveHandler.save_list.size() == 0:
		%LoadGameLabel.text = "No saves."
		%LoadSaveButton.disabled = true
	else:
		%LoadGameLabel.text = "Current saves:"
		%ItemList.clear()
		for save in SaveHandler.save_list:
			save_index[save] = %ItemList.add_item(save["player"]["name"])
			%ItemList.set_item_tooltip_enabled(save_index[save], false)
		if !%ItemList.item_selected.is_connected(_save_row_selected):
			%ItemList.item_selected.connect(_save_row_selected)

func _load_save(_save_data: Dictionary) -> void:
	SaveHandler.load_save(_save_data)
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
	var new_save = SaveHandler.create_new_save(_name)
	print(new_save)
	if new_save != {}:
		Signals.GAME_save_created.emit()
		SaveHandler.load_save(new_save)
		visible = false
	
func _save_row_selected(index: int) -> void:
	var selected_save = save_index.find_key(index)
	if %LoadSaveButton.pressed.is_connected(_load_save):
		%LoadSaveButton.pressed.disconnect(_load_save)
	%LoadSaveButton.disabled = false
	if %DeleteSaveButton.pressed.is_connected(_delete_menu):
		%DeleteSaveButton.pressed.disconnect(_delete_menu)
	%DeleteSaveButton.disabled = false
	%LoadSaveButton.pressed.connect(_load_save.bind(selected_save))
	%DeleteSaveButton.pressed.connect(_delete_menu.bind(index, selected_save))

func _show(menu: Node) -> void:
	visible = true
	for child in get_children():
		child.visible = false
	if menu != %MainMenu:
		%BackButtonNode.visible = true
	else:
		%BackButtonNode.visible = false
	menu.visible = true
