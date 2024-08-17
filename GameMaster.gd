extends Spatial


var started = false

var minutes = 0
var seconds = 0
var time = 0
var kills = 0
var score = 0

var spawn_timer = 3.0

var zombie_scene = preload("res://Zombie.tscn")
var golem_scene = preload("res://Golem.tscn")
var bat_scene = preload("res://Bat.tscn")
var zombie_spawns = null


func _ready():
	pass


func _process(delta):
	if not started:
		return
	
	time += delta
	minutes = int(time / 60)
	seconds = int(time - minutes * 60)
	
	if spawn_timer > 0.0:
		spawn_timer -= delta
	else:
		spawn_timer = 15.0
		zombie_spawns = get_tree().get_nodes_in_group("ZombieSpawns")
		
		for i in range(0, 5):
			var spawn_index = randi() % zombie_spawns.size()
			var spawn = zombie_spawns[spawn_index]
			zombie_spawns.remove(spawn_index)
			
			var zombie = zombie_scene.instance()
			get_parent().add_child(zombie)
			zombie.add_to_group("Enemies")
			zombie.global_translation = spawn.global_translation
			
		var spawn_index = randi() % zombie_spawns.size()
		var spawn = zombie_spawns[spawn_index]
		zombie_spawns.remove(spawn_index)
		
		var golem = golem_scene.instance()
		get_parent().add_child(golem)
		golem.add_to_group("Enemies")
		golem.global_translation = spawn.global_translation
		
		spawn_index = randi() % zombie_spawns.size()
		spawn = zombie_spawns[spawn_index]
		zombie_spawns.remove(spawn_index)
		
		var bat = bat_scene.instance()
		get_parent().add_child(bat)
		bat.add_to_group("Enemies")
		bat.global_translation = spawn.global_translation + Vector3.UP * 4.0
