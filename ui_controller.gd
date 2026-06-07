extends Node2D

@export var player: Player
@export var healthBar: ProgressBar
@export var Utility1Icon: Sprite2D
@export var Utility2Icon: Sprite2D

@export var Utility1Bar: ProgressBar
@export var Utility2Bar: ProgressBar

@export var selectItemVisual: AnimatedSprite2D

@export var UtilityBowTexture: Texture
@export var UtilityHammerTexture: Texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = player.playerHealth * 100 / player.maxPlayerHealth

	Utility1Bar.max_value = player.Utility1MAXCooldown
	Utility2Bar.max_value = player.Utility2MAXCooldown
	Utility1Bar.value = player.Utility1Cooldown
	Utility2Bar.value = player.Utility2Cooldown
	
	if player.UTIL_SELECTED_ITEM_1 == "bow":
		Utility1Icon.texture = UtilityBowTexture
	elif player.UTIL_SELECTED_ITEM_1 == "hammer":
		Utility1Icon.texture = UtilityHammerTexture
		
	if player.utilitySwap1or2 == 1:
		selectItemVisual.position.y = 84.0
	else:
		selectItemVisual.position.y = 157.0
	pass
