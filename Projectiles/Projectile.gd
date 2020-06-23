extends Area2D

func _ready():
	set_process(true)

var initial_position
var direction
#parsed out of the projectile dictionary on creation
var speed
var damage
var max_distance
var size
var tags

#takes a dictionary with projectile attributes
func make_projectile(proj_dict, position, proj_direction):
	initial_position = position
	direction = proj_direction
	#parse dictionary
	
	speed = proj_dict.get("speed",100)
	damage = proj_dict.get("damage",10)
	max_distance = proj_dict.get("max_distance",200)
	size = proj_dict.get("size",8)
	tags = proj_dict.get("tags",[])
	
	
#func _process(delta):
