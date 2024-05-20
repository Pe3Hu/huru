extends Node


class Spot:
	var mainland = null
	var grid = null
	var type = null
	var ring = null
	
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

