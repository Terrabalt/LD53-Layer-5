extends Area2D

@export var addr_1 = -1
@export var addr_2 = -1
@export var addr_3 = -1
@export var addr_4 = -1
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

var current_packet: Node2D = null

func _ready():
	set_address(addr_1, addr_2, addr_3, addr_4)

func new_packet(packet: Node2D):
	print(packet)
	current_packet = packet
	$TransmitSound.play()
	$PacketProcess.start()
	
func is_on():
	return addr_1 != -1 and addr_2 != -1 and addr_3 != -1 and addr_4 != -1

func set_address(_1, _2, _3, _4):
	addr_1 = clamp(_1, -1, len(slots))
	addr_2 = clamp(_2, -1, len(slots))
	addr_3 = clamp(_3, -1, len(slots))
	addr_4 = clamp(_4, -1, len(slots))
	if addr_1 < 0:
		slot1.visible = false
	else:
		slot1.visible = true
		slot1.texture = slots[addr_1]
	if addr_2 < 0:
		slot2.visible = false
	else:
		slot2.visible = true
		slot2.texture = slots[addr_2]
	if addr_3 < 0:
		slot3.visible = false
	else:
		slot3.visible = true
		slot3.texture = slots[addr_3]
	if addr_4 < 0:
		slot4.visible = false
	else:
		slot4.visible = true
		slot4.texture = slots[addr_4]

signal wrong_process()
signal right_process()

func _on_packet_process_timeout():
	$TransmitSound.stop()
	if addr_1 != current_packet.adress[0] or addr_2 != current_packet.adress[1] or addr_3 != current_packet.adress[2] or addr_4 != current_packet.adress[3]:
		wrong_process.emit()
	else:
		right_process.emit()
	current_packet.queue_free()
