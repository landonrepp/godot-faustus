extends KinematicBody2D
 
const max_speed = 100
const accelaration = 1000
const friction = 1000
var health = 100
 
var velocity = Vector2.ZERO

onready var player_sprite = get_node("YSort").get_node("PlayerSprite")
onready var weapon = get_node("YSort").get_node("Weapon")

func _ready():
	yield(get_tree(), "idle_frame")
	add_to_group("player")
	weapon.make_weapon({},"player")
 
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed,accelaration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	velocity = move_and_slide(velocity)
	
	var look_vec = get_global_mouse_position() - global_position
	
	#todo: maybe look into putting the weapon variable changes in the weapon object?
	var rotation_angle = atan2(look_vec.y, look_vec.x)
	player_sprite.global_rotation = rotation_angle
	weapon.global_rotation = rotation_angle
	weapon.position =  Vector2(cos(rotation_angle),sin(rotation_angle)).normalized()
	if abs(rotation_angle) > (PI/2) && abs(rotation_angle) < (3*PI/2):
		weapon.set_flip_v(true)
	else:
		weapon.set_flip_v(false)
	if Input.is_action_pressed("shoot"):
		#todo: activate weapon
		weapon.set_shooting(true)
	else:
		weapon.set_shooting(false)
