extends Area


var text = "E - Summon Zombie"
var spawn = null
var summon_golem = false

var zombie_scene = preload("res://ZombieFriendly.tscn")
var golem_scene = preload("res://GolemFriendly.tscn")

onready var mesh = $"scroll"
onready var ui_text = $"../UI/HUD/Summon"
onready var player = $"../Player"


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):
	mesh.translation.y = sin(Time.get_ticks_msec() * 0.001) * 0.1
	mesh.rotation_degrees.y = Time.get_ticks_msec() * 0.1


func _on_body_entered(body):
	if body is Player and body.scroll == null:
		body.scroll = self
		ui_text.visible = true
		ui_text.text = text
		
		visible = false
		disconnect("body_entered", self, "_on_body_entered")


func activate():
	spawn.can_spawn = true
	
	if summon_golem:
		var golem = golem_scene.instance()
		get_parent().add_child(golem)
		golem.global_translation = player.global_translation
	else:
		var zombie = zombie_scene.instance()
		get_parent().add_child(zombie)
		zombie.global_translation = player.global_translation
	
	player.scroll = null
	ui_text.visible = false
	queue_free()
