extends Node2D

onready var prjectile_assets = preload("res://Projectiles/Projectile.tscn")
var weapon_properties = {}
var player_group = ""

func set_flip_v(val : bool):
	$Sprite.set_flip_v(val)


func make_weapon(proj_dict : Dictionary, group : String) -> void: 
	player_group = group
	weapon_properties = proj_dict
	pass

func shoot():
	var projectile = prjectile_assets.instance()
	projectile.make_projectile(weapon_properties,get_parent().get_parent().position,Vector2(sin(global_rotation),cos(global_rotation)),player_group)
	print("bang")
	get_tree().get_root().get_node("Dungeon").add_child(projectile)
