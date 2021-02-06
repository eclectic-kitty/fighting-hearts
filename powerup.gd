extends Node2D

export var health = 100
var picked_up = 0

var equipped = 0
var equip_held = 0

var use = 0
var use_change = 0
signal use_update(use)

signal picked_up(instance)
signal equipped(instance, on)

var screen_size
var rng = RandomNumberGenerator.new()

func _ready():
	screen_size = get_viewport_rect().size
	
	rng.randomize()
	position.y += rng.randf_range(0, screen_size.y)
	
	$Bubble.visible = 1
	$Sprite.visible = 0
	
func _process(delta):
	if !picked_up:
		$Bubble.global_rotation_degrees = 0
		$Bubble.position = $PrePath/PreFollow.position
		$PrePath/PreFollow.offset += 2
		
		if $PrePath/PreFollow.position.x < 0 - 30:
			queue_free()
		
		if health <= 0:
			picked_up = 1
			$Bubble/Area2D/CollisionShape2D.set_deferred("disabled", true)
			$Bubble.visible = 0
			$Sprite.visible = 1
			emit_signal("picked_up", self)
	
	if picked_up:
		
		if equipped:
			position = get_parent().get_node("Player").position
			visible = 1
			$Sprite.global_rotation_degrees = 0
			$Sprite.position = $PostPath/PostFollow.position
			$PostPath/PostFollow.offset += 2.5
			use += 10 * delta
		else:
			visible = 0
			if use > 0:
				use -= 4 * delta
		
		if use >= 100:
			queue_free()
			emit_signal("equipped", self, 0)
		
		if abs(use - use_change) > 10:
			emit_signal("use_update", use)
			use_change = use
			print("Hey!")
			
	
	var equip = Input.is_action_pressed("equip")
	if equip and !equip_held:
		equipped = !equipped
		emit_signal("equipped", self, equipped)
	equip_held = equip


func _on_self_entered(_area_id, area, _area_shape, _self_shape):
	if area.get_name() == "HeartArea":
		health -= 25
