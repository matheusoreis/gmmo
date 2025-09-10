extends Node


@export var server: Server


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.SIGN_UP, _handle_sign_up]
	])


func _handle_sign_up(peer: ENetPacketPeer, data: Dictionary) -> void:
	var username: String = data.get("username", "")
	var password: String = data.get("password", "")
	var re_password: String = data.get("re_password", "")

	if username.is_empty() or password.is_empty():
		server.send_to(peer, {
			"id": Packets.SIGN_UP,
			"args": {
				"success": false,
				"error": "Username and password are required"
			}
		})
		return

	if password != re_password:
		server.send_to(peer, {
			"id": Packets.SIGN_UP,
			"args": {
				"success": false,
				"error": "Passwords do not match"
			}
		})
		return

	for acc in Database.select_all_accounts():
		if acc["username"] == username:
			server.send_to(peer, {
				"id": Packets.SIGN_UP,
				"args": {
					"success": false,
					"error": "Username already exists"
				}
			})
			return

	var new_account = {
		"username": username,
		"password": password,
	}
	var new_id = Database.insert_account(new_account)

	var account = Database.get_account(new_id)

	server.send_to(peer, {
		"id": Packets.SIGN_UP,
		"args": {
			"success": true,
			"account": {
				"id": account["id"],
				"username": account["username"]
			}
		}
	})
