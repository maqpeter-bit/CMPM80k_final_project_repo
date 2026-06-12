extends CharacterBody2D

@export var animator: AnimatedSprite2D
@export var ladder_scene: PackedScene
const SPEED = 100.0
const JUMP_VELOCITY = -450.0
var player: CharacterBody2D
var jumpTimer:= 0.0
var health = 2.0
var maxHealth = 2.0
var player_in_hitbox = null # Only used for extra stuff. Ignore this
var isTouchingPlayer = false
var wall_in_hitbox = null
var isTouchingWall = false
var damage_timer = 0.0
var knockback = Vector2.ZERO
@export var ladderDropChance := 10.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	reset_jump_timer()
	$Hitbox.area_entered.connect(_on_hurtbox_area_entered)
	$Hitbox.area_exited.connect(_on_hurtbox_area_exited)
	var random_int = randi_range(1, 5)
	match random_int:
		1: 
			animator.play("CYAN")
		2:
			animator.play("GREEN")
		3:
			animator.play("MAGENTA")
		4:
			animator.play("ORANGE")
		5:
			animator.play("PURPLE")



	
func _on_hurtbox_area_entered(area):
	if area.is_in_group("player"):
		player_in_hitbox = area
		isTouchingPlayer = true
		
	if area.is_in_group("sword"):
		getHurt()
		var knockback_strength = 1750.0
		var direction = global_position.direction_to(area.global_position)
		direction.y = 0
		var explosion_force = direction * knockback_strength
		knockback = explosion_force * -1
		
	if area.is_in_group("arrow"):
		getHurt()
		var arrow = area.get_parent()
		arrow.destroy()
	if area.is_in_group("trap"):
		getHurt()
	
	if area.is_in_group("wall"):
		isTouchingWall = true
		wall_in_hitbox = area
		
	if area.is_in_group("fan"):
		var knockback_strength = 1500.0
		var direction = global_position.direction_to(area.global_position)
		direction.y = 0
		var explosion_force = direction * knockback_strength
		knockback = explosion_force * -1
		

func _on_hurtbox_area_exited(area):
	if area == player_in_hitbox:
		player_in_hitbox = null
		if isTouchingPlayer:
			isTouchingPlayer = false
			
	if area == wall_in_hitbox:
		wall_in_hitbox = null
		if isTouchingWall:
			isTouchingWall = false


		
		
func _physics_process(delta: float) -> void:
	knockback = lerp(knockback, Vector2.ZERO, 0.0001)



	
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

	velocity += knockback
	
	if damage_timer > 0:
		damage_timer -= delta
	
	if isTouchingWall:
		if damage_timer <= 0:
			var wall= wall_in_hitbox.get_parent()
			wall.wallTakeDamage(1)
			damage_timer = 1.0
	
	if isTouchingPlayer:
		if damage_timer <= 0:
			var player = player_in_hitbox.get_parent()
			player.take_damage(1)
			damage_timer = 1.0
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 8.0 * delta)
	
	
func reset_jump_timer():
	jumpTimer = randf_range(1.0, 4.0)

func getHurt():
	health -= 1
	var hurtSound = AudioStreamPlayer2D.new()
	get_parent().add_child(hurtSound)
	hurtSound.stream = preload("res://sounds/HORDEhurt.wav")
	hurtSound.global_position = global_position
	hurtSound.play()
	if health < 1:
		call_deferred("_die")

func _die():
	if randf() * 100.0 < ladderDropChance:
		var ladder = ladder_scene.instantiate()
		get_parent().add_child(ladder)
		ladder.global_position = global_position

	queue_free()
