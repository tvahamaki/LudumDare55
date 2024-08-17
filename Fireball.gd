extends Area


var speed = 20.0


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):
	global_translation += (global_transform.basis * Vector3.FORWARD) * speed * delta


func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(30)
	
	queue_free()
