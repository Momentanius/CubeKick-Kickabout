extends Spatial

onready var Ball = get_tree().get_root().find_node("Ball",true,false)

var Player1_score = 0
var Player2_score = 0
export var max_score = 1

func _ready():
	reset_pitch()

func _on_GoalDetection_body_entered(body, goal_id):
	Ball.axis_lock_linear_x = true
	Ball.axis_lock_linear_y = true
	Ball.axis_lock_linear_z = true
	get_tree().call_group("player", "can_move", false)
	update_score(goal_id)
	$Timer.start()
	if not $AirHorn.is_playing():
		$AirHorn.play()

func update_score(player):
	var new_score
	if player == 1:
		Player1_score += 1
		new_score = Player1_score
	else:
		Player2_score += 1
		new_score = Player2_score
	
	$GUI.update_score(player, new_score)
	check_end(player, new_score)

func check_end(player, new_score):
	if new_score == max_score:
		$Timer.queue_free()
		$GUI.game_over(player)

func _on_Timer_timeout():
	reset_pitch()

func reset_pitch():
	var BallSpawn = get_tree().get_root().find_node("BallSpawn",true,false)
	Ball.translation = BallSpawn.translation
	Ball.axis_lock_linear_x = false
	Ball.axis_lock_linear_y = false
	Ball.axis_lock_linear_z = false
	get_tree().call_group("player","reset")

func restart_game():
	get_tree().reload_current_scene()