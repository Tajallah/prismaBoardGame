extends MeshInstance2D

const RED_COLOR = Color(1, 0.2, 0.2, 1) #pastel red
const GREEN_COLOR = Color(0.2, 1, 0.2, 1) #pastel green
const BLUE_COLOR = Color(0.2, 0.2, 1, 1) #pastel blue
const YELLOW_COLOR = Color(1, 1, 0.2, 1) #pastel yellow
const WHITE_COLOR = Color(1, 1, 1, 1) #white
const BLACK_COLOR = Color(0, 0, 0, 1) #black
const INERT_COLOR = Color(0, 0, 0, 1) #grey purple

@onready var colorMap = {
	"R": RED_COLOR,
	"G": GREEN_COLOR,
	"B": BLUE_COLOR,
	"Y": YELLOW_COLOR,
	"W": WHITE_COLOR,
	"X": BLACK_COLOR,
	"I": INERT_COLOR
}

@onready var selfState = "X"

func setSelfState(state):
	selfState = state
	self.modulate = colorMap[state]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
