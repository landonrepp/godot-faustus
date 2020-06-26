extends Node2D

onready var Room = preload("res://Dungeon/Room/Room.tscn")
onready var Player = preload("res://Player/Player.tscn")
onready var prjectile_assets = preload("res://Projectiles/Projectile.tscn")
onready var drop = preload("res://Drops/Drop.tscn")

const tile_size = 16
const num_rooms = 15
const min_size = 2
const max_size = 7
const hspread = 0
const vspread = 0
const cull = 0
var path #holds spanning tree to rooms
onready var Map = $BaseDungeonTiles

func _ready():
	randomize()
	yield(make_rooms(),"completed")
	make_map()
	yield(get_tree(),"idle_frame")
	spawn_player()
	set_process(true)

func spawn_player():
	#get leftmost room and spawn the player in it
	var min_x = INF
	var min_p = null
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			min_p = room
			min_x = room.position.x
#		room.queue_free()
	var player = Player.instance()
	player.position = min_p.position
	print(min_p.position)
	add_child(player)

	

func make_rooms():
	for _i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread,hspread),rand_range(-vspread,vspread))
		var r = Room.instance()
		
		var w = min_size + rand_range(min_size,max_size) #	randi() % (max_size-min_size)
		var h = min_size + rand_range(min_size,max_size) #randi() % (max_size-min_size)
		r.make_room(pos, Vector2(w,h)*tile_size)
		$Rooms.add_child(r)
	#wait for the rooms to stop moving
	yield(get_tree().create_timer((1.1)),'timeout')
	
	var room_positions = []
	for room in $Rooms.get_children():
		if(randf() < cull):
			room.queue_free()
		else:
			room.set_disabled(true)
			room_positions.append(Vector3(room.position.x,
				room.position.y,0))
	#TODO: learn how to get rid of these yields
	yield(get_tree(),"idle_frame")
	
	#generate a minimum spanning tree
	path = find_mst(room_positions)

func find_mst(nodes):
	#Prims algorithm
	var a_star = AStar.new()
	a_star.add_point(a_star.get_available_point_id(),nodes.pop_front())
	while nodes:
		var min_distance = INF
		var min_p = null
		var p = null
		for p1 in a_star.get_points():
			p1 = a_star.get_point_position(p1)
			for p2 in nodes:
				if p1.distance_to(p2) < min_distance:
					min_distance = p1.distance_to(p2)
					min_p = p2
					p = p1
		var n = a_star.get_available_point_id()
		a_star.add_point(n,
			min_p)
		a_star.connect_points(a_star.get_closest_point(p),n)
		nodes.erase(min_p)
	return a_star

func make_map():
	#creates a tile map from the generated rooms and path
	Map.clear()
	#fill tile map with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size,
		room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var top_left = Map.world_to_map(full_rect.position)
	var bottom_right = Map.world_to_map(full_rect.end)
	for x in range(top_left.x,bottom_right.x):
		for y in range(top_left.y,bottom_right.y):
			Map.set_cell(x,y,1)
	# carve rooms
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
#		var pos = Map.world_to_map(room.position)
		var upper_left = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):			
				Map.set_cell(upper_left.x+x,upper_left.y+y, 0)
		#carve connections
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			#should con be p here?
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x,
					path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x,
					path.get_point_position(conn).y))
				carve_path(start,end)
		corridors.append(p)

func carve_path(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1,randi()%2)
	if y_diff == 0: y_diff = pow(-1,randi()%2)

	#randomly choose a starting position
	var x_y = pos1
	var y_x = pos2
	if(randi()%2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y,0)
		Map.set_cell(x, x_y.y + y_diff,0)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y,0)
		Map.set_cell(y_x.x + x_diff, y,0)
		
#func add_drops():
#
