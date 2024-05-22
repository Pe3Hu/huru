extends MarginContainer


#region vars
var pantheon = null
var planet = null
var conqueror = null
var index = 0
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	index = int(Global.num.index.god)
	Global.num.index.god += 1
	
	var input = {}
	input.god = self
	conqueror = Classes.Conqueror.new(input)
#endregion
