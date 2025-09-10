class_name MapModule
extends Node

signal map_added(map_id: int, map: Dictionary)
signal map_removed(map_id: int, map: Dictionary)
signal map_updated(map_id: int, map: Dictionary)

var _maps: Dictionary = {} # map_id -> Dictionary com dados do mapa


func set_map(map_id: int, map: Dictionary) -> void:
	_maps[map_id] = map
	map_added.emit(map_id, map)


func get_map(map_id: int) -> Dictionary:
	return _maps.get(map_id, {})


func get_all_maps() -> Array:
	return _maps.values()


func remove_map(map_id: int) -> void:
	if not _maps.has(map_id):
		return

	var map = _maps[map_id]
	_maps.erase(map_id)

	map_removed.emit(map_id, map)


func patch_map(map_id: int, data: Dictionary) -> void:
	if not _maps.has(map_id):
		return

	var map = _maps[map_id]
	map.merge(data, true)
	map["updatedAt"] = Time.get_datetime_dict_from_system()

	_maps[map_id] = map

	map_updated.emit(map_id, map)
