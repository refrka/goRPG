extends Node

const ErrorKey = Enums.ErrorKey

var error_log:= []
var error_messages = load("res://utility/debug/error_messages.gd").new()

class Error:
	var error_type: ErrorKey
	var error_msg: String
	func _init(_type: ErrorKey, _msg: String):
		error_type = _type
		error_msg = _msg
		Signals.DEBUG_error_generated.emit(self)

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	Signals.DEBUG_print_errors.connect(print_error_log)

func check_log(_type: ErrorKey) -> bool:
	for error in error_log:
		if error.error_type == _type:
			return true
	return false

func log_error(_type: ErrorKey) -> void:
	var _msg = error_messages.msg[_type]
	var error = Error.new(_type, _msg)
	error_log.append(error)

func print_error_log() -> void:
	var lines = []
	lines.append("=====")
	if error_log.size() == 0:
		lines.append("No Logged Errors")
		lines.append("=====")
	else:
		lines.append("Debug Error Log (Errors logged: %s)" % str(error_log.size()))
		lines.append("=====")
		for error in error_log:
			var index = error_log.find(error)
			lines.append("[%s] ErrorKey %s: %s" % [index, error.error_type, error.error_msg])
	for line in lines:
		print(line)