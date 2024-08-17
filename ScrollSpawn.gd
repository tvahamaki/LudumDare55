extends Spatial


var can_spawn = true
var spawn_timer = 10.0
onready var game = $"../GameMaster"
var scroll_scene = preload("res://Scroll.tscn")
export(bool) var golem


func _ready():
	pass


func _process(delta):
	if not game.started:
		return
	
	if spawn_timer > 0.0:
		if can_spawn:
			spawn_timer -= delta
	else:
		spawn_timer = 30.0
		var scroll = scroll_scene.instance()
		get_parent().add_child(scroll)
		scroll.global_translation = global_translation
		scroll.spawn = self
		
		if golem:
			scroll.text = "E - Summon Golem"
			scroll.summon_golem = true
			scroll.scale = Vector3(2.0, 2.0, 2.0)
		
		can_spawn = false
