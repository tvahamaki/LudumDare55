extends Enemy


var attack_timer = 0.0
var attack_range = 2.0

var gravity = 20.0
var gravity_vec = Vector3.ZERO
var snap
var direction

onready var anim = $"zombie/AnimationPlayer" as AnimationPlayer


func _ready():
	health = 20
	death_effect_offset = Vector3.UP * 1.0
	anim.get_animation("Idle").loop = true
	anim.get_animation("Run").loop = true
	anim.play("Idle")

func _physics_process(delta):
	if stun_timer > 0.0:
		if anim.current_animation != "Hurt":
			anim.play("Hurt")
			anim.queue("Idle")
			
		stun_timer -= delta
	elif is_instance_valid(target):
		if anim.current_animation == "Idle":
			anim.play("Run")
			
		direction = target.global_translation - global_translation
		direction.y = 0.0
		direction = direction.normalized()
		look_at(global_translation + direction, Vector3.UP)
		
		if is_on_floor():
			snap = -get_floor_normal()
			gravity_vec = Vector3.ZERO
		else:
			snap = Vector3.DOWN
			gravity_vec += Vector3.DOWN * gravity * delta
		
		move_and_slide_with_snap(direction * speed + gravity_vec, snap, Vector3.UP)
	else:
		if anim.current_animation != "Idle":
			anim.play("Idle")
		
	if attack_timer > 0.0:
		attack_timer -= delta
	elif is_instance_valid(target) and stun_timer <= 0.0 and global_translation.distance_to(target.global_translation) < attack_range:
		attack_timer = 1.0
		anim.play("Attack")
		anim.queue("Idle")
		
		if target.has_method("damage"):
			target.damage(10, self)
