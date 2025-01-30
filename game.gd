extends Node

var score = 0

func _ready():
    for cheese in get_tree().get_nodes_in_group("cheese"):  # Get all cheese pellets
        cheese.connect("cheese_collected", _on_cheese_collected)

func _on_cheese_collected(points):
    score += points
    print("Score: ", score)  # Print the updated score
