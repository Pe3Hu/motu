extends Spatial


var TILES = {} 

var size := 1
var w := sqrt(3) * size
var h := 2 * size
var n = 13
var tiles = []
var center = {}
var neighbours = []
var half

func _ready():
	set_tiles() 
	set_neighbours()
	generate_hexs()
	
	var camera = get_node("/root/main/camera")
	var x = tiles[center.vec.z][center.vec.x].vec.x
	var y = 20
	var z = tiles[center.vec.z][center.vec.x].vec.z
	camera.translation = Vector3( x, y, z )

func set_tiles():
	half = floor(n/2)
	center.vec = Vector3( half, 0, half )

func set_neighbours():
	neighbours =  [
		[
			Vector3( 0, 0, -1 ),
			Vector3( 1, 0, 0 ),
			Vector3( 0, 0, 1 ),
			Vector3( -1, 0, 1 ),
			Vector3( -1, 0, 0 ),
			Vector3( -1, 0, -1 ),
		],
		[
			Vector3( 1, 0, -1 ),
			Vector3( 1, 0, 0 ),
			Vector3( 1, 0, 1 ),
			Vector3( 0, 0, 1 ),
			Vector3( -1, 0, 0 ),
			Vector3( 0, 0, -1 ),
		]
	]

func generate_hexs():
	for _z in n:
		tiles.append([])
		
		for _x in n:
			var vec = Vector3( h * _x, 0, w * _z )
			
			if _z % 2 == 1:
				vec.x += 0.5*w*1.155
			
			var tile = Global.Tile.new()
			tile.grid = Vector3( _x, 0, _z)
			tile.index = convert_grid(tile.grid)
			tile.vec = vec
			tiles[_z].append(tile)
	
	tiles_around_center()
	
	for tiles_ in tiles:
		for tile_ in tiles_:
			choose_hex(tile_)
	
func choose_hex(tile):
	if tile.visiable:
		var hex_name = "rock"
		
		match tile.ring:
			0:	
				hex_name = "water"
			1:	
				hex_name = "sand"
			2:	
				hex_name = "forest"
		
		var path = "res://assets/dae/hex_"+hex_name+"_detail.dae"
		tile.node = load(path).instance()
		tile.node.global_transform.origin = tile.vec
		add_child(tile.node)

func tiles_around_center():
	var around = half
	var indexs = []
	indexs.append(tiles[center.vec.z][center.vec.x].index);
	var tile = tiles[center.vec.z][center.vec.x]
	set_ring(tile, 0)
	
	for _i in half:
		var _j = indexs.size() - 1
		
		while _j >= 0:
			var grid = convert_index(indexs[_j])
			var parity = int(grid.z)%2
			
			for _l in neighbours[parity].size():
				var grid_neighbour = neighbours[parity][_l] + grid
				
				if check_border(grid_neighbour):
					var index_add = convert_grid(grid_neighbour)
					var index_f = indexs.find(index_add)
					
					if index_f == -1:
						tile = tiles[grid_neighbour.z][grid_neighbour.x]
						set_ring(tile, _i+1)
						
						if _i < around:
							indexs.append(index_add)
				
			_j -= 1
	
	print(indexs.size())
	
	for index_ in indexs:
		var grid = convert_index(index_)
		tiles[grid.z][grid.x].visiable = true

func set_ring(tile_, ring_):
	if tile_.ring == -1:
		tile_.ring = ring_

func convert_grid(vec_):
	return int(vec_.z * n + vec_.x)

func convert_index(index_):
	var x = index_%n
	var z = floor(index_/n)
	return Vector3( x, 0, z )

func check_border(grid):
	var flag = true
	if grid.x < 0 || grid.z < 0 || grid.x > n - 1 || grid.z > n - 1:
		flag = false
	return flag;
