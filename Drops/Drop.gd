extends Node2D

const Player = preload("res://Player/Player.gd")

#enums
enum Type {
	WEAPON,
	CONSUMABLE,
	CURRENCY
}

# vars
var type : int
var stats : String
var img : String


var _player : Player

func make_drop(drop_type: int, drop_stats : String, drop_img : String, drop_sprite : Sprite, drop_player : Player):
	type = drop_type
	stats = drop_stats
	img = drop_img
	_player = drop_player
	var sprite = drop_sprite.instance()
	sprite.transform.x = 0
	sprite.transform.y = 0
	
	get_parent().set_node("Sprite",sprite)
	

func _process(delta):
	if !_player:
		_player = get_tree().get_root().get_node("Dungeon").get_node("Player")
	print(_player)

func make_random_drop():
	var random_type = randi()%3
	match random_type:
		Type.WEAPON:
			
			pass
		Type.CONSUMABLE:
			pass
		Type.CURRENCY:
			pass
