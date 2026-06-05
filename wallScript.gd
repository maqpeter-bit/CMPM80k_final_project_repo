extends Node2D
var health = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func wallTakeDamage(amount: int):
	health -= amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.y > 650:
		print(global_position.y)
		global_position.y -= 1000 * delta
	else:
		global_position.y = 630
		if global_position.y < 0:
			global_position.y = 0
	
	if health < 1:
		queue_free()
	pass
