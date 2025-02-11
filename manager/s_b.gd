extends Node

##################################################
signal reset_game_signal
# 게임 리셋 신호

##################################################
func reset_game() -> void:
# 게임 리셋 신호 발산 함수
	emit_signal("reset_game_signal")
	# 게임 리셋 신호 발산
