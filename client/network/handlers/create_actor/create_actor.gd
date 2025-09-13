extends Node


@export var server: Server
@export var account_module: AccountModule


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.CREATE_ACTOR, _handle],
	])


func _handle(data: Dictionary) -> void:
	print(data)
