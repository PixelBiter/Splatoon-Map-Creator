extends Node3D

func _ready():
	$Lights/Lights.visible = true
	for i in range(12):
		var Layer = load("res://layer.tscn")
		var instance = Layer.instantiate()
		add_child(instance)
