class_name ENetClient
extends Node

signal connected()
signal disconnected()

var _connection: ENetConnection
var _peer: ENetPacketPeer
var _handlers: Dictionary = {}


func start_client(host: String, port: int) -> Error:
	_connection = ENetConnection.new()
	var err := _connection.create_host()
	if err != OK:
		print("[CLIENT] Erro ao criar cliente ENet")
		return err

	_peer = _connection.connect_to_host(host, port)
	if _peer == null:
		print("[CLIENT] Não foi possível conectar ao servidor %s:%d" % [host, port])
		return FAILED

	return OK


func process() -> void:
	if _connection == null:
		return

	var event := _connection.service()
	if event.is_empty():
		return

	match event[0]:
		ENetConnection.EventType.EVENT_ERROR:
			print("[CLIENT] Erro de rede no cliente")
		ENetConnection.EventType.EVENT_CONNECT:
			print("[CLIENT] Conectado ao servidor")
			connected.emit()
		ENetConnection.EventType.EVENT_DISCONNECT:
			print("[CLIENT] Desconectado do servidor")
			disconnected.emit()
		ENetConnection.EventType.EVENT_RECEIVE:
			_handle_packet(event[1])


func register_handlers(handlers: Array) -> void:
	for info in handlers:
		var packet_id: int = info[0]
		var callable: Callable = info[1] as Callable
		if callable.is_valid():
			_handlers[packet_id] = callable


func send(packet_id: int, args: Dictionary, channel: int = 0) -> void:
	if _peer == null:
		return
	if packet_id < 0:
		return

	var payload := {"id": packet_id, "args": args}
	var json := JSON.stringify(payload)
	if json.is_empty():
		return

	_peer.send(
		channel,
		json.to_utf8_buffer(),
		ENetPacketPeer.FLAG_RELIABLE
	)


func disconnect_from_server() -> void:
	if _peer == null:
		return

	_peer.peer_disconnect_later()
	_peer = null

	disconnected.emit()


func _handle_packet(peer: ENetPacketPeer) -> void:
	var packet_data := peer.get_packet()
	if packet_data.is_empty():
		return

	var json_str := packet_data.get_string_from_utf8()
	if json_str.is_empty():
		disconnect_from_server()
		return

	var result = JSON.parse_string(json_str)
	if result == null or typeof(result) != TYPE_DICTIONARY:
		print("[CLIENT] Pacote inválido do servidor")
		disconnect_from_server()
		return

	if not result.has("id"):
		print("[CLIENT] Pacote sem ID do servidor")
		return

	var packet_id: int = int(result["id"])
	if packet_id < 0:
		print("[CLIENT] Pacote com ID inválido do servidor")
		return

	if not result.has("args"):
		print("[CLIENT] Pacote sem argumentos do servidor")
		return

	var args: Variant = result["args"]
	if typeof(args) != TYPE_DICTIONARY:
		print("[CLIENT] Pacote com argumentos inválidos do servidor")
		return

	if not _handlers.has(packet_id):
		print("[CLIENT] Nenhum handler registrado para pacote %d" % packet_id)
		return

	var handler: Callable = _handlers[packet_id]
	if not handler.is_valid():
		print("[CLIENT] Handler inválido para pacote %d" % packet_id)
		return

	handler.call(args)
