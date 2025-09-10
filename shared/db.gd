extends Node


var accounts: Dictionary = {}
var actors: Dictionary = {}
var maps: Dictionary = {}

var _account_auto_id: int = 1
var _actor_auto_id: int = 1
var _map_auto_id: int = 1


#region Accounts
func insert_account(data: Dictionary) -> int:
	var id = _account_auto_id
	_account_auto_id += 1

	data["id"] = id
	data["created_at"] = Time.get_datetime_dict_from_system()

	accounts[id] = data

	return id


func get_account(id: int) -> Dictionary:
	return accounts.get(id, {})


func update_account(id: int, patch: Dictionary) -> void:
	if not accounts.has(id):
		return

	accounts[id].merge(patch, true)
	accounts[id]["updated_at"] = Time.get_datetime_dict_from_system()


func delete_account(id: int) -> void:
	accounts.erase(id)


func select_all_accounts() -> Array:
	return accounts.values()
#endregion

#region Actors
func insert_actor(data: Dictionary) -> int:
	var id = _actor_auto_id
	_actor_auto_id += 1

	data["id"] = id
	data["created_at"] = Time.get_datetime_dict_from_system()

	actors[id] = data

	return id


func get_actor(id: int) -> Dictionary:
	return actors.get(id, {})


func update_actor(id: int, patch: Dictionary) -> void:
	if not actors.has(id):
		return

	actors[id].merge(patch, true)
	actors[id]["updated_at"] = Time.get_datetime_dict_from_system()


func delete_actor(id: int) -> void:
	actors.erase(id)


func select_actors_by_map(map_id: int) -> Array:
	var result: Array = []

	for actor in actors.values():
		if actor.get("map_id", -1) == map_id:
			result.append(actor)

	return result
#endregion

#region Maps
func insert_map(data: Dictionary) -> int:
	var id = _map_auto_id
	_map_auto_id += 1

	data["id"] = id

	maps[id] = data

	return id


func get_map(id: int) -> Dictionary:
	return maps.get(id, {})


func select_all_maps() -> Array:
	return maps.values()
#endregion
