extends Node


@export var client: Client


func _enter_tree() -> void:
	if not client:
		return

	client.register_handlers([
		[Packets.SIGN_IN, _handle_sign_in],
	])


func _handle_sign_in(data: Dictionary) -> void:
	if data.get("success", false):
		print("[CLIENT] Login realizado com sucesso!")
		var account = data.get("account", {})
		print("ID:", account.get("id", -1))
		print("Username:", account.get("username", ""))
	else:
		print("[CLIENT] Falha no login:", data.get("error", "Desconhecido"))
