extends Button

@export var colorName = "R"
@export var displayColorName = "RED"
@export var amnt = 10

@onready var topLevel = get_node("/testing")

func _on_Button_pressed():
	if amnt > 0:
		topLevel.updateCursorStoneColor(colorName)
	else:
		print("No more " + displayColorName + " left")

func updateSelfText ():
	text = displayColorName + ": " + str(amnt)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delta:
		pass
	updateSelfText()
