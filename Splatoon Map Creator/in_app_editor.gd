extends Node3D
var UIHelp = load("res://EditorResources/MapEditor.tres")
var yrot = 0
var No = false
func _ready():
	if FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.READ) != null:
		G.Grid = FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.READ)
		G.UsedCells = JSON.parse_string(G.Grid.get_as_text())
		while No == false:
			No = true
			for i in range(len(G.UsedCells["Pos1"])):
				if $BuiltMap.get_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i])) != -1:
					_deletecell(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i])
					No = false
					break
				$BuiltMap.set_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i]),G.UsedCells["Type"][i],G.UsedCells["Ori"][i])
				$CopyMap.set_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i]),G.UsedCells["Type"][i],G.UsedCells["Ori"][i])
			if No == false:
				$BuiltMap.clear()
	G.ELayerCurrent = G.ELayerStart
	for i in range(G.ELayerAmount):
		var Layer = load("res://layer.tscn")
		var instance = Layer.instantiate()
		add_child(instance)
		G.ELayerCurrent -= G.ELayerLen

func _process(delta):
	_Stuff()
	_inputs()
	
func _Stuff():
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
	if float($Selector/Cams/Camera/UI/UIFlat/FOV.text) < 179:
		$Selector/Cams/Camera.fov = float($Selector/Cams/Camera/UI/UIFlat/FOV.text)
	else:
		$Selector/Cams/Camera/UI/UIFlat/FOV.text = "90"
	$Selector/Cams/Camera.size = float($Selector/Cams/Camera/UI/UIFlat/Zoom.text)
	if G.CamLock[0] == true:
		$Selector/Cams.global_position = G.CamLock[2]
		$Selector/Cams/Camera.global_position = G.CamLock[1]
	$CopyMap.global_position = Vector3(float($Selector/Cams/Camera/UI/UIFlat/Map2Controls/X.text),float($Selector/Cams/Camera/UI/UIFlat/Map2Controls/Y.text),float($Selector/Cams/Camera/UI/UIFlat/Map2Controls/Z.text))

func _inputs():
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
			if $BuiltMap.get_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1])) != -1:
				_deletecell(G.EPosition[0],G.EPositionLayer,G.EPosition[1])
			$BuiltMap.set_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1]),G.ETileType[1],G.ETileOrient)
			$CopyMap.set_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1]),G.ETileType[1],G.ETileOrient)
			G.UsedCells.Pos1 += [G.EPosition[0]]
			G.UsedCells.Pos2 +=[G.EPositionLayer]
			G.UsedCells.Pos3 +=[G.EPosition[1]]
			G.UsedCells.Type += [G.ETileType[1]]
			G.UsedCells.Ori += [G.ETileOrient]
		if Input.is_action_just_pressed("BlockD"):
			_deletecell(G.EPosition[0],G.EPositionLayer,G.EPosition[1])

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
	
	if Input.is_action_just_pressed("CamLock"):
		if G.CamLock[0] == false:
			G.CamLock[1] = $Selector/Cams/Camera.global_position
			G.CamLock[2] = $Selector/Cams.global_position
			G.CamLock[0] = true
		else:
			G.CamLock[0] = false

	if G.Controller == false or (G.Controller == true and $Selector.visible == true):
		if Input.is_action_just_pressed("Save"):
			G.Grid = FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.WRITE)
			G.Grid.store_line(JSON.stringify(G.UsedCells))
			$BuiltMap.clear()
			G.Grid = FileAccess.open("res://EditorResources/MapFiles/Current.txt", FileAccess.READ)
			G.UsedCells = JSON.parse_string(G.Grid.get_as_text())
			for i in range(len(G.UsedCells["Pos1"])):
				$BuiltMap.set_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i]),G.UsedCells["Type"][i],G.UsedCells["Ori"][i])
				$CopyMap.set_cell_item(Vector3i(G.UsedCells.Pos1[i],G.UsedCells.Pos2[i],G.UsedCells.Pos3[i]),G.UsedCells["Type"][i],G.UsedCells["Ori"][i])


func _deletecell(Position0,Layer,Position1):
	for i in range(len(G.UsedCells.Pos1)):
		if G.UsedCells.Pos1[i] == Position0 and G.UsedCells.Pos2[i] == Layer and G.UsedCells.Pos3[i] == Position1:
			G.UsedCells.Pos1.remove_at(i)
			G.UsedCells.Pos2.remove_at(i)
			G.UsedCells.Pos3.remove_at(i)
			G.UsedCells.Type.remove_at(i)
			G.UsedCells.Ori.remove_at(i)
			break
	$BuiltMap.set_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1]),-1,G.ETileOrient)
	$CopyMap.set_cell_item(Vector3i(G.EPosition[0],G.EPositionLayer,G.EPosition[1]),-1,G.ETileOrient)


func _on_option_button_item_selected(index):
	G.ETileType[0] = $Selector/Cams/Camera/UI/UIFlat/OptionButton.selected
	G.ETileType[1] = G.ETileList[G.ETileType[0]][0]


func _on_check_button_toggled(button_pressed):
	if G.Controller == false:
		G.Controller = true
		$Selector/Cams/Camera/UI/UIFlat/Label.text = "Editor Controls: \nMove Selector - Left Stick \nChange Floor - Right Stick Up/Down \nPlace - A \nDelete - B \nSave - + (PLUS) \nChange Direction - ZL/ZR \nChange Block - L/R \nChange Group - X/Y \n \nCamera Controls: \nMovement - Left Stick \nCamera Change - Left Stick Press \nToggle Movement - - (MINUS) \nCamera Lock - Right Stick Press"
	else:
		G.Controller = false
		$Selector/Cams/Camera/UI/UIFlat/Label.text = "Editor Controls: \nMove Selector - ARROWS \nChange Floor - PAGE UP/DOWN \nPlace - SPACE/CTRL \nDelete - ALT \nSave - Enter \nChange Direction - V/B \nChange Block - C/N \nChange Group - X/M \n \nCamera Controls: \nMovement - WASD \nMouse Capture - SHIFT \nCamera Change - TAB \nToggle HUD + Lights - COMMA \nCamera Lock - QUOTE LEFT"

func _on_enabled_toggled(button_pressed):
	if $CopyMap.visible == false:
		$CopyMap.visible = true
	else:
		$CopyMap.visible = false

func _on_flipped_x_toggled(button_pressed):
	if $CopyMap.scale.x == 1:
		$CopyMap.scale.x = -1
	else:
		$CopyMap.scale.x = 1

func _on_flipped_z_toggled(button_pressed):
	if $CopyMap.scale.z == 1:
		$CopyMap.scale.z = -1
	else:
		$CopyMap.scale.z = 1
