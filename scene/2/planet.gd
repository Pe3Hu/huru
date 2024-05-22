extends MarginContainer


#region var
@onready var nodes = $Nodes
@onready var mainland = $Nodes/Mainland
@onready var minions = $Nodes/Minions

var universe = null
var gods = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.planet = self
	mainland.set_attributes(input)


func add_god(god_: MarginContainer) -> void:
	gods.append(god_)
	god_.planet = self
	god_.conqueror.init_basic_setting()
#endregion


func start_race() -> void:
	pass
#endregion

