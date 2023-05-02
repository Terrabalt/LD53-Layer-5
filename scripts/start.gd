extends Node

var mainGame = null

var high_score = 0
@export var main_game: PackedScene
@export var flair: PackedScene

func _on_start_button_pressed():
	$StartButton.disabled = true
	$StartButton.visible = false
	mainGame = main_game.instantiate()
	mainGame.game_over.connect(_on_game_over)
	add_child(mainGame)
	$Title.visible = false
	$Panel.visible = false
	$FlairTimer.stop()
	
func _on_game_over(score):
	high_score = max(high_score, score)
	$RestartButton.visible = true
	$Panel.visible = true
	$FlairTimer.start()


func _on_restart_button_pressed():
	$RestartButton.visible = false
	remove_child(mainGame)
	mainGame = preload("res://scenes/main.tscn").instantiate()
	add_child(mainGame)
	$Panel.visible = false
	$FlairTimer.stop()


func _on_flair_timer_timeout():
	$FlairTimer.wait_time = randf_range(0.26, 0.47)
	print("start")
	var spawn_location = $Path2D/PathFollow2D
	spawn_location.progress_ratio = randf()
	
	var flair_instance = flair.instantiate()
	flair_instance.position = spawn_location.position
	flair_instance.rotation = spawn_location.rotation + PI / 2
	$Panel.add_child(flair_instance)
	
