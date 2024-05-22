extends Node


class Spot:
	var mainland = null
	var grid = null
	var type = null
	var ring = null
	var zone = null
	
	func _init(input_: Dictionary) -> void:
		mainland = input_.mainland
		grid = Vector2i(input_.grid)
		type = input_.type
	
		init_basic_setting()


	func init_basic_setting() -> void:
		mainland[type+"s"].append(self)
		mainland.grids[grid] = self
		
		var radius = Global.num.mainland.rings
		ring = min(abs(radius - grid.x), abs(radius - grid.y), abs(radius + grid.x), abs(radius + grid.y))
		ring = radius - ring
		mainland.rings[ring].append(grid)


	func get_local_position() -> Vector2:
		return mainland.spots.map_to_local(grid) - Vector2.ONE * Global.num.spot.l / 2


	func get_global_position() -> Vector2:
		return mainland.to_global(mainland.spots.map_to_local(grid))
		#return Vector2(grid) * Global.num.spot.l


class Conqueror:
	var god = null
	var mainland = null
	var settlements = []
	var roads = []
	var zones = []
	var frontiers = []
	var minions = []
	
	func _init(input_: Dictionary) -> void:
		god = input_.god
	
		#init_basic_setting()


	func init_basic_setting() -> void:
		mainland = god.planet.mainland
		roll_settlement()
		add_minion()


	func roll_settlement() -> void:
		var options = []
		var l = Global.num.mainland.rings - Global.num.settlement.gap
		
		for direction in Global.dict.direction.diagonal:
			var grid = Vector2i(direction) * l
			var spot = mainland.grids[grid]
			
			if spot.zone.conqueror == null:
				options.append(spot)
		
		var settlement = options.pick_random()
		settlement.zone.change_influence(self, settlement.zone.volume)


	func annex_zone(zone_: Polygon2D) -> void:
		zone_.conqueror = self
		zone_.recolor_based_on_god()
		
		var spots = get(zone_.spot.type + "s") 
		spots.append(zone_.spot)
		
		frontiers.erase(zone_)
		zones.append(zone_)
		
		for neighbor in zone_.neighbors:
			if !frontiers.has(neighbor) and !zones.has(neighbor):
				frontiers.append(neighbor)


	func forfeit_zone(zone_: Polygon2D) -> void:
		zone_.conqueror = null
		
		var spots = get(zone_.spot.type + "s") 
		spots.erase(zone_.spot)
		
		zones.erase(zone_)
		frontiers.append(zone_)
		
		for neighbor in zone_.neighbors:
			var flag = false
			
			for _neighbor in neighbor.neighbors:
				if zones.has(_neighbor):
					flag = true
			
			if !flag:
				frontiers.erase(neighbor)


	func add_minion() -> void:
		var input = {}
		input.conqueror = self
		input.spot = settlements.pick_random()
		
		var minion = Global.scene.minion.instantiate()
		mainland.planet.minions.add_child(minion)
		minion.set_attributes(input)
		minions.append(minion)
