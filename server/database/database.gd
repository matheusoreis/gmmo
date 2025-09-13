class_name Database
extends Node


var aslet: Aslet
var account_repository: AccountRepository


func _ready() -> void:
	aslet = Aslet.open("server/database/database.db")
	aslet.exec('PRAGMA foreign_keys = ON;', [])
	aslet.exec('PRAGMA journal_mode = WAL;', [])
	
	account_repository = AccountRepository.new(aslet)


func _process(_delta: float) -> void:
	aslet.poll(1)
