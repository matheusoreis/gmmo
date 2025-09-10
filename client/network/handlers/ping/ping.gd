extends Node


@export var client: Client


func _enter_tree() -> void:
	if not client:
		return

	client.register_handlers([
		[Packets.PING, _handle_ping]
	])


func _handle_ping(_data: Dictionary) -> void:
	print("Recebendo ping de servidor!")
