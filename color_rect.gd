extends ColorRect

func _ready():
	var parent: ColorRect = get_parent() as ColorRect
	
	if not parent:
		return
		
	await get_tree().process_frame

	var static_body = StaticBody2D.new()
	add_child(static_body)

	static_body.global_position = parent.global_position

	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	shape.size = parent.size
	collision_shape.shape = shape

	collision_shape.position = parent.size / 2

	static_body.add_child(collision_shape)
