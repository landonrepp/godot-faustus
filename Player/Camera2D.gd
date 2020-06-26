extends Camera2D

onready var player = get_parent().get_node("YSort/PlayerSprite")

func _ready():
	set_process(true)
	
func _process(delta):
	var target_position = -get_viewport().get_mouse_position().normalized().normalized() * 100

	position = position.move_toward(-target_position,20)
