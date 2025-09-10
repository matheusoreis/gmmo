class_name Server
extends Node


@export_group("Settings")
@export var port: int = 7001
@export var max_clients: int = 100

@export_group("Módulos")
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

	server.client_connected.connect(_on_client_connected)
	server.client_disconnected.connect(_on_client_disconnected)

	var err := server.start_server(port, max_clients)
	if err == OK:
		print("[SERVER] Rodando na porta %d, até %d clientes" % [port, max_clients])


func _process(_delta: float) -> void:
	if server:
		server.process()


func _on_client_connected(peer: ENetPacketPeer) -> void:
	print("[SERVER] Cliente conectado:", peer.get_instance_id())


func _on_client_disconnected(peer: ENetPacketPeer) -> void:
	print("[SERVER] Cliente desconectado:", peer.get_instance_id())

	account_module.remove_account(peer)


func register_handlers(handlers: Array) -> void:
	if server:
		server.register_handlers(handlers)


func send_to(peer: ENetPacketPeer, packet: Dictionary) -> void:
	if server:
		server.send_to(peer, packet)


func send_to_all(packet: Dictionary) -> void:
	if server:
		server.send_to_all(packet)


func send_to_all_but(exclude: ENetPacketPeer, packet: Dictionary) -> void:
	if server:
		server.send_to_all_but(exclude, packet)


func send_to_list(peers: Array, packet: Dictionary) -> void:
	if server:
		server.send_to_list(peers, packet)
