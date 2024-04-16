extends Node

@onready var gameState = get_node("/root/testing")

const maxX:int = 19
const maxY:int = 19
var coords = [] #coordinate system

func floodFillCheck(posX:int, posY:int, alreadySeen = []) -> Array: #use flood fill to find all connected stones of the same color. If there are 4 or more return true and all the connected stones. treat "W" as all colors.
	if posX >= maxX or posY >= maxY:
		return [false, [[]]]
	var color = coords[posX][posY]
	if color == "X":
		return [false, [[]]]
	if color == "I" or color == "-":
		return [false, 0]
	var visited = alreadySeen
	for i in range(maxX):
		var holder = []
		for j in range(maxY):
			holder.append(false)
		visited.append(holder)
	var count = 0
	var stack = []
	stack.append([posX, posY])
	while stack.size() > 0:
		var current = stack.pop_front()
		var x = current[0]
		var y = current[1]
		if x < 0 or x >= maxX or y < 0 or y >= maxY:
			continue
		if visited[x][y]:
			continue
		visited[x][y] = true
		if color == "W":
			color = coords[x][y]
		#check if the stone is connected to the color. treat white as all colors. If white bridges two different colors both of those sections are treated as the same color.
		if color == "W":
			count += 1
			if not visited[x+1][y] and x+1 < maxX and coords[x+1][y] != "I" and coords[x+1][y] != "-":
				stack.append([x+1, y])
			if not visited[x-1][y] and x-1 >= 0 and coords[x-1][y] != "I" and coords[x-1][y] != "-":
				stack.append([x-1, y])
			if not visited[x][y+1] and y+1 < maxY and coords[x][y+1] != "I" and coords[x][y+1] != "-":
				stack.append([x, y+1])
			if not visited[x][y-1] and y-1 >= 0 and coords[x][y-1] != "I" and coords[x][y-1] != "-":
				stack.append([x, y-1])
		else:
			if coords[x][y] != "W":
				color = coords[x][y]
			if coords[x][y] == color or coords[x][y] == "W":
				count += 1
				if (coords[x+1][y] == color or coords[x+1][y] == "W" or color == "W") and not visited[x+1][y] and x+1 < maxX:
					stack.append([x+1, y])
				if (coords[x-1][y] == color or coords[x-1][y] == "W" or color == "W") and not visited[x-1][y] and x-1 >= 0:
					stack.append([x-1, y])
				if (coords[x][y+1] == color or coords[x][y+1] == "W" or color == "W") and not visited[x][y+1] and y+1 < maxY:
					stack.append([x, y+1])
				if (coords[x][y-1] == color or coords[x][y-1] == "W" or color == "W") and not visited[x][y-1] and y-1 >= 0:
					stack.append([x, y-1])
	if count >= 4:
		return [true, visited]
	return [false, visited]

func setInertAfterFloodFill(result:Array) -> int: #set all connected stones to inert. If there were connected stones return the amount as an int for scoring. Otherwise return 0.
	if result[0] == false:
		return 0
	var count = 0
	for i in range(maxX):
		for j in range(maxY):
			if result[1][i][j]:
				coords[i][j] = "I"
				count += 1
	return count

func checkIfAnyAdjacentStone(posX:int, posY:int) -> bool:
	var upStone
	var downStone
	var leftStone
	var rightStone
	if posY > 0:
		upStone = coords[posX][posY-1]
	else:
		upStone = "-"
	if posY < maxY-1:
		downStone = coords[posX][posY+1]
	else:
		downStone = "-"
	if posX > 0:
		leftStone = coords[posX-1][posY]
	else:
		leftStone = "-"
	if posX < maxX-1:
		rightStone = coords[posX+1][posY]
	else:
		rightStone = "-"
	if upStone != "-" or downStone != "-" or leftStone != "-" or rightStone != "-":
		return true
	else:
		return false

func placeStone(color:String, posX:int, posY:int) -> Array:
	if posX >= maxX or posY >= maxY:
		print("Failed to place, out of bounds")
		return [false, 0]
	if coords[posX][posY] != "-":
		print("failed to place, space already occupied")
		return [false, 0]
	#reject a placement that isn't next to another stone
	if not checkIfAnyAdjacentStone(posX, posY):
		print("Failed to place, not next to any other stone")
		return [false, 0]
	coords[posX][posY] = color
	print("Placed stone at: ", posX, posY)
	var score = setInertAfterFloodFill(floodFillCheck(posX, posY))
	if score > 0:
		print("Scored: ", score)
	gameState.updateTurn(color, score)
	return [true, score]

func placeInertOnInit(): #places inert stones in the center of the board and evenly spaced 8 positions around the center like a go board
	coords[9][9] = "I"
	coords[3][3] = "I"
	coords[3][15] = "I"
	coords[15][3] = "I"
	coords[15][15] = "I"
	coords[9][3] = "I"
	coords[9][15] = "I"
	coords[3][9] = "I"
	coords[15][9] = "I"
	print("Placed inert stones")

func printBoard():
	for i in range(maxX):
		var line = ""
		for j in range(maxY):
			line += coords[i][j]
		print(line)

func removeStone(posX:int, posY:int) -> bool:
	if posX >= maxX or posY >= maxY:
		print("Failed to remove, out of bounds")
		return 0
	if coords[posX][posY] == "-":
		print("Failed to remove, no stone to remove")
		return 0
	coords[posX][posY] = "-"
	#don't update score
	return true

func clearBoard():
	for i in range(maxX):
		for j in range(maxY):
			coords[i][j] = "-"
	print("Cleared board")

func resetBoard():
	clearBoard()
	placeInertOnInit()
	print("Reset board")

func initBoard():
	for i in range(maxX):
		var holder = []
		for j in range(maxY):
			holder.append("-")
		coords.append(holder)
	placeInertOnInit()
	print("Filled empty coords")

func getStone(posX:int, posY:int) -> String:
	if posX >= maxX or posY >= maxY:
		print("Failed to get stone, out of bounds")
		return "NULL"
	return coords[posX][posY]

# Called when the node enters the scene tree for the first time.
func _ready():
	initBoard()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#makes the linter shut the fuck up
	if delta:
		pass
