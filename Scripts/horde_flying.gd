extends CharacterBody2D

@export var ladder_scene: PackedScene
@export var ladderDropChance := 10.0

const SPEED = 90.0

@export var fly_amplitude := 20.0
@export var fly_speed := 2.0

@export var attack_range := 100.0
@export var dive_offset := 40.0      # How far above the player to hover
@export var hover_move_speed := 100.0

var player: CharacterBody2D
var health = 2.0
var maxHealth = 2.0
var player_in_hitbox = null
var isTouchingPlayer = false
var wall_in_hitbox = null
var isTouchingWall = false
var damage_timer = 0.0
var knockback = Vector2.ZERO

var fly_time = 0.0
var hover_y = 100.0
var current_hover_y = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

	hover_y = global_position.y + randi_range(350, 500)
	current_hover_y = hover_y
	fly_time = randf_range(0.0, TAU)

	$Hitbox.area_entered.connect(_on_hurtbox_area_entered)
	$Hitbox.area_exited.connect(_on_hurtbox_area_exited)

func _on_hurtbox_area_entered(area):
	if area.is_in_group("player"):
		player_in_hitbox = area
		isTouchingPlayer = true

	if area.is_in_group("sword"):
		getHurt()
		var knockback_strength = 1500.0
		var direction = global_position.direction_to(area.global_position)
		direction.y = 0
		knockback = -direction * knockback_strength

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
		knockback = -direction * knockback_strength

func _on_hurtbox_area_exited(area):
	if area == player_in_hitbox:
		player_in_hitbox = null
		isTouchingPlayer = false

	if area == wall_in_hitbox:
		wall_in_hitbox = null
		isTouchingWall = false

func _physics_process(delta):

	# Horizontal movement
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * SPEED

		var distance_x = abs(player.global_position.x - global_position.x)

		# Default hover height
		var target_hover_y = hover_y

		# Lower hover height if player is underneath
		if distance_x < attack_range and player.global_position.y > global_position.y:
			target_hover_y = player.global_position.y - dive_offset

		# Smoothly move the center of the sine wave
		current_hover_y = move_toward(
			current_hover_y,
			target_hover_y,
			hover_move_speed * delta
		)

		# Continue sine wave movement
		fly_time += delta
		var target_y = current_hover_y + sin(fly_time * fly_speed) * fly_amplitude

		velocity.y = (target_y - global_position.y) * 5.0

	# Apply knockback
	velocity += knockback

	if damage_timer > 0:
		damage_timer -= delta

	if isTouchingWall and damage_timer <= 0:
		var wall = wall_in_hitbox.get_parent()
		wall.wallTakeDamage(1)
		damage_timer = 1.0

	if isTouchingPlayer and damage_timer <= 0:
		var hit_player = player_in_hitbox.get_parent()
		hit_player.take_damage(1)
		damage_timer = 1.0

	move_and_slide()

	# Smoothly reduce knockback
	knockback = knockback.lerp(Vector2.ZERO, 8.0 * delta)

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
