extends CharacterBody2D

var elapsed_time := 0.0
var is_counting = false
@export var speed = 800
var gravity = 2000
@export var roll_speed = 1200
@export var jump_force = -750
var dubgrav = false

var spawn = Vector2(74, 121)

enum State {
	IDLE,
	RUN,
	JUMP,
	ROLL,
	DEAD,
	SLAM,
	RESTART
}

var state = State.IDLE

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label



var times = 0
func apply_squash():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.6), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.06)

func apply_stretch():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.7, 1.3), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)

func _process(delta):
	
	
	if is_counting:
		elapsed_time += delta
		label.text = str(elapsed_time).pad_decimals(2)

func _physics_process(delta):
	match state:
		State.IDLE:
			handle_idle(delta)
		State.RUN:
			handle_run(delta)
		State.JUMP:
			handle_jump(delta)
		State.ROLL:
			handle_roll(delta)
		State.DEAD:
			handle_dead(delta)
		State.SLAM:
			handle_slam()
		State.RESTART:
			handle_restart()

	apply_gravity(delta)
	move_and_slide()
	update_facing()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func update_facing():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func handle_idle(delta):
	velocity.x = 0

	if sprite.animation != "idle":
		sprite.play("idle")

	var dir = Input.get_axis("ui_A", "ui_D")

	if dir != 0:
		state = State.RUN

	if Input.is_action_just_pressed("ui_accept"):
		if not is_counting and times != 1:
			times += 1
			is_counting = true
		jump()
	
	if Input.is_action_just_pressed("ui_N"):
		if not is_counting and times != 1:
			times += 1
			is_counting = true
		handle_slam()
		
	if Input.is_action_just_pressed("ui_R"):
		handle_restart()

	if Input.is_action_just_pressed("ui_C") or Input.is_action_just_pressed("ui_B"):
		if not is_counting and times != 1:
			times += 1
			is_counting = true
		start_roll() 

func handle_restart():
	$".".global_position = Vector2(-1020,-316)
	times = 0
	is_counting = false
	elapsed_time = 0.0

func handle_run(delta):
	if not is_counting and times != 1:
			times += 1
			is_counting = true
	var dir = Input.get_axis("ui_A", "ui_D")
	velocity.x = dir * speed

	if sprite.animation != "running":
		sprite.play("running")

	if dir == 0:
		state = State.IDLE

	if Input.is_action_just_pressed("ui_R"):
		handle_restart()
		
	if Input.is_action_just_pressed("ui_accept"):
		if not is_counting and times != 1:
			times += 1
			is_counting = true
		jump()
	
	if Input.is_action_just_pressed("ui_N"):
		if not is_counting and times != 1:
			times += 1
			is_counting = true
		handle_slam()

	if Input.is_action_just_pressed("ui_C") or Input.is_action_just_pressed("ui_B"):
		if not is_counting and times != 1:
			times += 1
			is_counting = true
		start_roll()


func handle_jump(delta):
	var dir = Input.get_axis("ui_A", "ui_D")
	velocity.x = dir * speed

	
	if Input.is_action_just_pressed("ui_R"):
		handle_restart()
		
	if Input.is_action_just_pressed("ui_C") or Input.is_action_just_pressed("ui_B"):
		start_roll()
	
	if Input.is_action_just_pressed("ui_N"):
		handle_slam()

	if is_on_floor() or is_on_wall():
		apply_squash()
		if dir == 0:
			state = State.IDLE
		else:
			state = State.RUN


func handle_roll(delta):
	if Input.is_action_just_pressed("ui_accept"):
		jump()
		return

	if not sprite.is_playing():
		var dir = Input.get_axis("ui_A", "ui_D")
		if dir == 0:
			state = State.IDLE
		else:
			state = State.RUN


func start_roll():
	state = State.ROLL
	apply_squash()

	if sprite.flip_h:
		velocity.x = -roll_speed
	else:
		velocity.x = roll_speed

	sprite.play("roll")


func handle_dead(delta):
	velocity = Vector2.ZERO

	if sprite.animation != "hurt":
		sprite.play("hurt")
		await sprite.animation_finished
		global_position = spawn
		state = State.IDLE

func handle_slam():
	apply_stretch()
	if not dubgrav:
		dubgrav = true
		gravity *= 10
	else:
		dubgrav = false
		gravity /= 10
	#$".".global_position = Vector2(2631,1801)
	

func jump():
	velocity.y = jump_force
	apply_squash()
	state = State.JUMP
	apply_stretch()
	
