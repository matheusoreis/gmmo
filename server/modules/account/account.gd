class_name AccountModule
extends Node


var _accounts: Dictionary = {}


func set_account(peer: ENetPacketPeer, account: Dictionary) -> void:
	_accounts[peer] = account


func get_account(peer: ENetPacketPeer) -> Dictionary:
	return _accounts.get(peer, {})


func get_all_accounts() -> Array:
	return _accounts.values()


func remove_account(peer: ENetPacketPeer) -> void:
	_accounts.erase(peer)


func patch_account(peer: ENetPacketPeer, data: Dictionary) -> Dictionary:
	if not _accounts.has(peer):
		return {}

	var account: Dictionary = _accounts[peer]
	account.merge(data, true)
	account["updated_at"] = Time.get_datetime_dict_from_system()
	_accounts[peer] = account
	return account
