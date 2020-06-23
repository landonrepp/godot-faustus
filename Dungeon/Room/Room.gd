extends Node2D

var size


func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .75
	s.extents = size
	$CollisionShape2D.shape = s

func set_disabled(val):
	$CollisionShape2D.set_disabled(val)
func get_disabled():
	$CollisionShape2D.get_disabled()
