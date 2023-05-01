extends Node2D

var start = false
const packetScene = preload("res://scenes/packet_body.tscn") as PackedScene
@export var currRange = 2
@export var maxRange = 7
@export var currVelocity = 100
@export var maxVelocity = 450
@export var maxTimer = 1.0
var score = 0
var open_ports = 0

func _ready():
	perturb()
	spawn()

func spawn():
	var a = packetScene.instantiate()
	var count = $Ports.get_child_count()
	var idx = randi_range(0, count - 1)
	var i = count
	while ($Ports.get_child(idx).current_packet != null or not $Ports.get_child(idx).is_on()) and i > 0:
		i = i - 1
		idx = (idx + 1) % count
		
	if $Ports.get_child(idx).current_packet == null and $Ports.get_child(idx).is_on() and randf() > 0.25:
		a.adress[0] = $Ports.get_child(idx).addr_1
		a.adress[1] = $Ports.get_child(idx).addr_2
		a.adress[2] = $Ports.get_child(idx).addr_3
		a.adress[3] = $Ports.get_child(idx).addr_4
	else:
		for j in range(len(a.adress)):
			a.adress[j] = randi_range(0, currRange)
		
	var packet_spawn_location = get_node("PacketPath/PacketSpawnLocation")
	packet_spawn_location.progress_ratio = randf()
	a.position = packet_spawn_location.position
	a.velocity_up = currVelocity
	a.packet_skipped.connect(_on_packet_skipped)
	$Packets.add_child(a)

func _on_spawn_packets_timeout():
	spawn()

func _on_packet_skipped(adress:Array):
	var count = $Ports.get_child_count()
	while count > 0:
		count -= 1
		var port = $Ports.get_child(count)
		if port.is_on() and adress[0] == port.addr_1 and adress[1] == port.addr_2 and adress[2] == port.addr_3 and adress[3] == port.addr_4:
			misplay()
	
func _on_port_pertubator_timeout():
	var i = currRange / 2
	for _I in range(i):
		if randf() > 0.3:
			perturb()

func perturb():
	var count = $Ports.get_child_count()
	var idx = randi_range(0, $Ports.get_child_count() - 1)
	var j = count
	while $Ports.get_child(idx).current_packet != null and j > 0:
		j = j - 1
		idx = (idx + 1) % count
	if $Ports.get_child(idx).is_on() and open_ports > 1:
		$Ports.get_child(idx).set_address(-1, -1, -1, -1)
		open_ports -= 1
	else:
		var _1 = randi_range(0, currRange)
		var _2 = randi_range(0, currRange)
		var _3 = randi_range(0, currRange)
		var _4 = randi_range(0, currRange)
		$Ports.get_child(idx).set_address(_1, _2, _3, _4)
		open_ports += 1
	

func misplay():
	$SkipSound.play()
	$Health._on_hit()

func _on_port_right_process():
	$PassSound.play()
	score += 10
	$Score.text = str(score)


func _on_health_emptied():
	$SpawnPackets.stop()
	$PortPertubator.stop()
	for packet in $Packets.get_children():
		packet.queue_free()
	for port in $Ports.get_children():
		port.set_address(-1, -1, -1, -1)
	game_over.emit(score)

signal game_over(score)

func _on_complexify_timeout():
	currRange = min(currRange + 1, maxRange)


func _on_accelerate_timeout():
	currVelocity = min(currVelocity * 1.06, maxVelocity)
	$SpawnPackets.wait_time = max($SpawnPackets.wait_time * 0.9, maxTimer)
	print(currVelocity)
	print($SpawnPackets.wait_time)
