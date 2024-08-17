extends Control


func _ready():
	$"Restart".connect("pressed", self, "_restart")


func _restart():
	get_tree().change_scene("res://Game.tscn")
