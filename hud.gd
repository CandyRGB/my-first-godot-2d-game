extends CanvasLayer

signal start_game

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("游戏结束")
	await $MessageTimer.timeout

	$Message.text = "躲避毛毛虫！"
	$Message.show()
	# 等待1分钟再展示开始按钮
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
