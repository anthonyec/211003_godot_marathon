extends Node

func _ready() -> void:
	var children = get_children()
	
	for child in children:
		child.target = $"../Player"
