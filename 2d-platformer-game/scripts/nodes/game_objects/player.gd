extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	position = GameManager.game_state.last_checkpoint

func handle_animations(direction: float) -> void:
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif direction == -1 or direction == 1:
			animated_sprite_2d.flip_h = (direction == -1)
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

func handle_movement(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	# Don't let the player continue moving once it's over
	if GameManager.game_state.is_game_over:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	handle_animations(direction)
	
	handle_movement(direction)

	move_and_slide()
