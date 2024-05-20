extends CharacterBody2D


#region var
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

var planet = null
var spot = null
var speed = 264
var direction : Vector2
var target = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	spot = input_.spot
	
	init_basic_setting()


func init_basic_setting() -> void:
	position = spot.get_local_position()


func pick_target() -> void:
	target = null
	
	while target == null or target == spot:
		target = planet.mainland.settlements.pick_random()
	
	make_path()
#endregion


func _physics_process(_delta: float) -> void:
	if target != null:
		if navigation_agent.is_target_reachable():
			direction = to_local(navigation_agent.get_next_path_position()).normalized()
	
	velocity = direction * speed
	move_and_slide()


func _unhandled_input(_event: InputEvent) -> void:
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()


func make_path() -> void:
	navigation_agent.target_position = target.get_global_position()# + planet.custom_minimum_size


func _on_timer_timeout():
	pick_target()


func _on_navigation_agent_2d_target_reached():
	spot = target
	pick_target()
