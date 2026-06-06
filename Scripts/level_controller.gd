extends Node2D

@export var enemy_queue: Array[PackedScene]
@export var spawn_interval := 1.0
@export var pipes: Array[Node2D]
@export var ladder_builder: Node2D

var bag: Array[PackedScene] = [] # This functions as a tetris bag
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
			refill_bag()

		var enemy_scene = bag.pop_back()
		spawn_enemy(enemy_scene)

		await get_tree().create_timer(spawn_interval).timeout

func spawn_enemy(enemy_scene: PackedScene):
	var enemy = enemy_scene.instantiate()
	var pipe = pipes.pick_random()

	get_parent().add_child(enemy)
	enemy.global_position = pipe.global_position

	if pipe == pipes[0]:
		enemy.scale.x = abs(enemy.scale.x)
	else:
		enemy.scale.x = -abs(enemy.scale.x)
