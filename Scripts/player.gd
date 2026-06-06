extends CharacterBody2D
class_name Player
# Player is originally a CharacterBody2D node back in its own scene. 
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var hammer_sprite_2d: AnimatedSprite2D
@export var hammerHitbox := Node2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var arrowShoot_sound: AudioStreamPlayer2D = $ArrowShootSound
@onready var hurtSound: AudioStreamPlayer2D = $HurtSound
@export var sword_hitbox := Area2D
@export var sword_collision := CollisionShape2D


@onready var ArrowScene = preload("res://arrow.tscn")
@onready var wallScene = preload("res://wall.tscn")

@export var next_level: String
@export var arrow_container: Node
const SPEED = 360.0
const JUMP_VELOCITY = -700.0
var climbing_ladder := false
var climb_target_y := 100.0
var maxPlayerHealth := 5
var playerHealth := maxPlayerHealth
var invulnerable := false
var Utility1Cooldown := 0.0
var Utility2Cooldown := 0.0

var Utility1MAXCooldown := 0.0
var Utility2MAXCooldown := 0.0
var UTIL_SELECTED_ITEM_1 := "bow" # Utility 1 contains either bow or sword
var UTIL_SELECTED_ITEM_2 := "wall" # Utility 2 contains building stuff

var Utility1Options := ["bow", "hammer"]
var Utility2Options := ["wall", "trap", "fan"]
var item1Index = 0
var item2Index = 0



# UTILITY 1 COOLDOWNS
var bowMaxCooldown := 0.35 # bow fires quicker but does less damage
var hammerMaxCooldown := 1.0 # Sword swings slower, but does knockback.

# UTILITY 2 COOLDOWNS
var wallMaxCooldown := 5.0 # Wall stops enemies (they have to damage the wall)


func take_damage(amount: int):
	if invulnerable:
		return

	playerHealth -= amount

	var hurt_visual = get_tree().get_first_node_in_group("hurt_visual")
	if hurt_visual:
		hurt_visual.play("flash")
	hurtSound.play()
	invulnerable = true

	if playerHealth <= 0:
		die()
		return	

	await get_tree().create_timer(1.0).timeout
	invulnerable = false

func die():
	print("Player died")
	get_tree().reload_current_scene()
	# Add death logic here

func start_ladder_climb(target_y: float):
	climbing_ladder = true
func _ready():
	sword_collision.disabled = true
func _physics_process(delta: float) -> void:
	
	if Utility1Cooldown > 0:
		Utility1Cooldown -= delta
	if Utility2Cooldown > 0:
		Utility2Cooldown -= delta
	
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
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	if Input.is_action_pressed("useUtility1") && Utility1Cooldown <= 0:
		if UTIL_SELECTED_ITEM_1 == "bow":
			Utility1Cooldown = bowMaxCooldown
			Utility1MAXCooldown = bowMaxCooldown
			arrowShoot_sound.play()
			
			shoot_arrow()
		if UTIL_SELECTED_ITEM_1 == "hammer":
			Utility1Cooldown = hammerMaxCooldown
			Utility1MAXCooldown = hammerMaxCooldown

			hammerAttack()

	if Input.is_action_just_pressed("useUtility2") && Utility2Cooldown <= 0:
		print("Utility 2 used")
		if UTIL_SELECTED_ITEM_2 == "wall":
			Utility2Cooldown = wallMaxCooldown
			Utility2MAXCooldown = wallMaxCooldown
			placeWall()
		
	if Input.is_action_just_pressed("SwapUtility"):
		item1Index += 1
		if	item1Index == Utility1Options.size(): #If the item being selected is the last
			item1Index = 0
			UTIL_SELECTED_ITEM_1 = Utility1Options[item1Index]
		else:
			UTIL_SELECTED_ITEM_1 = Utility1Options[item1Index]

		print(UTIL_SELECTED_ITEM_1)
		
		

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
		sprite_2d.flip_h = false
		hammerHitbox.rotation = 0.0
		hammer_sprite_2d.flip_v = false

		
	elif mouse_pos < global_position: 
		sprite_2d.flip_h = true
		hammerHitbox.rotation = -160.0
		hammer_sprite_2d.flip_v = true
		
func shoot_arrow():
	var arrow = ArrowScene.instantiate()
	arrow_container.add_child(arrow)

	arrow.global_position = global_position
	
	var direction = (get_global_mouse_position() - global_position).normalized()
	arrow.launch(direction * 450, direction.angle())
	
func hammerAttack():

	var mouse_pos:= get_global_mouse_position()
	var hammer_visual = hammer_sprite_2d

	hammer_visual.play("sworb")
	sword_collision.disabled = false

	await get_tree().create_timer(0.15).timeout

	sword_collision.disabled = true

func placeWall():
	print("placed wall")
	var direction = (get_global_mouse_position() - global_position).normalized()
	var wall = wallScene.instantiate()
	arrow_container.add_child(wall)
	direction.y = 0
	var offset = 80
	#wall.global_position.y = -100
	if direction.x > 0:
		wall.global_position = Vector2(global_position.x + offset, 800)
	else:
		wall.global_position = Vector2(global_position.x + (offset * -1), 800)

	





func level_complete():
	get_tree().change_scene_to_file(next_level)
