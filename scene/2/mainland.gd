extends Node2D


#region var
@onready var spots = $Spots
@onready var outcomes = $Outcomes
@onready var zones = $Zones

var planet = null
var grids = {}
var wastelands = []
var settlements = []
var roads = []
var forests = []
var mountains = []
var plains = []
var terrains = {}
var layer = {}
var source = null
var rings = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	layer.floor = 0
	source = 0
	
	init_cells()
	init_zones()


func init_cells() -> void:
	var l = Global.num.spot.l
	var radius = Global.num.mainland.rings
	planet.custom_minimum_size = Vector2.ONE * Global.num.mainland.n * l
	planet.nodes.position = -Vector2.ONE * l / 2 + planet.custom_minimum_size * 0.5
	planet.minions.position += Vector2.ONE * l / 2
	zones.position += Vector2.ONE * l / 2
	
	for ring in radius + 1:
		rings[ring] = []
	
	for y in range(-radius, radius + 1):
		for x in range(-radius, radius + 1):
			var grid = Vector2i(x, y)
			add_spot(grid)


func add_spot(grid_: Vector2i) -> void:
	var input = {}
	input.mainland = self
	input.grid = grid_
	input.type = "wasteland"
	
	var atlas_coord = Vector2i(2, 0)
	var gap = grid_ + Vector2i.ONE * Global.num.mainland.rings
	
	if gap.x % Global.num.settlement.gap == 0 or gap.y % Global.num.settlement.gap == 0:
		atlas_coord = Vector2i(1, 0)
		input.type = "road"
		
		if gap.x % Global.num.settlement.gap == 0 and gap.y % Global.num.settlement.gap == 0:
			input.type = "settlement"
			atlas_coord = Vector2i(0, 0)
	
	spots.set_cell(layer.floor, grid_, source, atlas_coord)
	var _spot = Classes.Spot.new(input)


#func init_workpieces() -> void:
	#var k = int((radius - 2) / 2) + 1
	#var workpieces = []
	#
	#for _i in k:
		#var _ring = _i * 2 + 2
		#var _rings = [_ring, _ring + 1]
		#var options = []
	#
		#for ring in _rings:
			#for grid in rings[ring]:
				#var flag = true
				#
				#for direction in Global.dict.direction.linear:
					#if flag:
						#var _grid = Vector2i(grid + direction)
						#
						#if grid_radius_check(_grid):
							#var tile_data = spots.get_cell_tile_data(layer.floor, _grid)
							#
							#if tile_data:
								#if tile_data.get_custom_data("occupied") or tile_data.get_custom_data("frontier"):
									#flag = false
									#break
				#
				#if flag:
					#options.append(grid)
		#
		##var terrain_index = _i#Global.arr.terrains.find("aqua")
		#var limit = int(options.size() / 4.0)
		#
		#while limit > 0 and !options.is_empty():
			#limit -= 1
			#
			#var grid = options.pick_random()
			#options.erase(grid)
			#workpieces.append(grid)
			#
			#for direction in Global.dict.direction.linear:
				#var _grid = Vector2i(grid + direction)
				#
				#if grid_radius_check(_grid):
					#if options.has(_grid):
						#options.erase(_grid)
		#
		##set_cells_terrain_connect(layer.floor, workpieces, terrain_index, 0)
	#
	#for grid in workpieces:
		#var element = Global.arr.element.pick_random()
		#var x = Global.arr.element.find(element) + 1
		#var atlas_coord = Vector2i(x, 25)
		#spots.set_cell(layer.floor, grid, source, atlas_coord)


func init_zones() -> void:
	for type in Global.arr.ennobled:
		var _spots = get(type+"s")
		
		for spot in _spots:
			add_zone(spot)
	
	update_zone_neighbors()


func add_zone(spot_: Classes.Spot) -> void:
	var input = {}
	input.spot = spot_
	
	var zone = Global.scene.zone.instantiate()
	zones.add_child(zone)
	zone.set_attributes(input)


func update_zone_neighbors() -> void:
	for zone in zones.get_children():
		for direction in Global.dict.direction.linear:
			var grid = direction + zone.spot.grid
			
			if grids.has(grid):
				var neighbor = grids[grid]
				
				if !zone.neighbors.has(neighbor) and neighbor.zone != null:
					zone.neighbors[neighbor.zone] = direction
					neighbor.zone.neighbors[zone] = -direction


func grid_radius_check(grid_: Vector2i) -> bool:
	return abs(grid_.x) <= Global.num.mainland.rings and abs(grid_.y) <= Global.num.mainland.rings
#endregion
