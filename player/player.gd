class_name Player extends Node

var player_data = preload("res://player/player_data.gd")
var save: Resource 
var test:= "poop"

var inventory

func _init() -> void:
	_connect_signals()

func _connect_signals() -> void:
	pass