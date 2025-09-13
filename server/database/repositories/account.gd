class_name AccountRepository
extends Repository


func get_by_id(id: int) -> Entity.Account:
	var sql = "SELECT id, username, email, password, max_actors, created_at, updated_at \
	           FROM accounts WHERE id = ?1 LIMIT 1"
	return await one(sql, [id], Entity.Account)


func get_by_email(email: String) -> Entity.Account:
	var sql = "SELECT id, username, email, password, max_actors, created_at, updated_at \
	           FROM accounts WHERE email = ?1 LIMIT 1"
	return await one(sql, [email], Entity.Account)


func get_by_username_or_email(identifier: String) -> Entity.Account:
	var sql = "SELECT id, username, email, password, max_actors, created_at, updated_at \
	           FROM accounts WHERE username = ?1 OR email = ?1 LIMIT 1"
	return await one(sql, [identifier], Entity.Account)


func get_all() -> Array[Entity.Account]:
	var sql = "SELECT id, username, email, max_actors, created_at, updated_at FROM accounts"
	return await all(sql, [], Entity.Account)


func create(username: String, email: String, password: String) -> Error:
	var sql = "INSERT INTO accounts (username, email, password, created_at, updated_at) \
	           VALUES (?1, ?2, ?3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
	
	var result = await db.exec(sql, [username, email, password]).completed as Array
	return result[0]  # retorna OK ou outro Error
