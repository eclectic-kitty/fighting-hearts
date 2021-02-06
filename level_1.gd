extends Node

var pre_enemy = preload("res://enemy.tscn")
var enemy_count = 4 #enemies in a wave
var last_enemy_count = 0
var last_score = 0
var diff_ch #change in difficulty

var wave = 0
var wave_check = 0

var pre_powerup = preload("res://powerup.tscn")
var p_exist = 0 #boolean to know if the powerup has been spawned yet


func _ready():
	$WaveTimer.start()


func _process(_delta):
	pass


func _on_WaveTimer_timeout():
	enemy_count = 4 + round(wave * 1.5)
	wave += 1
	
	diff_ch = ($HUD.score - last_score) / (last_enemy_count * 100 - 1)
	last_enemy_count = enemy_count
	last_score = $HUD.score
	
	if diff_ch > 0.66:
		$EnemyTimer.wait_time -= 0.75
	elif diff_ch > 0.33:
		$EnemyTimer.wait_time -= 0.5
	else:
		$EnemyTimer.wait_time += 0.5
	if $EnemyTimer.wait_time < 1:
		$EnemyTimer.wait_time = 1
	
	$EnemyTimer.start()


func _on_EnemyTimer_timeout():
	var enemy = pre_enemy.instance()
	add_child(enemy)
	enemy.connect("fired", $ProjectileManager, "_on_Enemy_fired")
	enemy.connect("dead", $HUD, "_on_Enemy_death")
	enemy.connect("dead", $Player, "_on_Enemy_death")
	
	enemy_count -= 1
	if enemy_count > 0:
		$EnemyTimer.start()
	else:
		$WaveTimer.start()


func _on_Player_damaged(health):
	if health <= 60 and !p_exist:
		var powerup = pre_powerup.instance()
		add_child(powerup)
		powerup.connect("equipped", $Player, "_on_powerup_equipped")
		powerup.connect("picked_up", $HUD, "_on_powerup_picked_up")
		powerup.connect("use_update", $HUD, "_on_powerup_use_update")
		p_exist = 1
