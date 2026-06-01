extends CharacterBody2D
# Player is originally a CharacterBody2D node back in its own scene. 
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var arrowShoot_sound: AudioStreamPlayer2D = $ArrowShootSound
@onready var ArrowScene = preload("res://arrow.tscn")
@export var next_level: String
@export var arrow_container: Node
const SPEED = 300.0
const JUMP_VELOCITY = -550.0
var climbing_ladder := false
var climb_target_y := 100.0

func start_ladder_climb(target_y: float):
	climbing_ladder = true

func _physics_process(delta: float) -> void:
	
	if climbing_ladder:
		velocity = Vector2.ZERO
		global_position.y -= 200 * delta
		if global_position.y <= climb_target_y:
			level_complete()
			return

		move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	if Input.is_action_just_pressed("shootArrow"):
		arrowShoot_sound.play()
		shoot_arrow()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	var mouse_pos:= get_global_mouse_position()
	# This may have to change in the future!!! If the camera moves-that is. 

	var player_pos := global_transform.x
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	# If the player is facing right
	if mouse_pos > global_position: 
		sprite_2d.flip_v = false
		
	elif mouse_pos < global_position: 
		sprite_2d.flip_v = true
		
func shoot_arrow():
	var arrow = ArrowScene.instantiate()
	arrow_container.add_child(arrow)

	arrow.global_position = global_position

	var direction = (get_global_mouse_position() - global_position).normalized()
	arrow.launch(direction * 450, direction.angle())
func level_complete():
	get_tree().change_scene_to_file(next_level)
