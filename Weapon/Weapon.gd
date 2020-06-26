extends Node2D

onready var prjectile_assets = preload("res://Projectiles/Projectile.tscn")
var weapon_properties = {}
var player_group = ""

enum WeaponType {
	SEMI_POSTOL,
	SEMI_RIFLE,
	REVOLVER,
	AUTO_RIFLE
}

func set_flip_v(val : bool):
	$Sprite.set_flip_v(val)

var weapon_type : int
func make_weapon(proj_dict : Dictionary, group : String) -> void: 
	player_group = group
	weapon_properties = proj_dict
	weapon_type = weapon_properties.get("weapon_type",0)

func shoot():
	var projectile = prjectile_assets.instance()
	projectile.make_projectile(weapon_properties,
		get_parent().get_parent().position,
		Vector2(cos(global_rotation),sin(global_rotation)),
		get_parent().get_parent().get_collision_layer())
	get_tree().get_root().get_node("Dungeon").add_child(projectile)

