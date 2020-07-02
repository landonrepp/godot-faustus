extends KinematicBody2D

onready var Player = preload("res://Player/Player.tscn")

var health : int = 100
var weapon

var _player : Node2D


func _ready():
	weapon = $YSort/Weapon
	weapon.make_weapon(weapon.make_random_weapon_dict(),"Player")
	add_child(weapon)

func _process(delta):
	if _player:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position,_player.position,
				[self],collision_mask)
		if result:
			var hit_pos = result.position
			if result.collider.name == "Player":
				rotation = (_player.position - position).angle()
				if weapon.fire_type == weapon.FireType.SEMI_AUTO:
					weapon.set_shooting(!weapon.get_shooting())
				else:
					weapon.set_shooting(true)
		

func _on_RetentionArea_body_exited(body):
	_player = null

func _on_DetectionArea_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.has_method("add_to_inventory"):
		_player = body
