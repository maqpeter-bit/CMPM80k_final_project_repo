extends RigidBody2D
var health = 5
var timer = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hitbox.area_entered.connect(_on_hurtbox_area_entered)
	pass # Replace with function body.
func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemies"):
		health -= 1
		if health < 1:
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer < 1:
		queue_free()
	pass
