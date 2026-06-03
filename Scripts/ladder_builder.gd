extends Node2D
@export var ladder_piece_scene: PackedScene
@export var piece_height := 22.5
@export var ladder_container: Node


var ladder_count := 0

func add_ladder_piece():
	var piece = ladder_piece_scene.instantiate()
	ladder_container.add_child(piece)
	
	piece.position = Vector2(0, -ladder_count * piece_height)
	ladder_count += 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ClimbTrigger.body_entered.connect(_on_climb_trigger_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_climb_trigger_body_entered(body):
	if body.is_in_group("player"):
		var controller = get_tree().get_first_node_in_group("LevelController")

		if controller.ladder_count >= 7:
			body.start_ladder_climb(0)
