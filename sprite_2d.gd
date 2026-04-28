extends Sprite2D

@export var on_screen_offset: Vector2 = Vector2(0.5, -5.0)
@export var screen_margin: float = 4.0
@export var smoothing_speed: float = 8.0

var cam_node: Camera2D

func _ready():
	cam_node = get_viewport().get_camera_2d()
	
func _process(delta):
	if not cam_node:
		cam_node = get_viewport().get_camera_2d()
		return
		
	var target_global_position: Vector2 = global_position
	var viewport_dimensions: Vector2 = get_viewport().get_visible_rect().size
	
	var screen_cordinates: Vector2 = (target_global_position - cam_node.global_position) * cam_node.zoom + viewport_dimensions * 0.5
	var screen_inset_rectangle: Rect2 = Rect2(Vector2.ZERO, viewport_dimensions).grow(-screen_margin)
	
	var target_display_position: Vector2
	var target_display_rotation: float
	
	if screen_inset_rectangle.has_point(screen_cordinates):
		target_display_position = target_global_position + on_screen_offset
		target_display_rotation = 0.0
	else:
		var clamped_x = clamp(screen_cordinates.x, screen_margin, viewport_dimensions.x - screen_margin)
		var clamped_y = clamp(screen_cordinates.y, screen_margin, viewport_dimensions.y - screen_margin)
		var clamped_screen_cords: Vector2 = Vector2(clamped_x, clamped_y)
	
		target_display_position = cam_node.global_position + (clamped_screen_cords - viewport_dimensions * 0.5) / cam_node.zoom
	
		var direction: Vector2 = (target_global_position - target_display_position).normalized()
		target_display_rotation = direction.angle() + PI * 0.5
	
	global_position = lerp(global_position, target_display_position, delta * smoothing_speed)
	rotation = lerp_angle(rotation, target_display_rotation, delta * smoothing_speed)
