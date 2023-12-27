extends Node3D

func _ready():
	$Lights/Lights.visible = true
	for i in range(10):
		var Layer = load("res://layer.tscn")
		var instance = Layer.instantiate()
		add_child(instance)
		G.ayer -= 0.6
