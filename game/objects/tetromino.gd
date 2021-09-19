class_name Tetromino
extends Node2D

enum Tetrominos { I, J, L, O, S, Z, T } # have to copy enum due to weird glitch
enum CollisionTypes { NONE, WALL, GROUND }

const _NATURAL_FALL_RATE := 20
const _SLIDE_RATE := 5
const _ROTATE_RATE := 5

export(Tetrominos) var tetromino : int = 0
export(Color) var color := Color.white
export(NodePath) var board_path

var _blocks := []
var _queued_slide_direction := Vector2.ZERO
var _queued_rotate_degrees := 0.0

onready var _board := get_node_or_null(board_path)


func _ready() -> void:
	Game.connect("tick", self, "_tick_update")
	
	_construct()


func _tick_update() -> void:
	_rotate()
	_slide()
	_gravity()


func _slide() -> void:
	if not _queued_slide_direction:
		_queued_slide_direction = Vector2(int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")), 0)
	
	if not Game.ticks % _SLIDE_RATE:
		_move(_queued_slide_direction)
		_queued_slide_direction = Vector2.ZERO


func _rotate() -> void:
	if not _queued_rotate_degrees:
		_queued_rotate_degrees = (int(Input.is_action_pressed("rotate_cw")) - int(Input.is_action_pressed("rotate_ccw"))) * Game.ROTATION_SNAP
	
	if not Game.ticks % _ROTATE_RATE:
		rotation_degrees = wrapi(rotation_degrees + _queued_rotate_degrees, 0, 360)
		_queued_rotate_degrees = 0.0
		
		for block in _blocks:
			block.rotation_degrees = wrapi(360 - rotation_degrees, 0, 360)
		
		_fix_position()


func _gravity() -> void:
	if not Game.ticks % _NATURAL_FALL_RATE:
		_move(Vector2(0, 1))


func _pin() -> void:
	if _board:
		for block in _blocks:
			remove_child(block)
			_board.add_child(block)
		
	queue_free()


func _construct() -> void:
	_blocks = TetrominoConstructor.construct(tetromino)
	
	for block in _blocks:
		block.modulate = color
		
		add_child(block)


func _move(direction : Vector2, ignore_collision := false) -> void:
	var offset : Vector2 = position + direction * Game.BLOCK_SIZE * 2
	
	if not ignore_collision:
		for block in _blocks:
			var collision := _collision_test(block.global_position + Game.BLOCK_SIZE * direction)
			
			match collision:
				CollisionTypes.NONE: pass
				CollisionTypes.WALL: return
				CollisionTypes.GROUND:
					_pin()
					return
	
	position = offset


func _collision_test(collision_check_pos : Vector2) -> int:
	if collision_check_pos.x > (Game.MAP_EXTENTS.x * 2) - Game.BLOCK_SIZE.x or collision_check_pos.x < -(Game.MAP_EXTENTS.x * 2) + Game.BLOCK_SIZE.x:
		return CollisionTypes.WALL
	
	if collision_check_pos.y > (Game.MAP_EXTENTS.y * 2) - Game.BLOCK_SIZE.y:
		return CollisionTypes.GROUND
	
	return CollisionTypes.NONE


func _fix_position() -> void:
	for block in _blocks:
		var collision := _collision_test(block.global_position)
		
		match collision:
			CollisionTypes.NONE: pass
			CollisionTypes.WALL:
				var x_direction := -1 if block.global_position.x > 0 else 1
				
				_move(Vector2(x_direction, 0), true)
				_fix_position()
			
			CollisionTypes.GROUND:
				_move(Vector2(0, -1), true)
				_fix_position()
