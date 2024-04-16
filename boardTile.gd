extends Button

@onready var gameBoardSimulationLayer = get_node("../../gameBoardSimulationLayer")
@onready var gameState = get_node("../..")
@onready var selfStoneVisual = get_node("prototypeStone")

@onready var hoveringEmpty = false
@onready var hoverColor = Color(1, 1, 1, 1)
@onready var hoverColorChange = Color(0.01, 0.01, 0.01, 0.0)

var selfX = -1
var selfY = -1

@onready var filled = false

@onready var debug:bool = false

func setCoords (x, y):
	selfX = x
	selfY = y

func attemptPlaceStone(color:String) -> bool:
	if gameBoardSimulationLayer.placeStone(color, selfX, selfY):
		selfStoneVisual.visible = true
		selfStoneVisual.setSelfState(color)
		filled = true
		return true
	return false

func removeStone():
	gameBoardSimulationLayer.removeStone(selfX, selfY)
	selfStoneVisual.visible = false
	filled = false

func updateBasedOnGameBoard():
	var stone = gameBoardSimulationLayer.getStone(selfX, selfY)
	if stone != "-":
		selfStoneVisual.visible = true
		selfStoneVisual.setSelfState(stone)
		filled = true
	else:
		selfStoneVisual.visible = false
		filled = false

func testPlaceStone():
	if gameBoardSimulationLayer.placeStone(selfX, selfY, "W"):
		selfStoneVisual.visible = true
		selfStoneVisual.setSelfState("W")
		filled = true

func cycleColor(): #cause the button to changerainbow colors while being hovered
	if hoverColor[0] <= 0.0:
		self.hoverColor = Color(0,0,0,1)
		hoverColorChange = Color(0.01, 0.01, 0.01, 0.0)
	elif hoverColor[0] >= 1.0:
		self.hoverColor = Color(1,1,1,1)
		hoverColorChange = Color(-0.01, -0.01, -0.01, 0.0)
	hoverColor += hoverColorChange

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hoveringEmpty and filled == true:
		cycleColor()

func _on_focus_entered():
	hoveringEmpty = true
	self.modulate = hoverColor

func _on_focus_exited():
	hoveringEmpty = false
	self.modulate = Color(1, 1, 1, 1)

func _on_pressed():
	if filled == false and (gameState.turnPlayer == "Player" or gameState.hotseat == true):
		attemptPlaceStone(gameState.cursorStoneColor)
