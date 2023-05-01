extends Node

var mainGame = null

var high_score = 0

func _on_start_button_pressed():
	$StartButton.disabled = true
	$StartButton.visible = false
	mainGame = preload("res://scenes/main.tscn").instantiate()
	mainGame.game_over.connect(_on_game_over)
	add_child(mainGame)
	$Panel.visible = false
	
func _on_game_over(score):
	high_score = max(high_score, score)
	$RestartButton.visible = true
	$Panel.visible = true


func _on_restart_button_pressed():
	$RestartButton.visible = false
	remove_child(mainGame)
	mainGame = preload("res://scenes/main.tscn").instantiate()
	add_child(mainGame)
	$Panel.visible = false
