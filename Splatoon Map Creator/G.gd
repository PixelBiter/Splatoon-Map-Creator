extends Node

var ayer = 1.21
var CamPosition
var CamRot = 0

var ETileList = [[0,5],[6,11],[12,15],[16,29],[30,43],[44,47],[48,53],[54,59],[60,63],[64,69],[70,75],[76,79],[80,88],[89,93],[94,98],[99,105],[106,113]]
var ETileType = [0,0]
var ETileOrient = 0
var EPosition = [0,0]
var EPositionLayer = 0
var ELayerAmount = 25
var ELayerLen = 0.6
var ELayerStart = 5.39
var ELayerCurrent = 5.49
var UsedCells = {
	"Pos1":[],
	"Pos2":[],
	"Pos3":[],
	"Type":[],
	"Ori":[]
}
var Grid = []

var Controller = false
var CamLock = [false,null,null]
