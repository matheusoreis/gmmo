extends Node


@export var server: Server


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.SIGN_UP, _handle_sign_up]
	])


func _handle_sign_up(peer: ENetPacketPeer, data: Dictionary) -> void:
	pass
