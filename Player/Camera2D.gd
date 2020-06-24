extends Camera2D

onready var player = get_parent().get_node("PlayerSprite")

func _ready():
	set_process(true)
	
func _process(delta):
	var target_position = (player.position - get_viewport().get_mouse_position().normalized()).normalized()
	
	position = position.move_toward(target_position * 20,1)
