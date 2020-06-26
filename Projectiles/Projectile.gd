extends KinematicBody2D

func hit(collider): 
	if !collider: return
	if collider.has_method("take_damage"):
		collider.take_damage(damage)
	queue_free()
	

var initial_position
var direction
#parsed out of the projectile dictionary on creation
var speed
var damage
var max_distance
var size
var tags

#takes a dictionary with projectile attributes
func make_projectile(proj_dict : Dictionary, pos :Vector2, proj_direction : Vector2, parent_layer : int) -> void: 
	initial_position = pos
	position = initial_position
	direction = proj_direction
	#parse dictionary
	
	speed = proj_dict.get("speed",200)
	damage = proj_dict.get("damage",10)
	max_distance = proj_dict.get("max_distance",200)
	size = proj_dict.get("size",8)
	tags = proj_dict.get("tags",[])
	
	#set size of projectile
	scale = Vector2(size/16.0,size/16.0)
	
	set_collision_mask(get_collision_mask() & ~parent_layer)

func _process(delta):
	var collision_info = move_and_collide(direction * speed * delta)
	
	if collision_info:
		hit(collision_info.collider)
	
	if abs(position.distance_to(initial_position)) >= max_distance:
		queue_free()
