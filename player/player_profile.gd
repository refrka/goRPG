extends Control

func _ready() -> void:
	var player_name = SaveHandler.active_save["player"]["name"]
	var load_count = SaveHandler.active_save["player"]["load_count"]
	%PlayerNameLabel.text = player_name
	%PlayCountLabel.text = "Loads: %s" % int(load_count)
	%CloseProfileButton.pressed.connect(_close_profile)
	for item in 

func _close_profile() -> void:
	Signals.PLAYER_profile_closed.emit()
	queue_free()