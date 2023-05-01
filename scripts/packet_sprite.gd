extends Sprite2D

@export var addr_1 = 0
@export var addr_2 = 0
@export var addr_3 = 0
@export var addr_4 = 0
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
@onready var slot1 = $"1" as Sprite2D
@onready var slot2 = $"2" as Sprite2D
@onready var slot3 = $"3" as Sprite2D
@onready var slot4 = $"4" as Sprite2D

func set_address(_1, _2, _3, _4):
	addr_1 = clamp(_1, 0, len(slots))
	addr_2 = clamp(_2, 0, len(slots))
	addr_3 = clamp(_3, 0, len(slots))
	addr_4 = clamp(_4, 0, len(slots))
	slot1.texture = slots[addr_1]
	slot2.texture = slots[addr_2]
	slot3.texture = slots[addr_3]
	slot4.texture = slots[addr_4]

func set_a(a: int):
	modulate.a = a
	slot1.modulate.a = a
	slot2.modulate.a = a
	slot3.modulate.a = a
	slot4.modulate.a = a
