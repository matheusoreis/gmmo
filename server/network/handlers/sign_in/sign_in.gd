extends Node


@export var server: Server


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.SIGN_IN, _handle_sign_in]
	])


func _handle_sign_in(peer: ENetPacketPeer, data: Dictionary) -> void:
	var username: String = data.get("username", "")
	var password: String = data.get("password", "")

	var account = null
	for acc in Database.select_all_accounts():
		if acc["username"] == username and acc["password"] == password:
			account = acc
			break

	if account == null:
		server.send_to(peer, {
			"id": Packets.SIGN_IN,
			"args": {
				"success": false,
				"error": "Invalid username or password"
			}
		})
		return

	server.send_to(peer, {
		"id": Packets.SIGN_IN,
		"args": {
			"success": true,
			"account": {
				"id": account["id"],
				"username": account["username"],
			}
		}
	})
