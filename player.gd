extends Area2D

## 玩家被敌人碰撞
signal hit

## 玩家移动速度（像素/秒）
@export var speed = 400
## 游戏窗口大小
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	# 移动向量
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# 改变玩家位置
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 改变移动动画效果
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	# 已死亡，无法被碰撞
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
