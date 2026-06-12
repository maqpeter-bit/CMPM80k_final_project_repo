extends Node2D
var timer = 15
@onready var blowingSound: AudioStreamPlayer2D = $BlowingSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blowingSound.play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer < 1:
		queue_free()
	pass
