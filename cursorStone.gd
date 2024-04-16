extends MeshInstance2D

const CURSOR_SPACE_RECT = [460, 15, 1045 + 460, 1045 + 15]

@onready var followCursor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	if CURSOR_SPACE_RECT[0] < mousePos[0] and mousePos[0] < CURSOR_SPACE_RECT[2] and CURSOR_SPACE_RECT[1] < mousePos[1] and mousePos[1] < CURSOR_SPACE_RECT[3]:
		followCursor = true
	else:
		followCursor = false
	if delta:
		if followCursor:
			self.position = mousePos
