extends Node2D

@export var enemy_queue: Array[EnemySpawnData]
@export var spawn_intervalMin := 1.0
@export var spawn_intervalMax := 3.0

@export var bagRefillTime := 5.0
@export var pipes: Array[Node2D]
@export var ladder_builder: Node2D

#var bag: Array[PackedScene] = [] # This functions as a tetris bag
var bag: Array[EnemySpawnData] = []
var ladder_count := 0

# In the future I intend to add a thing such that the intensity at which
# enemies appear increases as the player is longer in the level. This
# could make for some interesting variants of levels maybe? Trying to 
# approach this at a slight puzzle sense. 

func _ready() -> void:
	add_to_group("LevelController")
	call_deferred("start_wave")

func add_ladder():
	ladder_count += 1
	if ladder_builder:
		ladder_builder.add_ladder_piece()
	print("Ladders:", ladder_count)

func refill_bag():
	bag = enemy_queue.duplicate()
	bag.shuffle()

func start_wave():
	refill_bag()

	while true:
		if bag.is_empty():
			await get_tree().create_timer(bagRefillTime).timeout
			refill_bag()

		var enemy_data = bag.pop_back()
		spawn_enemy(enemy_data)
		
		var waitTimeBetweenEnemySpawn = randi_range(spawn_intervalMin, spawn_intervalMax)
		await get_tree().create_timer(waitTimeBetweenEnemySpawn).timeout

func spawn_enemy(enemy_data: EnemySpawnData):
	var enemy = enemy_data.enemy_scene.instantiate()
	var pipe = pipes.pick_random()

	get_parent().add_child(enemy)
	enemy.global_position = pipe.global_position

	enemy.ladderDropChance = enemy_data.ladder_drop_chance

	if pipe == pipes[0]:
		enemy.scale.x = abs(enemy.scale.x)
	else:
		enemy.scale.x = -abs(enemy.scale.x)
