extends Node

@export var mob_scene: PackedScene
var score

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("游戏开始！")
	
	$Music.play()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	# 让敌人出生在路线上的随机位置
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position

	## 敌人运动方向：默认指向屏幕中心
	var direction = mob_spawn_location.rotation + PI / 2

	# 加一点随机角度（±45°），避免所有敌人走同一条线
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# 设置随机速度
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# 把敌人真正加入场景树
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
