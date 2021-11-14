extends Spatial

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {
	Vector2(0, -1): N, 
	Vector2(1, 0): E,
	Vector2(0, 1): S, 
	Vector2(-1, 0): W
}

var map = []

var tiles = [
	preload("res://Maze/Tile0.tscn")
	,preload("res://Maze/Tile1.tscn")
	,preload("res://Maze/Tile2.tscn")
	,preload("res://Maze/Tile3.tscn")
	,preload("res://Maze/Tile4.tscn")
	,preload("res://Maze/Tile5.tscn")
	,preload("res://Maze/Tile6.tscn")
	,preload("res://Maze/Tile7.tscn")
	,preload("res://Maze/Tile8.tscn")
	,preload("res://Maze/Tile9.tscn")
	,preload("res://Maze/Tile10.tscn")
	,preload("res://Maze/Tile11.tscn")
	,preload("res://Maze/Tile12.tscn")
	,preload("res://Maze/Tile13.tscn")
	,preload("res://Maze/Tile14.tscn")
	,preload("res://Maze/Tile15.tscn")
]

var tile = 2
var tile_size = 2
var width = 40  # width of map (in tiles)
var height = 20 # height of map (in tiles)
var mini_tile = 64

onready var Key = preload("res://Key/keycard.tscn")
onready var Exit = preload("res://Exit/Exit.tscn")

func _ready():
	randomize()
	make_maze()
	var key = Key.instance()
	key.translate(Vector3((width*tile)-1.5,1,0.5))
	add_child(key)
	var exit = Exit.instance()
	exit.translate(Vector3((width*tile)-1.5,0.1,height*tile-1.5))
	add_child(exit)
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	for x in range(width):
		for z in range(height):
			var t = tiles[map[x][z]].instance()
			t.translation = Vector3(x*tile_size,0,z*tile_size)
			t.name = "Tile_" + str(x) + "_" + str(z)
			add_child(t)
