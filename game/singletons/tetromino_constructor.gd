extends Node


const Block := preload("res://objects/Block.tscn")

const TETROMINO_SHAPES := {
	Game.Tetrominos.I: ["#O##", "#O##", "#O##", "#O##"],
	Game.Tetrominos.J: ["O###", "OOO#", "####", "####"],
	Game.Tetrominos.L: ["####", "OOO#", "O###", "####"],
	Game.Tetrominos.O: ["####", "#OO#", "#OO#", "####"],
	Game.Tetrominos.S: ["####", "#OO#", "OO##", "####"],
	Game.Tetrominos.Z: ["####", "OO##", "#OO#", "####"],
	Game.Tetrominos.T: ["####", "OOO#", "#O##", "####"]
}


func construct(tetromino: int) -> Array:
	var blocks := []
	
	var shape_data : Array = TETROMINO_SHAPES.get(tetromino)
	
	for y in len(shape_data):
		for x in 4:
			var character : String = shape_data[y][x]
			
			if character == "O":
				var block = Block.instance()
				
				block.position = Game.BLOCK_SIZE * Vector2(x * 2, y * 2)
				block.position -= Game.BLOCK_SIZE + Game.BLOCK_SIZE * 2
				
				blocks.append(block)
			
			elif character == "#":
				continue
	
	return blocks
