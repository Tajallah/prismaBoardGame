extends GridContainer

const MAX_X = 19
const MAX_Y = 19

@onready var boardTilePrototype = get_node("../boardTile")
@onready var gameBoardSimulationLayer = get_node("../gameBoardSimulationLayer")

func setUpBoard():
	for x in range(MAX_X):
		for y in range(MAX_Y):
			var newTile = boardTilePrototype.duplicate()
			newTile.setCoords(x, y)
			self.add_child(newTile)
	print("Set up board")

# Called when the node enters the scene tree for the first time.
func _ready():
	setUpBoard()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delta:
		pass # makes the linting tool happy
	for child in get_children():
		child.updateBasedOnGameBoard()
