extends Node

func _input(input: InputEvent) -> void:
	if input is InputEventMouse:
		if input.is_action("mouse_left"):
			if input.is_pressed():
				Signals.INPUT_mouse_left.emit(true)
			elif input.is_released():
				Signals.INPUT_mouse_left.emit(false)
		elif input.is_action("mouse_right"):
			if input.is_pressed():
				Signals.INPUT_mouse_right.emit(true)
			elif input.is_released():
				Signals.INPUT_mouse_right.emit(false)