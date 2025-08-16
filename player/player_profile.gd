extends Control

func _ready() -> void:
	var player_name = SaveHandler.get_save_value("Player", "name")
	var play_count = SaveHandler.get_save_value("Save", "play_count")
	%PlayerNameLabel.text = player_name
	%PlayCountLabel.text = "Play count: %s" % play_count
	%CloseProfileButton.pressed.connect(_close_profile)

func _close_profile() -> void:
	Signals.PLAYER_profile_closed.emit()
	queue_free()