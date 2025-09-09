class_name Server
extends Node


@export_group("Settings")
@export var port: int = 7001
@export var max_clients: int = 100

@export_group("Modules")
@export var client_module: ClientModule
@export var account_module: AccountModule
@export var actor_module: ActorModule
@export var map_module: MapModule


var server: ENetServer


func _enter_tree() -> void:
	if server:
		return

	server = ENetServer.new()


func _ready() -> void:
	if not server:
		return

	server.client_connected.connect(
		_on_client_connected
	)

	server.client_disconnected.connect(
		_on_client_disconnected
	)

	var err := server.start_server(port, max_clients)
	if err == OK:
		print("[SERVER] Rodando na porta %d, até %d clientes" % [port, max_clients])


func _on_client_connected(peer: ENetPacketPeer) -> void:
	if client_module:
		client_module.add_client(peer)


func _on_client_disconnected(peer: ENetPacketPeer) -> void:
	if client_module:
		client_module.remove_client(peer)


func _process(_delta: float) -> void:
	if not server:
		return

	server.process()


func register_handlers(handlers: Array) -> void:
	if not server:
		return

	server.register_handlers(handlers)
