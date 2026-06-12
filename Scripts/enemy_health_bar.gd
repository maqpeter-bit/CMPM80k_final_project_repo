extends ProgressBar
@export var enemy: CharacterBody2D
@export var healthBar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	healthBar.max_value = enemy.maxHealth
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = enemy.health
	visible = enemy.health < enemy.maxHealth
	pass
