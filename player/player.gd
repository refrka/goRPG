extends Node

var data: Dictionary

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	Signals.GAME_save_loaded.connect(_load_player_instance)
	Signals.GAME_quit.connect(_clear_player_instance)

func _clear_player_instance() -> void:
	pass

func _load_player_instance(_data: Dictionary) -> void:
	data = _data
	var count = 0
	if _data["player"].has("load_count"):
		count = _data["player"]["load_count"]
	SaveHandler.save_value("player", "load_count", count + 1)
	for item_type in data["inventory"]:
		print("type: %s" % item_type)
		for item in data["inventory"][item_type]:
			print("item: %s" % item)