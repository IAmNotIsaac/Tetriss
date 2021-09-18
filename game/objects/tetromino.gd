class_name Tetromino
extends Node2D

enum Tetrominos { I, J, L, O, S, Z, T } # have to copy enum due to weird glitch
enum CollisionTypes { NONE, WALL, LAND }

export(Tetrominos) var tetromino : int = 0
export(Color) var color := Color.white
export(NodePath) var board_path

var _blocks := []

onready var _board := get_node_or_null(board_path)


func _ready() -> void:
	_construct()


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("rotate_cw"):
		_rotate(Game.ROTATION_SNAP)
	elif event.is_action_pressed("rotate_ccw"):
		_rotate(-Game.ROTATION_SNAP)
	elif event.is_action_pressed("move_left"):
		_move(Vector2(-1, 0))
	elif event.is_action_pressed("move_right"):
		_move(Vector2(1, 0))
	elif event.is_action_pressed("move_down"):
		_move(Vector2(0, 1))
	elif event.is_action_pressed("reserve"):
		_move(Vector2(0, -1))
	elif event.is_action_pressed("ui_accept"):
		_collision_test(_blocks[0].position + Vector2(40, 0))


func _pin() -> void:
	if _board:
		if _blocks:
			for block in _blocks:
				remove_child(block)
				_board.add_child(block)
		
		queue_free()


func _construct() -> void:
	_blocks = TetrominoConstructor.construct(tetromino)
	
	for block in _blocks:
		block.modulate = color
		
		add_child(block)


func _rotate(degrees : int) -> void:
	rotation_degrees += degrees
	
	if _blocks:
		for block in _blocks:
			block.rotation_degrees = wrapi(360 - rotation_degrees, 0, 360)


func _move(direction : Vector2) -> void:
	if _blocks:
		var offset : Vector2 = position + direction * Game.BLOCK_SIZE * 2
		
		for block in _blocks:
			var collision = _collision_test(block.global_position + Game.BLOCK_SIZE * direction)
			
			match collision:
				CollisionTypes.NONE: pass
				CollisionTypes.WALL: return
				CollisionTypes.LAND:
					_pin()
					return
		
		position = offset


func _collision_test(collision_check_pos : Vector2) -> int:
	if collision_check_pos.x > (Game.MAP_EXTENTS.x * 2) - Game.BLOCK_SIZE.x or collision_check_pos.x < -(Game.MAP_EXTENTS.x * 2) + Game.BLOCK_SIZE.x:
		return CollisionTypes.WALL
	
	if collision_check_pos.y > (Game.MAP_EXTENTS.y * 2) - Game.BLOCK_SIZE.y:
		return CollisionTypes.LAND
	
	return CollisionTypes.NONE
