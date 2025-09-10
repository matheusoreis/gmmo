extends Node


@export var client: Client


func _enter_tree() -> void:
	if not client:
		return

	client.register_handlers([
		[Packets.SIGN_UP, _handle_sign_up],
	])


func _handle_sign_up(data: Dictionary) -> void:
	if data.get("success", false):
		print("[CLIENT] Cadastro realizado com sucesso!")
		var account = data.get("account", {})
		print("ID:", account.get("id", -1))
		print("Username:", account.get("username", ""))
	else:
		print("[CLIENT] Falha no cadastro:", data.get("error", "Desconhecido"))
