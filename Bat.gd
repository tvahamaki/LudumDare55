extends Enemy


var attack_timer = 5.0
var fireball_scene = preload("res://Fireball.tscn")
onready var anim = $"bat/AnimationPlayer" as AnimationPlayer


func _ready():
	speed = 2.0
	anim.get_animation("Idle").loop = true
	anim.play("Idle")


func _physics_process(delta):
	if stun_timer > 0.0:
		stun_timer -= delta
	elif is_instance_valid(target):
		look_at(target.global_translation, Vector3.UP)
		var direction = ((target.global_translation + Vector3.UP * 5.0) - global_translation).normalized()
		move_and_slide(direction * speed, Vector3.UP)
	
	if attack_timer > 0.0:
		attack_timer -= delta
	elif is_instance_valid(target):
		var fireball = fireball_scene.instance()
		get_parent().add_child(fireball)
		fireball.global_translation = global_translation + global_transform.basis * Vector3.FORWARD * 2.0
		fireball.look_at(target.global_translation + Vector3.UP, Vector3.UP)
		attack_timer = 5.0
