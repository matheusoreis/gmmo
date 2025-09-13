class_name Repository
extends RefCounted


var db: Aslet


func _init(_db: Aslet):
	db = _db


func all(query: String, args: Array, ty: GDScript) -> Array:
	var result := await db.fetch(query, args).completed as Array
	if result[0] != OK:
		return []

	var rows := []
	for row in result[1]:
		rows.push_back(ty.new(row))
	return rows


func one(query: String, args: Array, ty: GDScript = null) -> Variant:
	var result := await db.fetch(query, args).completed as Array
	if result[0] != OK || result[1].size() == 0:
		return null
	return result[1][0][0] if ty == null else ty.new(result[1][0])


func one_or(query: String, args: Array, default: Variant, ty: GDScript = null) -> Variant:
	var result := await db.fetch(query, args).completed as Array
	if result[0] != OK || result[1].size() == 0:
		return default

	if ty != null:
		return ty.new(result[1][0])
	else:
		return result[1][0][0]
