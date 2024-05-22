extends Polygon2D


#region var
@onready var influence = $Influence

var spot = null
var conqueror = null
var neighbors = {}
var volume = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	spot = input_.spot
	
	init_basic_setting()


func init_basic_setting() -> void:
	volume = 100
	spot.zone = self
	position = spot.get_local_position()
	init_tokens()
	set_vertexs()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "spot"
	input.subtype = "influence"
	input.value = 0
	influence.set_attributes(input)
	influence.custom_minimum_size = Global.vec.size.spot


func set_vertexs() -> void:
	var order = "odd"
	var corners = 4
	var r = Global.num.spot.r# * 0.75
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func recolor_based_on_god() -> void:
	color = Global.color.god[conqueror.god.index]


func change_influence(conqueror_: Classes.Conqueror, value_: int) -> void:
	if conqueror != conqueror_ and conqueror != null:
		value_ *= -1
	
	if conqueror == null:
		conqueror = conqueror_
		recolor_based_on_god()
	
	influence.change_value(value_)
	var value = influence.get_value()
	
	if value >= volume:
		influence.set_value(volume)
		conqueror_.annex_zone(self)
	
	if value < 0:
		value *= -1
		
		if conqueror != null:
			conqueror.forfeit_zone(self)
		
		conqueror_.annex_zone(self)
		influence.set_value(value)
	
	if value == 0:
		visible = false
	else:
		visible = true
		color.a = 0.1 + float(value) / volume * 0.8
#endregion
