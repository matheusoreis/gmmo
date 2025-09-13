class_name Database
extends Node


var database: Aslet


func _enter_tree() -> void:
	database = Aslet.open("server/database/database.db")
