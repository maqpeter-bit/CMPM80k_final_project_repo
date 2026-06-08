extends ProgressBar
@export var enemy: CharacterBody2D
@export var healthBar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.max_value = enemy.maxHealth
	healthBar.value = enemy.health
	visible = enemy.health < enemy.maxHealth
	pass
