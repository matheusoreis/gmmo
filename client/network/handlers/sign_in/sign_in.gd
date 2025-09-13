extends Node


@export var client: Client


func _enter_tree() -> void:
	if not client:
		return

	client.register_handlers([
		[Packets.SIGN_IN, _handle],
	])


func _handle(data: Dictionary) -> void:
	print(data)
