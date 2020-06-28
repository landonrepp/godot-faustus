extends Node2D

onready var prjectile_assets = preload("res://Projectiles/Projectile.tscn")
onready var sprite = get_node("Sprite")
var weapon_properties = {}
var player_group = ""
var weapon_type : int
var fire_type : int
var _is_shooting : bool setget set_shooting, get_shooting
var _shot : bool = false
var _fire_type : int
var _fire_rate: float
var _last_time_fired: float = INF

enum WeaponType {
	SEMI_PISTOL,
	SEMI_RIFLE,
	REVOLVER,
	AUTO_RIFLE
}
enum FireType {
	SEMI_AUTO,
	FULL_AUTO 
}

func set_shooting(val : bool):
	_is_shooting = val
	if(!val):
		_shot = false

func get_shooting():
	return _is_shooting

func set_flip_v(val : bool):
	sprite.set_flip_v(val)


func make_weapon(proj_dict : Dictionary, group : String) -> void: 
	player_group = group
	weapon_properties = proj_dict
	weapon_type = weapon_properties.get("weapon_type",WeaponType.SEMI_PISTOL)
	print(sprite)
	sprite.set_frame(weapon_type)

func _process(delta):
	_last_time_fired += delta
	if(get_shooting()):
		_shoot()

func make_random_weapon_dict():
	var random_weapon_type = randi()%3
	match random_weapon_type:
		WeaponType.SEMI_PISTOL, WeaponType.REVOLVER:
			return {
				'fire_type' : FireType.SEMI_AUTO,
				'weapon_type' : random_weapon_type,
				'fire_rate' : .5,
				'speed' : randi() % 70 + (100 * random_weapon_type),
				'damage' : randi() % 100 + 10,
				'max_distance' : 200,
				'size' : 6,
				'tags' : []
			}
		WeaponType.SEMI_RIFLE, WeaponType.AUTO_RIFLE:
			return {
				'fire_type' : FireType.FULL_AUTO,
				'weapon_type' : random_weapon_type,
				'fire_rate' : .1,
				'speed' : randi() % 70 + 200,
				'damage' : randi() % 100 + 50,
				'max_distance' : 200,
				'size' : 8,
				'tags' : []
			}

func _shoot():
	if !_fire_type:
		_fire_type = weapon_properties.get('fire_type',FireType.SEMI_AUTO)
	if !_fire_rate:
		_fire_rate = weapon_properties.get('fire_rate', .1)
	if ((_fire_type == FireType.SEMI_AUTO && !_shot) || (_fire_type == FireType.FULL_AUTO)
	&& _last_time_fired > _fire_rate):
		_last_time_fired = 0
		if(_fire_type == FireType.SEMI_AUTO):
			_shot = true
		else:
			_shot = false
			
		var projectile = prjectile_assets.instance()
		projectile.make_projectile(weapon_properties,
			get_parent().get_parent().position,
			Vector2(cos(global_rotation),sin(global_rotation)),
			get_parent().get_parent().get_collision_layer())
		get_tree().get_root().get_node("Dungeon").add_child(projectile)

