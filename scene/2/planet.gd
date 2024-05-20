extends MarginContainer


#region var
@onready var nodes = $Nodes
@onready var mainland = $Nodes/Mainland
@onready var minions = $Nodes/Minions
@onready var minion = $Nodes/Minions/Minion

var universe = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.planet = self
	mainland.set_attributes(input)
	input.spot = mainland.settlements.pick_random()
	minion.set_attributes(input)
#endregion
