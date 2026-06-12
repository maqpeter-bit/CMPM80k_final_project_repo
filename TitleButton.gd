extends Button

func _pressed():
	var scene = get_tree().root.get_child(-1)

	if scene.name == "Title":
		get_tree().change_scene_to_file("res://Tutorial1.tscn")
	elif scene.name == "Tutorial1":
		get_tree().change_scene_to_file("res://level1.tscn")
	elif scene.name == "Tutorial2":
		get_tree().change_scene_to_file("res://level2.tscn")
	elif scene.name == "Tutorial3":
		get_tree().change_scene_to_file("res://level3.tscn")
	elif scene.name == "Tutorial4":
		get_tree().change_scene_to_file("res://level4.tscn")
	elif scene.name == "Tutorial5":
		get_tree().change_scene_to_file("res://level5.tscn")
	elif scene.name == "Tutorial6":
		get_tree().change_scene_to_file("res://level6.tscn")
	elif scene.name == "Tutorial7":
		get_tree().change_scene_to_file("res://level7.tscn")
	elif scene.name == "Tutorial8":
		get_tree().change_scene_to_file("res://level8.tscn")
	elif scene.name == "Tutorial9":
		get_tree().change_scene_to_file("res://level9.tscn")
	elif scene.name == "Tutorial10":
		get_tree().change_scene_to_file("res://level10.tscn")
	elif scene.name == "FINISH":
		get_tree().change_scene_to_file("res://Title.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
