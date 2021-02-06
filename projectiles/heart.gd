extends Node2D

export var speed = 800

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	position.x += speed * delta
	if position.x > screen_size.x + 50:
		queue_free()


func _on_self_entered(_area_id, area, _area_shape, _self_shape):
	if area.is_in_group("Enemies") or area.is_in_group("Powerups"):
		$DeathTimer.start()


func _on_DeathTimer_timeout():
	queue_free()
