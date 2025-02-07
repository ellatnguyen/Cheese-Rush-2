extends CanvasLayer

class_name UI

@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var final_score = $FinalScore

func _ready():
	visible = true  # Ensure UI is not hidden
	score_label.visible = true
	
func set_score(score):
	score_label.text = "SCORE: %d" % score
	final_score.text = "%d"  % score
