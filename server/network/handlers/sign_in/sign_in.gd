extends Node


@export var server: Server


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.SIGN_IN, _handle_sign_in]
	])


func _handle_sign_in(peer: ENetPacketPeer, data: Dictionary) -> void:
	pass
