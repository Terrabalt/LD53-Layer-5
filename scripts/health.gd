extends ReferenceRect

signal health_emptied()

func _on_hit():
	var i = get_child_count() - 1
	while not get_child(i).visible and i > 0:
		i -= 1
	get_child(i).visible = false
	if i == 0:
		health_emptied.emit()
