extends Node

func _ready():
	for node in get_children():
		if not node.is_in_group("Tilemap"):
		
			var static_body = StaticBody2D.new()
			add_child(static_body)

	
			static_body.position = node.global_position

		
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.size = node.size
			collision_shape.shape = shape
			

			collision_shape.rotation = node.rotation
			collision_shape.position = node.size / 2

			static_body.add_child(collision_shape)
		
		
		
		
