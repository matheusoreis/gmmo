class_name ClientModule
extends Node


var clients: Dictionary = {}
var _next_id: int = 1


func add_client(peer: ENetPacketPeer) -> int:
	var id: int = _next_id
	_next_id += 1

	clients[id] = {
		"id": id,
		"peer": peer
	}

	return id


func remove_client(peer: ENetPacketPeer) -> int:
	var id := find_client_id(peer)
	if id != -1:
		clients.erase(id)

	return id


func find_client_id(peer: ENetPacketPeer) -> int:
	for id in clients.keys():
		if clients[id]["peer"] == peer:
			return id

	return -1


func get_client(id: int) -> Dictionary:
	return clients.get(id, {})


func get_all_clients() -> Array:
	return clients.values()


func is_client_connected(id: int) -> bool:
	if not clients.has(id):
		return false

	var peer: ENetPacketPeer = clients[id]["peer"]
	return peer.get_state() == ENetPacketPeer.STATE_CONNECTED
