extends RigidBody2D

const slots = [
	preload("res://art/slots0.png"),
	preload("res://art/slots1.png"),
	preload("res://art/slots2.png"),
	preload("res://art/slots3.png"),
	preload("res://art/slots4.png"),
	preload("res://art/slots5.png"),
	preload("res://art/slots6.png"),
	preload("res://art/slots7.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = slots[randi_range(0, len(slots) - 1)]
	linear_velocity = Vector2(randf_range(450., 650.) - (get_viewport_rect().size.y - position.y) * 200 / get_viewport_rect().size.y, 0).rotated(rotation)
	angular_velocity = randf_range(-PI, PI)
	
	var ratio = randf_range(0.5, 2.0)
	$Sprite.scale = Vector2(ratio, ratio)
	modulate.a8 = (1.0 / ratio) * 255

func _on_screen_exited():
	queue_free()
