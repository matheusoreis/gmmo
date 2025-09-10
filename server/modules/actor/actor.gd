class_name ActorModule
extends Node


signal actor_added(peer: ENetPacketPeer, actor: Dictionary)
signal actor_removed(peer: ENetPacketPeer, actor: Dictionary)
signal actor_updated(peer: ENetPacketPeer, actor: Dictionary)


var _actors: Dictionary = {}


func set_actor(peer: ENetPacketPeer, actor: Dictionary) -> void:
	_actors[peer] = actor

	actor_added.emit(peer, actor)


func get_actor(peer: ENetPacketPeer) -> Dictionary:
	return _actors.get(peer, {})


func get_all_actors() -> Array:
	return _actors.values()


func remove_actor(peer: ENetPacketPeer) -> void:
	if not _actors.has(peer):
		return

	var actor = _actors[peer]
	_actors.erase(peer)

	actor_removed.emit(peer, actor)


func patch_actor(peer: ENetPacketPeer, data: Dictionary) -> void:
	if not _actors.has(peer):
		return

	var actor = _actors[peer]
	actor.merge(data, true)
	actor["updatedAt"] = Time.get_datetime_dict_from_system()

	_actors[peer] = actor

	actor_updated.emit(peer, actor)
