extends CharacterBody2D


#region var
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

var conqueror = null
var spot = null
var speed = 128
var power = 50
var direction : Vector2
var target = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	conqueror = input_.conqueror
	spot = input_.spot
	
	init_basic_setting()


func init_basic_setting() -> void:
	position = spot.get_local_position()


func pick_target() -> void:
	var weights = {}
	var distances = []
	
	for zone in conqueror.frontiers:
		if zone.spot != spot:
			var distance = Vector2(spot.grid).distance_to(Vector2(zone.spot.grid))
			distances.append(distance)
			weights[zone] = distance
	
	for zone in weights:
		weights[zone] = pow(distances.max() + 1 - weights[zone], 2)
	
	target = Global.get_random_key(weights).spot
	make_path()
#endregion


func _physics_process(_delta: float) -> void:
	if target != null:
		if navigation_agent.is_target_reachable():
			direction = to_local(navigation_agent.get_next_path_position()).normalized()
	
	velocity = direction * speed
	move_and_slide()


func make_path() -> void:
	navigation_agent.target_position = target.get_global_position()# + conqueror.custom_minimum_size


func _on_timer_timeout():
	pick_target()


func _on_navigation_agent_2d_target_reached():
	spot = target
	spot.zone.change_influence(conqueror, power)
	pick_target()
