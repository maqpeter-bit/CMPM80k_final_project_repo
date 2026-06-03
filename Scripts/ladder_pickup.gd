extends RigidBody2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var controller = get_tree().get_first_node_in_group("LevelController")
		var pickupSound = AudioStreamPlayer2D.new()
		get_parent().add_child(pickupSound)
		pickupSound.stream = preload("res://sounds/collectItem.wav")
		pickupSound.global_position = global_position
		pickupSound.play()
		controller.add_ladder()
		queue_free()
