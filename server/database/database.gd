class_name Database
extends Node


var database: Aslet


func _ready() -> void:
	database = Aslet.open("server/database/database.db")
	database.exec('PRAGMA foreign_keys = ON;', [])
	database.exec('PRAGMA journal_mode = WAL;', [])


func _process(_delta: float) -> void:
	database.poll(1)


#region Account
func get_account_by_id(id: int) -> Array:
	var sql = "SELECT id, username, email, password, max_ctors, created_at, updated_at FROM accounts WHERE id = ?1"
	var result = await database.fetch(sql, [id]).completed as Array
	
	if result[0] == OK:
		return result[1]
	
	return []


func get_account_by_email(email: String) -> Array:
	var sql = "SELECT id, username, email, password, max_ctors, created_at, updated_at FROM accounts WHERE email = ?1"
	var result = await database.fetch(sql, [email]).completed as Array
	
	if result[0] == OK:
		return result[1]
	
	return []


func get_account_by_username_or_email(identifier: String) -> Array:
	var sql = "SELECT id, username, email, password, max_actors, created_at, updated_at FROM accounts WHERE username = ?1 OR email = ?1"
	var result = await database.fetch(sql, [identifier]).completed as Array

	if result[0] == OK:
		return result[1]
	
	return []


func get_all_accounts() -> Array:
	var sql = "SELECT id, username, email, max_ctors, created_at, updated_at FROM accounts"
	var result = await database.fetch(sql, []).completed as Array
	
	if result[0] == OK:
		return result[1]
	
	return []


func create_account(username: String, email: String, password: String) -> bool:
	var sql = "INSERT INTO accounts (username, email, password, created_at, updated_at) \
	           VALUES (?1, ?2, ?3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
	var result = await database.exec(sql, [username, email, password]).completed as Array

	if result[0] == OK:
		return result[1] > 0
	
	return false

#endregion
