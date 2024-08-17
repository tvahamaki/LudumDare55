extends Control


func _ready():
	$"Start".connect("pressed", self, "_start_game")


func _start_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"../../Music".play()
	$"../../GameMaster".started = true
	$"../HUD".visible = true
	visible = false
