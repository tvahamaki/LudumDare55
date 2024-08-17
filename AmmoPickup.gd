extends Area


onready var mesh = $"MeshInstance"


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):
	mesh.translation.y = sin(Time.get_ticks_msec() * 0.001) * 0.05
	mesh.rotation_degrees.y = Time.get_ticks_msec() * 0.1
	
	# Float to ground if in the air
	global_translation += Vector3.DOWN * 10.0 * delta
	
	var state = get_world().direct_space_state
	var hit = state.intersect_ray(global_translation, global_translation + Vector3.DOWN * 0.5)
	
	if hit:
		global_translation = hit.position + Vector3.UP * 0.5


func _on_body_entered(body):
	if body.has_method("add_ammo"):
		body.add_ammo(10)
		queue_free()
