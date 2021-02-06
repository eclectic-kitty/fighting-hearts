extends Node2D

export var speed = 400
export var health = 100

var screen_size
var rng = RandomNumberGenerator.new()

signal fired(knife_pos)
signal dead()

func _ready():
	screen_size = get_viewport_rect().size
	
	rng.randomize()
	position.y += rng.randf_range(0, screen_size.y)
	if position.y > screen_size.y / 2:
		scale.y = -1
		
	$FireTimer.start()
	
func _process(delta):
	$EnemyPath/PathFollow2D.offset += speed * delta
	$Sprite.position = $EnemyPath/PathFollow2D.position
	$Sprite.global_scale.y = 0.1
	
	if $EnemyPath/PathFollow2D.position.x < -10 or health <= 0:
		if health <= 0:
			emit_signal("dead")
		queue_free()

func _on_FireTimer_timeout():
	emit_signal("fired", $EnemyPath/PathFollow2D.global_position)
	$FireTimer.start()


func _on_self_entered(_area_id, area, _area_shape, _self_shape):
	if area.get_name() == "HeartArea":
		health -= 50
