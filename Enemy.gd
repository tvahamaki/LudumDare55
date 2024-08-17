class_name Enemy extends KinematicBody


var speed = 4.0
var stun_timer = 0.0
var health = 30
var target = null

var death_effect_scene = preload("res://Hit.tscn")
var death_effect_offset = Vector3.ZERO
var death_effect_scale = 5.0


func _ready():
	pass


func _process(delta):
	if not is_instance_valid(target):
		if is_in_group("Enemies"):
			target = $"../Player"
		else: 
			target_nearest_enemy()


func damage(amount, instigator = null):
	health -= amount
	
	if instigator != null:
		target = instigator
	
	if health <= 0:
		var death_effect = death_effect_scene.instance()
		get_parent().add_child(death_effect)
		death_effect.global_translation = global_translation + death_effect_offset
		death_effect.scale = Vector3.ONE * death_effect_scale
		death_effect.look_at($"../Player".global_translation, Vector3.UP)
		
		$"../GameMaster".kills += 1
		$"../GameMaster".score += 10
		#var ammo = ammo_scene.instance()
		#get_parent().add_child(ammo)
		#ammo.global_translation = global_translation + Vector3.UP * 0.5
		queue_free()


func target_nearest_enemy():
	var nearest_distance = INF
	
	for node in get_tree().get_nodes_in_group("Enemies"):
		var distance = global_translation.distance_squared_to(node.global_translation)

		if distance < nearest_distance:
			nearest_distance = distance
			target = node
