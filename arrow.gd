extends Area2D
@export var mass = 0.5
var launched = false
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.getHurt()
		queue_free()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if launched:
		velocity += gravity_direction*gravity*mass
		position += velocity*delta
		rotation = velocity.angle()

# Sets initial velocity and enables change in position and rotation		
func launch(initial_velocity : Vector2, startRotation : float):
	rotation = startRotation
	launched = true
	velocity = initial_velocity * 2
	
