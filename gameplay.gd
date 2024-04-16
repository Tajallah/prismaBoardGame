extends Node2D

const RED_COLOR = Color(1, 0.2, 0.2, 0.33) #pastel red
const GREEN_COLOR = Color(0.2, 1, 0.2, 0.33) #pastel green
const BLUE_COLOR = Color(0.2, 0.2, 1, 0.33) #pastel blue
const YELLOW_COLOR = Color(1, 1, 0.2, 0.33) #pastel yellow
const WHITE_COLOR = Color(1, 1, 1, 0.33) #white
const BLACK_COLOR = Color(0, 0, 0, 0.33) #black
const INERT_COLOR = Color(0.74, 0, 0.8, 0.33) #grey purple

@onready var colorMap = {
	"R": RED_COLOR,
	"G": GREEN_COLOR,
	"B": BLUE_COLOR,
	"Y": YELLOW_COLOR,
	"W": WHITE_COLOR,
	"X": BLACK_COLOR,
	"I": INERT_COLOR
}

@onready var playerScore = 0
@onready var opponentScore = 0

@onready var playerOutOfStonesFlag = false
@onready var opponentOutOfStonesFlag = false

@onready var cursorStoneColor = "R"
@onready var turnPlayer = "Player"

@onready var hotseat:bool = true

@onready var gameBoardSimulationLayer = get_node("gameBoardSimulationLayer")
@onready var boardVisuals = get_node("boardVisual")
@onready var playerStoneBins = {
	"R" : get_node("playerStoneBins/RedBin"),
	"B" : get_node("playerStoneBins/BlueBin"),
	"G" : get_node("playerStoneBins/GreenBin"),
	"Y" : get_node("playerStoneBins/YellowBin"),
	"W" : get_node("playerStoneBins/WhiteBin"),
	"X" : get_node("playerStoneBins/BlackBin")
}
@onready var opponentStoneBins = {
	"R" : get_node("opponentStoneBins/RedBin"),
	"B" : get_node("opponentStoneBins/BlueBin"),
	"G" : get_node("opponentStoneBins/GreenBin"),
	"Y" : get_node("opponentStoneBins/YellowBin"),
	"W" : get_node("opponentStoneBins/WhiteBin"),
	"X" : get_node("opponentStoneBins/BlackBin")
}
@onready var playerScoreKeeper = get_node("playerStoneBins/ScoreTracker")
@onready var opponentScoreKeeper = get_node("opponentStoneBins/ScoreTracker")

@onready var cursorStone = get_node("cursorStone")

func updateCursorStoneColor(color:String) -> void:
	cursorStoneColor = color
	cursorStone.modulate = colorMap[color]

func checkWinner() -> String:
	if playerScore >= 30:
		return "Player"
	elif opponentScore >= 30:
		return "Opponent"
	else:
		return ""

func playerOutOfStone() -> bool:
	for color in playerStoneBins.keys():
		if playerStoneBins[color].amnt <= 0:
			return true
	return false

func opponentOutOfStone() -> bool:
	for color in opponentStoneBins.keys():
		if opponentStoneBins[color].amnt <= 0:
			return true
	return false

func prematureScoreTally() -> String:
	if playerScore > opponentScore:
		return "Player"
	elif opponentScore > playerScore:
		return "Opponent"
	else:
		return "Draw"

func gameEnd(winner:String):
	print("%s wins"%(winner))

func updateTurn(color:String, score:int) -> void:
	if turnPlayer == "Player":
		playerScore += score
		playerScoreKeeper.text = "SCORE: " + str(playerScore)
		playerStoneBins[color].amnt -= 1
		if checkWinner() == "":
			if not opponentOutOfStone():
				turnPlayer = "Opponent"
			else:
				if playerOutOfStone():
					gameEnd(prematureScoreTally())
		else:
			gameEnd("Player")
	else:
		opponentScore += score
		opponentScoreKeeper.text = "SCORE: " + str(opponentScore)
		opponentStoneBins[color].amnt -= 1
		if checkWinner() == "":
			if not playerOutOfStone():
				turnPlayer = "Player"
			else:
				if opponentOutOfStone():
					gameEnd(prematureScoreTally())
		else:
			gameEnd("Opponent")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_red_bin_pressed():
	updateCursorStoneColor("R")

func _on_blue_bin_pressed():
	updateCursorStoneColor("B")

func _on_green_bin_pressed():
	updateCursorStoneColor("G")

func _on_yellow_bin_pressed():
	updateCursorStoneColor("Y")

func _on_white_bin_pressed():
	updateCursorStoneColor("W")

func _on_black_bin_pressed():
	updateCursorStoneColor("X")
