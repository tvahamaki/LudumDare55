extends Spatial


var timer = 2.0
onready var anim = $"AnimationPlayer"


func _ready():
	anim.connect("animation_finished", self, "_on_animation_finished")
	anim.play("Hit", -1, 2.0)


func _on_animation_finished(animation):
	print(animation)
	queue_free()

