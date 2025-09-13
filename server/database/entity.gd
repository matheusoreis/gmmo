class_name Entity
extends RefCounted


class Account extends Entity:
	var id: int
	var username: String
	var email: String
	var password: String
	var max_actors: int
	var created_at: String
	var updated_at: String


func _init(row: Array):
	var props := []
	var meta_props := get_property_list()
	for prop in meta_props:
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			props.push_back(prop.name)

	assert(props.size() == row.size())
	for i in props.size():
		set(props[i], row[i])
