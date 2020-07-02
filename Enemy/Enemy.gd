extends KinematicBody2D

onready var Player = preload("res://Player/Player.tscn")

var health : int = 100
var weapon

var _player : Node2D


func _ready():
	weapon = $YSort/Weapon
	weapon.make_weapon(weapon.make_random_weapon_dict(),"Player")

func _process(delta):
	if _player:
#		var space_state = get_world_2d().direct_space_state
#		var result = space_state.intersect_ray(position,_player.position,
#				[self],collision_mask)
#		if result:		
#				rotation = (_player.position - position).angle()
		if weapon.fire_type == weapon.FireType.SEMI_AUTO:
			weapon.set_shooting(!weapon.get_shooting())
		else:
			weapon.set_shooting(true)
	
