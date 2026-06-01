extends Node2D
@export var enemy_queue: Array[PackedScene]
@export var spawn_interval := 1.0
@export var pipes: Array[Node2D]
@export var ladder_builder: Node2D
# Called when the node enters the scene tree for the first time.

var ladder_count := 0
var current_index := 0
func _ready() -> void:
	add_to_group("LevelController")
	call_deferred("start_wave")	
	
func add_ladder():
	ladder_count += 1
	if ladder_builder:
		ladder_builder.add_ladder_piece()
	print("Ladders:", ladder_count)
	

func start_wave():
	while current_index < enemy_queue.size():
		spawn_enemy(enemy_queue[current_index])
		await get_tree().create_timer(spawn_interval).timeout
		current_index += 1


func spawn_enemy(enemy_scene: PackedScene):
	var enemy = enemy_scene.instantiate()
	var pipe = pipes.pick_random()
	get_parent().add_child(enemy)
	
	enemy.global_position = pipe.global_position
	
	if pipe == pipes[0]:
		enemy.scale.x = abs(enemy.scale.x)
	else:
		enemy.scale.x = -abs(enemy.scale.x)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
