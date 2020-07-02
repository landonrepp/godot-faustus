extends Camera2D

onready var player = get_parent().get_node("YSort/PlayerSprite")

func _ready():
	set_process(true)
	
func _process(delta):
	pass
#	var target_position = get_global_mouse_position().normalized().normalized() * 100

#	position = position.move_toward(-target_position,20)

