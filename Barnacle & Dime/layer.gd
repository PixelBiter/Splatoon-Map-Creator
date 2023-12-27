extends Sprite3D

func _ready():
	position.y = G.ayer

func _process(delta):
	if G.CamPosition < position.y + 0.3 and G.CamPosition > position.y - 0.3:
		visible = false
	else:
		visible = true
