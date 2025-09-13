class_name Hash
extends Node


static func make(password: String) -> String:
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hash_bytes: PackedByteArray = ctx.finish()
	return hash_bytes.hex_encode()


static func verify(password: String, hashed: String) -> bool:
	return make(password) == hashed
