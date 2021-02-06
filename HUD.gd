extends CanvasLayer

var score = 0

func _ready():
	$HealthBar.set_frame(10)
	$PowerupBar.visible = 0
	$PowerupBar.set_frame(10)


func _process(_delta):
	$ScoreLabel.text = str(score)


func _on_player_damaged(health):
	$HealthBar.set_frame(floor(health/10))


func _on_powerup_picked_up(instance):
	$PowerupBar.visible = 1


func _on_powerup_use_update(use):
	$PowerupBar.set_frame(ceil(lerp(10, 0, use/100)))


func _on_Enemy_death():
	score += 100
