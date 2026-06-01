extends RigidBody2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var controller = get_tree().get_first_node_in_group("LevelController")

		controller.add_ladder()
		queue_free()
