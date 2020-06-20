extends Node2D

onready var Room = preload("res://Dungeon/Room/Room.tscn")

var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10

func _ready():
	randomize()
	make_rooms()

func make_rooms():
	for _i in range(num_rooms):
		var pos = Vector2(0,0)
		var r = Room.instance()
		print(r)
		var w = min_size + randi() % (max_size-min_size)
		var h = min_size + randi() % (max_size-min_size)
		r.make_room(pos, Vector2(w,h)*tile_size)
		$Rooms.add_child(r)
