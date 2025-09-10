class_name ENetServer
extends Node


signal client_connected(peer: ENetPacketPeer)
signal client_disconnected(peer: ENetPacketPeer)


var _host: ENetConnection
var _handlers: Dictionary = {}
var _peers: Array[ENetPacketPeer] = []


func start_server(port: int, max_clients: int = 32) -> Error:
	_host = ENetConnection.new()
	var err := _host.create_host_bound("0.0.0.0", port, max_clients)
	if err != OK:
		print("[SERVER] Erro ao iniciar servidor na porta %d" % port)
		return err

	print("[SERVER] Servidor iniciado na porta %d" % port)
	return OK


func process() -> void:
	if _host == null:
		return

	var event := _host.service()
	if event.is_empty():
		return

	match event[0]:
		ENetConnection.EventType.EVENT_CONNECT:
			_handle_connect(event[1])
		ENetConnection.EventType.EVENT_DISCONNECT:
			_handle_disconnect(event[1])
		ENetConnection.EventType.EVENT_RECEIVE:
			_handle_packet(event[1])
		ENetConnection.EventType.EVENT_ERROR:
			print("[SERVER] Erro de rede no servidor")


func register_handlers(handlers: Array) -> void:
	for info in handlers:
		var packet_id: int = info[0]
		var callable: Callable = info[1] as Callable
		if callable.is_valid():
			_handlers[packet_id] = callable


func _handle_connect(peer: ENetPacketPeer) -> void:
	_peers.append(peer)
	client_connected.emit(peer)


func _handle_disconnect(peer: ENetPacketPeer) -> void:
	_peers.erase(peer)
	client_disconnected.emit(peer)


func _handle_packet(peer: ENetPacketPeer) -> void:
	var packet_data := peer.get_packet()
	if packet_data.is_empty():
		return

	var json_str := packet_data.get_string_from_utf8()
	if json_str.is_empty():
		_handle_disconnect(peer)
		return

	var result = JSON.parse_string(json_str)
	if result == null or typeof(result) != TYPE_DICTIONARY:
		print("[SERVER] Pacote inválido de peer %s" % [str(peer)])
		_handle_disconnect(peer)
		return

	if not result.has("id"):
		print("[SERVER] Pacote sem ID de peer %s" % [str(peer)])
		return

	var packet_id: int = int(result["id"])
	if packet_id < 0:
		print("[SERVER] Pacote com ID inválido de peer %s" % [str(peer)])
		return

	if not result.has("args"):
		print("[SERVER] Pacote sem argumentos de peer %s" % [str(peer)])
		return

	var args: Variant = result["args"]
	if typeof(args) != TYPE_DICTIONARY:
		print("[SERVER] Pacote com argumentos inválidos de peer %s" % [str(peer)])
		return

	if not _handlers.has(packet_id):
		print("[SERVER] Nenhum handler registrado para pacote %d" % packet_id)
		return

	var handler: Callable = _handlers[packet_id]
	if not handler.is_valid():
		print("[SERVER] Handler inválido para pacote %d" % packet_id)
		return

	handler.call(peer, args)


func _send(filter: Callable, packet: Dictionary) -> void:
	var json := JSON.stringify(packet)
	if json.is_empty():
		return

	for peer in _peers:
		if not filter.call(peer):
			continue
		if peer.get_state() != ENetPacketPeer.STATE_CONNECTED:
			continue

		peer.send(0, json.to_utf8_buffer(), ENetPacketPeer.FLAG_RELIABLE)


func send_to(peer: ENetPacketPeer, packet: Dictionary) -> void:
	_send(func(p): return p == peer, packet)


func send_to_all(packet: Dictionary) -> void:
	_send(func(_p): return true, packet)


func send_to_all_but(exclude: ENetPacketPeer, packet: Dictionary) -> void:
	_send(func(p): return p != exclude, packet)


func send_to_list(peers: Array[ENetPacketPeer], packet: Dictionary) -> void:
	_send(func(p): return peers.has(p), packet)
