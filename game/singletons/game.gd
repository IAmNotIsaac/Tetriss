extends Node


signal tick

enum Tetrominos { I, J, L, O, S, Z, T }

const tetromino_data = {
	Tetrominos.I: {
		"scene": preload("res://objects/tetrominos/I.tscn")
	},
	
	Tetrominos.J: {
		"scene": preload("res://objects/tetrominos/J.tscn")
	},
	
	Tetrominos.L: {
		"scene": preload("res://objects/tetrominos/L.tscn")
	},
	
	Tetrominos.O: {
		"scene": preload("res://objects/tetrominos/O.tscn")
	},
	
	Tetrominos.S: {
		"scene": preload("res://objects/tetrominos/S.tscn")
	},
	
	Tetrominos.Z: {
		"scene": preload("res://objects/tetrominos/Z.tscn")
	},
	
	Tetrominos.T: {
		"scene": preload("res://objects/tetrominos/T.tscn")
	}
}

const ROTATION_SNAP := 90
const BLOCK_SIZE := Vector2(20, 20)
const MAP_EXTENTS := Vector2(5 * BLOCK_SIZE.x, 10 * BLOCK_SIZE.y)

var ticks := 0


func _on_TickTimer_timeout() -> void:
	ticks += 1
	emit_signal("tick")
