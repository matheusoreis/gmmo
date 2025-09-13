extends Node

@export var server: Server
@export var database: Database


func _enter_tree() -> void:
	if not server:
		return

	server.register_handlers([
		[Packets.SIGN_IN, _handle_sign_in]
	])


func _handle_sign_in(peer: ENetPacketPeer, data: Dictionary) -> void:
	var identifier: String = data.get("identifier", "")
	var password: String = data.get("password", "")
	
	var account: Entity.Account = await database.account_repository.get_by_username_or_email(identifier)
	if account == null:
		server.send_to(peer, {
			"id": Packets.SIGN_IN,
			"args": {
				"success": false,
				"error": "Usuário não encontrado"
			}
		})
		return

	if not Hash.verify(password, account.password):
		server.send_to(peer, {
			"id": Packets.SIGN_IN,
			"args": {
				"success": false,
				"error": "Senha incorreta"
			}
		})
		return

	server.send_to(peer, {
		"id": Packets.SIGN_IN,
		"args": {
			"success": true,
			"message": "Seja bem-vindo, %s!" % account.username,
		}
	})
