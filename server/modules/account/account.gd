class_name AccountModule
extends Node


signal account_added(peer: ENetPacketPeer, account: Dictionary)
signal account_removed(peer: ENetPacketPeer, account: Dictionary)
signal account_updated(peer: ENetPacketPeer, account: Dictionary)


var _accounts: Dictionary = {}


func set_account(peer: ENetPacketPeer, account: Dictionary) -> void:
	_accounts[peer] = account

	account_added.emit(peer, account)


func get_account(peer: ENetPacketPeer) -> Dictionary:
	return _accounts.get(peer, {})


func get_all_accounts() -> Array:
	return _accounts.values()


func remove_account(peer: ENetPacketPeer) -> void:
	if not _accounts.has(peer):
		return

	var account = _accounts[peer]
	_accounts.erase(peer)

	account_removed.emit(peer, account)


func patch_account(peer: ENetPacketPeer, data: Dictionary) -> void:
	if not _accounts.has(peer):
		return

	var account: Dictionary = _accounts[peer]
	account.merge(data, true)
	account["updated_at"] = Time.get_datetime_dict_from_system()

	_accounts[peer] = account

	account_updated.emit(peer, account)
