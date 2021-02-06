extends Node2D

var heart = preload("res://projectiles/heart.tscn")
var knife = preload("res://projectiles/knife.tscn")

func _ready():
	pass
	
func _process(_delta):
	pass


func _on_Player_fired(heart_pos):
	var heart_instance = heart.instance()
	add_child(heart_instance)
	heart_instance.position.y = heart_pos.y - 17
	heart_instance.position.x = heart_pos.x + 30

func _on_Enemy_fired(knife_pos):
	var knife_instance = knife.instance()
	add_child(knife_instance)
	knife_instance.position = knife_pos
