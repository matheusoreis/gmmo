extends Node


@export var client: Client


func _enter_tree() -> void:
	if not client:
		return

	client.register_handlers([
		[Packets.SIGN_UP, _handle],
	])


func _handle(data: Dictionary) -> void:
	var username: String = data.get("username", "")
	var email: String = data.get("email", "")
	var password: String = data.get("password", "")
