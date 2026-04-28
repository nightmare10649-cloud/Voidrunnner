extends Node

func _ready():
	for node in get_children():
		for color_rect in node.get_children():
			if not color_rect.is_in_group("Tilemap"):
		
				var static_body = StaticBody2D.new()
				add_child(static_body)

	
				static_body.position = color_rect.global_position

		
				var collision_shape = CollisionShape2D.new()
				var shape = RectangleShape2D.new()
				shape.size = color_rect.size
				collision_shape.shape = shape

	
				collision_shape.position = color_rect.size / 2

				static_body.add_child(collision_shape)
		
		
		
		
