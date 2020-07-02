extends Area2D

const Player = preload("res://Player/Player.gd")
var Weapon = preload("res://Weapon/Weapon.tscn")

#enums
enum Type {
	WEAPON,
	CONSUMABLE,
	CURRENCY
}

# vars
var type : int
var stats : Dictionary
var sprite : Sprite
var _player : Player

func make_drop(drop_type: int, drop_stats : Dictionary, drop_sprite : Sprite):
	type = drop_type
	stats = drop_stats
	sprite = drop_sprite
	sprite.position.x = 0
	sprite.position.y = 0
	sprite.scale.x = 1.0/8
	sprite.scale.y = 1.0/8
	add_child(sprite.duplicate())

func _process(delta):
	if(_player):
		position += (_player.position - position).normalized() * 200 * delta

func make_random_drop():
	var random_type = randi()%1
	match random_type:
		Type.WEAPON:
			var random_weapon = Weapon.instance()
			var random_weapon_dict = random_weapon.make_random_weapon_dict()
			random_weapon.make_weapon(random_weapon_dict,"Player")
			make_drop(random_type,random_weapon_dict,random_weapon.get_node("Sprite"))
		Type.CONSUMABLE:
			pass
		Type.CURRENCY:
			pass

func _on_Drop_body_entered(body):
	if body.has_method("add_to_inventory"):
		body.add_to_inventory({
			"type":type,
			"stats":stats,
			"sprite":sprite
		})
		queue_free()

func _on_GraavityArea_body_entered(body):
	# if body has this property, have the drop get "sucked in" to the body
	if body.has_method("add_to_inventory"):
		_player = body
