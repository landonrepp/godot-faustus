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
	projectile.make_projectile(weapon_properties,
		get_parent().get_parent().position,
		Vector2(cos(global_rotation),sin(global_rotation)),
		get_parent().get_parent().get_collision_layer())
	print("bang")
	get_tree().get_root().get_node("Dungeon").add_child(projectile)
