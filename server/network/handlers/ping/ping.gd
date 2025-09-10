extends Node


@export var server: Server


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.PING, _handle_ping]
	])


func _handle_ping(peer: ENetPacketPeer, _data: Dictionary) -> void:
	print("Recebendo ping de cliente %d!" % peer.get_instance_id())
