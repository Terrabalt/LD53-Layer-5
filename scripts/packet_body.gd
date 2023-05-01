extends StaticBody2D

var adress = [0, 0, 0, 0]

var dragable = false
var dragging = false
var grabbed_offset = position
var velocity_up = 1
var aim : Area2D = null 


func _ready():
	$Dragging.set_address(adress[0], adress[1], adress[2], adress[3])

func _process(delta):
	position.y -= velocity_up * delta
	
	if aim == null:
		$Packetbg.position = Vector2i(0, 0)
	else:
		$Packetbg.position = aim.get_node("Slot").global_position - position
	if dragging:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$Dragging.global_position = get_global_mouse_position() + grabbed_offset
		else:
			dragging = false
			$Dragging.position = Vector2i(0, 0)
			if aim != null and aim.current_packet == null:
				global_position = aim.get_node("Slot").global_position
				aim.new_packet(self)
				velocity_up = 0

func _mouse_enter():
	dragable = true
func _mouse_exit():
	dragable = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && aim == null:
		if dragable:
			dragging = event.pressed
			grabbed_offset = position - get_global_mouse_position()
		if !dragging:
			$Dragging.position = Vector2i(0, 0) 

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	packet_skipped.emit(adress)

signal packet_skipped(adress:Array)

func _on_dragging_shape_area_entered(area):
	if area.is_on():
		aim = area
	
func _on_dragging_shape_area_exited(_area):
	aim = null
