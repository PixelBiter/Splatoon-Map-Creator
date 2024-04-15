extends Node3D
var UIHelp = load("res://EditorResources/MapEditor.tres")
var yrot = 0
func _ready():
	
	if FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.READ) != null:
		G.Grid = FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.READ)
		G.UsedCells = JSON.parse_string(G.Grid.get_as_text())
		for i in range(len(G.UsedCells["Pos1"])):
			$BuiltMap.set_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i]),G.UsedCells["Type"][i],G.UsedCells["Ori"][i])
	G.ELayerCurrent = G.ELayerStart
	for i in range(G.ELayerAmount):
		var Layer = load("res://layer.tscn")
		var instance = Layer.instantiate()
		add_child(instance)
		G.ELayerCurrent -= G.ELayerLen

func _process(delta):
	$Selector.position = Vector3((G.EPosition[0]*0.3)+0.15,(G.EPositionLayer*0.3)+0.05,(G.EPosition[1]*0.3)+0.15)
	$Selector/Cams/Camera/UI/UIBlock.mesh = UIHelp.get_item_mesh(G.ETileType[1])
	if G.ETileType[1]+1 > G.ETileList[G.ETileType[0]][1]:
		$Selector/Cams/Camera/UI/UIBlock3.mesh = UIHelp.get_item_mesh(G.ETileList[G.ETileType[0]][0])
	else:
		$Selector/Cams/Camera/UI/UIBlock3.mesh = UIHelp.get_item_mesh(G.ETileType[1]+1)
	if G.ETileType[1]-1 < G.ETileList[G.ETileType[0]][0]:
		$Selector/Cams/Camera/UI/UIBlock2.mesh = UIHelp.get_item_mesh(G.ETileList[G.ETileType[0]][1])
	else:
		$Selector/Cams/Camera/UI/UIBlock2.mesh = UIHelp.get_item_mesh(G.ETileType[1]-1)
	$Selector/Cams/Camera/UI/UIBlock.global_rotation_degrees = Vector3(0,yrot,0)
	
	

func _input(event):
	if G.Controller == false or (G.Controller == true and $Selector.visible == true):
		if Input.is_action_just_pressed("EorientA"):
			yrot -= 90
			if G.ETileOrient == 0: #base
				G.ETileOrient = 22
			elif G.ETileOrient == 10:#3rd
				G.ETileOrient = 16
			elif G.ETileOrient == 22: #2nd
				G.ETileOrient = 10
			else:
				G.ETileOrient = 0#4th
		if Input.is_action_just_pressed("EOrient"):
			yrot += 90
			if G.ETileOrient == 22:
				G.ETileOrient = 0
			elif G.ETileOrient == 16:
				G.ETileOrient = 10
			elif G.ETileOrient == 10:
				G.ETileOrient = 22
			else:
				G.ETileOrient = 16
		if Input.is_action_just_pressed("EChange-"):
			G.ETileType[0] -= 1
			if G.ETileType[0] < 0:
				G.ETileType[0] = len(G.ETileList)-1
			G.ETileType[1] = G.ETileList[G.ETileType[0]][0]
			$Selector/Cams/Camera/UI/UIFlat/OptionButton.selected = G.ETileType[0]
		if Input.is_action_just_pressed("EChange+"):
			G.ETileType[0] += 1
			if G.ETileType[0] > len(G.ETileList) -1:
				G.ETileType[0] = 0
			G.ETileType[1] = G.ETileList[G.ETileType[0]][0]
			$Selector/Cams/Camera/UI/UIFlat/OptionButton.selected = G.ETileType[0]

	if G.Controller == false or (G.Controller == true and $Selector.visible == true):
		if G.CamRot > -1 and G.CamRot < 1:
			if Input.is_action_just_pressed("EUp"):
				G.EPosition[1] -= 1
			if Input.is_action_just_pressed("EDown"):
				G.EPosition[1] += 1
			if Input.is_action_just_pressed("ERight"):
				G.EPosition[0] += 1
			if Input.is_action_just_pressed("ELeft"):
				G.EPosition[0] -= 1
		elif G.CamRot > 1 and G.CamRot < 2:
			if Input.is_action_just_pressed("EUp"):
				G.EPosition[0] -= 1
			if Input.is_action_just_pressed("EDown"):
				G.EPosition[0] += 1
			if Input.is_action_just_pressed("ERight"):
				G.EPosition[1] -= 1
			if Input.is_action_just_pressed("ELeft"):
				G.EPosition[1] += 1
		elif G.CamRot > -2 and G.CamRot < -1:
			if Input.is_action_just_pressed("EUp"):
				G.EPosition[0] += 1
			if Input.is_action_just_pressed("EDown"):
				G.EPosition[0] -= 1
			if Input.is_action_just_pressed("ERight"):
				G.EPosition[1] += 1
			if Input.is_action_just_pressed("ELeft"):
				G.EPosition[1] -= 1
		else:
			if Input.is_action_just_pressed("EUp"):
				G.EPosition[1] += 1
			if Input.is_action_just_pressed("EDown"):
				G.EPosition[1] -= 1
			if Input.is_action_just_pressed("ERight"):
				G.EPosition[0] -= 1
			if Input.is_action_just_pressed("ELeft"):
				G.EPosition[0] += 1
		if Input.is_action_just_pressed("ELayerUp"):
			G.EPositionLayer += 1
		if Input.is_action_just_pressed("ELayerD"):
			G.EPositionLayer -= 1

	if G.Controller == false or (G.Controller == true and $Selector.visible == true):
		if Input.is_action_just_pressed("BlockL"):
			G.ETileType[1] -= 1
			if G.ETileType[1] < G.ETileList[G.ETileType[0]][0]:
				G.ETileType[1] = G.ETileList[G.ETileType[0]][1]
		if Input.is_action_just_pressed("BlockR"):
			G.ETileType[1] += 1
			if G.ETileType[1] > G.ETileList[G.ETileType[0]][1]:
				G.ETileType[1] = G.ETileList[G.ETileType[0]][0]

		if Input.is_action_just_pressed("BlockP"):
			$BuiltMap.set_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1]),G.ETileType[1],G.ETileOrient)
			G.UsedCells.Pos1 += [G.EPosition[0]]
			G.UsedCells.Pos2 +=[G.EPositionLayer]
			G.UsedCells.Pos3 +=[G.EPosition[1]]
			G.UsedCells.Type += [G.ETileType[1]]
			G.UsedCells.Ori += [G.ETileOrient]
		if Input.is_action_just_pressed("BlockD"):
			_deletecell()
			$BuiltMap.set_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1]),-1,G.ETileOrient)

	if Input.is_action_just_pressed("LightToggle"):
		if $"Lights/Editor Lights".visible == true:
			$"Lights/Editor Lights".visible = false
			$Lights/Lights.visible = true
			$Selector/Cams/Camera/UI.visible = false
			$Selector/Cams/Camera/UI/UIFlat.visible = false
			$Selector.visible = false
		else:
			$"Lights/Editor Lights".visible = true
			$Lights/Lights.visible = false
			$Selector/Cams/Camera/UI.visible = true
			$Selector/Cams/Camera/UI/UIFlat.visible = true
			$Selector.visible = true

	if G.Controller == false or (G.Controller == true and $Selector.visible == true):
		if Input.is_action_just_pressed("Save"):
			G.Grid = FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.WRITE)
			G.Grid.store_line(JSON.stringify(G.UsedCells))
			$BuiltMap.clear()
			G.Grid = FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.READ)
			G.UsedCells = JSON.parse_string(G.Grid.get_as_text())
			for i in range(len(G.UsedCells["Pos1"])):
				$BuiltMap.set_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i]),G.UsedCells["Type"][i],G.UsedCells["Ori"][i])
	if Input.is_action_just_pressed("ControllerToggle"):
		G.Controller = true


func _deletecell():
	for i in range(len(G.UsedCells.Pos1)):
		if G.UsedCells.Pos1[i] == G.EPosition[0] and G.UsedCells.Pos2[i] == G.EPositionLayer and G.UsedCells.Pos3[i] == G.EPosition[1]:
			G.UsedCells.Pos1.remove_at(i)
			G.UsedCells.Pos2.remove_at(i)
			G.UsedCells.Pos3.remove_at(i)
			G.UsedCells.Type.remove_at(i)
			G.UsedCells.Ori.remove_at(i)
			break


func _on_option_button_item_selected(index):
	G.ETileType[0] = $Selector/Cams/Camera/UI/UIFlat/OptionButton.selected
	G.ETileType[1] = G.ETileList[G.ETileType[0]][0]
