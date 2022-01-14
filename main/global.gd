extends Node


var rng = RandomNumberGenerator.new()
var main

var neighbours = [
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
	
var neighbours2 = [
		[
			Vector3( -1, 0, 0 ),
			Vector3( 0, 0, 1 ),
			Vector3( 1, 0, 0 ),
			Vector3( 1, 0, -1 ),
			Vector3( 0, 0, -1 ),
			Vector3( -1, 0, -1 )
		],
		[
			Vector3( -1, 0, 1 ),
			Vector3( 0, 0, 1 ),
			Vector3( 1, 0, 1 ),
			Vector3( 1, 0, 0 ),
			Vector3( 0, 0, -1 ),
			Vector3( -1, 0, 0 )
		]
	]

func ready():
	main = get_node("/root/main")
	
class Tile:
	var index
	var grid
	var vec
	var node 
	var visiable = false
	var ring = -1






