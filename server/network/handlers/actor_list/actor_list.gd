extends Node


@export var server: Server
@export var account_module: AccountModule
@export var packet_id: int


func _enter_tree() -> void:
	if not server:
		return
		
	if not account_module:
		return

	server.register_handlers([
		[packet_id, _handle_actor_list],
	])


func _handle_actor_list(peer: ENetPacketPeer, _data: Dictionary) -> void:
	pass
