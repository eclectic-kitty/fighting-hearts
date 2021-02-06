extends Node2D

export var speed = 350
export var health = 100

var fw = 0
var held = 0
signal fired(heart_pos)

signal damaged(health)
signal dead()

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_just_pressed("fire") && fw == 0 && held == 0:
		fire()
	if Input.is_action_pressed("fire") && fw == 0 && held == 1:
		fire()
	
	if health <= 0:
		dead()
	
	


func dead():
	visible = 0
	fw = 1
	emit_signal("dead")


func fire():
	emit_signal("fired", position)
	fw = 1
	$FireTimer.start()


func _on_FireTimer_timeout():
	fw = 0


func _on_self_entered(_area_id, area, _area_shape, _self_shape):
	if area.get_name() == "KnifeArea":
		health = clamp(health - 10, 0, 100)
		emit_signal("damaged", health)


func _on_powerup_equipped(_instance, on):
	if on:
		speed = 600
		held = 1
		$FireTimer.wait_time = 0.15
	else:
		speed = 350
		held = 0
		$FireTimer.wait_time = 0.3


func _on_Enemy_death():
	health = clamp(health + 2, 0, 100)
	emit_signal("damaged", health)
	print(health)
