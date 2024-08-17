class_name Player extends KinematicBody


var health = 100
var ammo = 20
var scroll = null

var speed = 13.0
const ACCEL_DEFAULT = 10.0
const ACCEL_AIR = 2.0
onready var accel = ACCEL_DEFAULT
var gravity = 20.0
var jump = 8.0

var mouse_sens = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

var cam_pitch = 0.0

onready var camera = $"Camera"
onready var ui_health = $"../UI/HUD/Health"
onready var ui_game_over = $"../UI/GameOver"
onready var ui_game_over_info = $"../UI/GameOver/Info"
onready var game = $"../GameMaster"
onready var shotgun_anim = $"Camera/shotgun/AnimationPlayer"
onready var shotgun_sound = $"Camera/shotgun/Shoot"
onready var hurt_sound = $"Hurt"

var hit_scene = preload("res://Hit.tscn")


func _ready():
	shotgun_anim.get_animation("Idle").loop = true
	shotgun_anim.play("Idle")


func _input(event):
	if not game.started:
		return
		
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		cam_pitch -= event.relative.y * mouse_sens
		cam_pitch = clamp(cam_pitch, -89, 89)
		camera.rotation_degrees.x = cam_pitch
		
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT and shotgun_anim.current_animation == "Idle":
			shotgun_anim.play("Shoot", -1, 1.5)
			shotgun_anim.queue("Idle")
			shotgun_sound.play()
			
			var state = get_world().direct_space_state
			
			for i in range(0, 9):
				var from = camera.global_translation
				var direction = Vector3.FORWARD
				direction = direction.rotated(Vector3.RIGHT, (randf() - 0.5) * 0.2)
				direction = direction.rotated(Vector3.UP, (randf() - 0.5) * 0.2)
				var to = camera.global_translation + camera.global_transform.basis * direction * 15.0
				var result = state.intersect_ray(from, to, [self])
				
				if result:
					var hit = hit_scene.instance()
					get_parent().add_child(hit)
					hit.global_translation = result.position
					hit.look_at(global_translation, Vector3.UP)
					
					if result.collider is Enemy:
						result.collider.stun_timer = 0.5
						result.collider.damage(2.0, self)
				
	if event is InputEventKey:
		if event.scancode == KEY_E and scroll != null:
			scroll.activate()


func _process(delta):
	if not game.started:
		return
		
	camera.rotation.z = (camera.global_transform.basis.inverse() * velocity).x * -0.002
	#camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
	
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
#	if Engine.get_frames_per_second() > Engine.iterations_per_second:
#		camera.set_as_toplevel(true)
#		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
#		camera.rotation.y = rotation.y
#		camera.rotation.x = head.rotation.x
#	else:
#		camera.set_as_toplevel(false)
#		camera.global_transform = head.global_transform


func _physics_process(delta):
	if not game.started:
		return
	
	#get keyboard input
	direction = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		direction += transform.basis * Vector3.FORWARD
	if Input.is_key_pressed(KEY_A):
		direction += transform.basis * Vector3.LEFT
	if Input.is_key_pressed(KEY_S):
		direction += transform.basis * Vector3.BACK
	if Input.is_key_pressed(KEY_D):
		direction += transform.basis * Vector3.RIGHT
		
	direction = direction.normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)


func add_ammo(amount):
	ammo += amount


func damage(amount, instigator = null):
	if health <= 0:
		return
	
	hurt_sound.play()
	
	health = int(max(health - amount, 0))
	ui_health.text = str(health)
	
	if health <= 0:
		game.started = false
		game.score += int(game.time)
		camera.translation = Vector3(0.0, 0.15, 0.0)
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		ui_game_over.visible = true
		ui_game_over_info.text = "You survived for " + str(game.minutes) + " minutes and " + str(game.seconds) + " seconds.\n\n"
		ui_game_over_info.text += "You killed " + str(game.kills) + " enemies.\n\n"
		ui_game_over_info.text += "SCORE " + str(game.score)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
