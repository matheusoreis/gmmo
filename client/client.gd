class_name Client
extends Node


@export_group("Settings")
@export var host: String = "127.0.0.1"
@export var port: int = 7001


var client: ENetClient


func _enter_tree() -> void:
	if client:
		return

	client = ENetClient.new()


func _ready() -> void:
	if not client:
		return

	var err := client.start_client(host, port)
	if err == OK:
		print("[CLIENT] Conectando a %s:%d" % [host, port])
	else:
		print("[CLIENT] Falha ao iniciar conexão (err=%d)" % err)


func _process(_delta: float) -> void:
	if not client:
		return

	client.process()


func register_handlers(handlers: Array) -> void:
	if not client:
		return

	client.register_handlers(handlers)


func send(packet_id: int, args: Dictionary, channel: int = 0) -> void:
	if not client:
		return

	client.send(packet_id, args, channel)


func disconnect_from_server() -> void:
	if not client:
		return

	client.disconnect_from_server()


func _on_button_pressed() -> void:
	send(Packets.PING, {})
