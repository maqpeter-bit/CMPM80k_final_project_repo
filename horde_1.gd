extends CharacterBody2D

@export var ladder_scene: PackedScene
const SPEED = 90.0
const JUMP_VELOCITY = -400.0
var player: CharacterBody2D
var jumpTimer:= 0.0
var health = 1.0
var player_in_hitbox = null
var damage_timer = 0.0


func _ready():
	player = get_tree().get_first_node_in_group("player")
	reset_jump_timer()
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	$Hitbox.body_exited.connect(_on_hitbox_body_exited)
	
func _on_hitbox_body_exited(body):
	if body == player_in_hitbox:
		player_in_hitbox = null
		

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		#body.take_damage(1)
		player_in_hitbox = body

		
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	jumpTimer -= delta
	if jumpTimer <= 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		reset_jump_timer()
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * SPEED
	
	if damage_timer > 0:
		damage_timer -= delta

	if player_in_hitbox:
		if damage_timer <= 0:
			player_in_hitbox.take_damage(1)
			damage_timer = 1.0
	move_and_slide()
	
	
	
func reset_jump_timer():
	jumpTimer = randf_range(1.0, 4.0)

func getHurt():
	var hurtSound = AudioStreamPlayer2D.new()
	get_parent().add_child(hurtSound)
	hurtSound.stream = preload("res://sounds/HORDEhurt.wav")
	hurtSound.global_position = global_position
	hurtSound.play()
	health -= 1
	if (health < 1):
		var ladder = ladder_scene.instantiate()
		get_parent().add_child(ladder)
		$CollisionShape2D.set_deferred("disabled", true)

		ladder.global_position = global_position
		queue_free()
