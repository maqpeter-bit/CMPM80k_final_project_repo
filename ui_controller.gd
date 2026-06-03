extends Node2D

@export var player: Player
@export var healthBar: ProgressBar
@export var Utility1Icon: Sprite2D
@export var Utility2Icon: Sprite2D

@export var Utility1Bar: ProgressBar
@export var Utility2Bar: ProgressBar

@export var UtilityBowTexture: Texture
@export var UtilityHammerTexture: Texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = player.playerHealth * 100 / player.maxPlayerHealth

	Utility1Bar.max_value = player.Utility1MAXCooldown
	Utility1Bar.value = player.Utility1Cooldown
	Utility2Bar.value = player.Utility2Cooldown
	
	print(
		"Cooldown=", player.Utility1Cooldown,
		" Max=", player.Utility1MAXCooldown,
		" BarValue=", Utility1Bar.value,
		" BarMax=", Utility1Bar.max_value
	)
	if player.UTIL_SELECTED_ITEM_1 == "bow":
		Utility1Icon.texture = UtilityBowTexture
	else:
		Utility1Icon.texture = UtilityHammerTexture
	pass
