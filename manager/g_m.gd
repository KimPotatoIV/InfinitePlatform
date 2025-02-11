extends Node

##################################################
var game_score: int = 0
# 실시간 게임 점수
var game_best_score: int
# 최고 게임 점수
var game_over: bool = false
# 게임 오버 여부
var player_moving: bool = false
# 플레이어 이동 중인지 여부

##################################################
func _ready() -> void:
	load_best_score()
	# 최고 게임 점수 불러오기

##################################################
func get_score() -> int:
# 실시간 게임 점수 반환 함수
	return game_score

##################################################
func set_score(score_value: int) -> void:
# 실시간 게임 점수 설정 함수
	game_score = score_value
	
##################################################
func save_best_score() -> void:
# 최고 게임 점수 저장 함수
	if game_best_score < game_score:
	# 최고 게임 점수가 실시간 게임 점수보다 작으면
		game_best_score = game_score
		# 최고 게임 점수에 실시간 게임 점수 설정
		var saved_file: ConfigFile = ConfigFile.new()
		# saved_file 객체 생성
		saved_file.set_value("game", "score", game_best_score)
		# 최고 게임 점수를 저장 값으로 설정
		saved_file.save("user://best_score.cfg")
		# 설정 값을 파일로 저장

##################################################
func load_best_score() -> void:
# 최고 게임 점수 불러오기 함수
	var loaded_file: ConfigFile = ConfigFile.new()
	# loaded_file 객체 생성
	if loaded_file.load("user://best_score.cfg") == OK:
	# 파일 불러오기 성공 시
		game_best_score = loaded_file.get_value("game", "score", game_best_score)
		# game_best_score에 파일 값 설정

##################################################
func get_game_best_score() -> int:
# 최고 게임 점수 반환 함수
	return game_best_score

##################################################
func get_game_over() -> bool:
# 게임 오버 여부 반환 함수부
	return game_over

##################################################
func set_game_over(game_over_value: bool) -> void:
# 게임 오버 여부 설정 함수
	game_over = game_over_value

##################################################
func get_player_moving() -> bool:
# 플레이어 이동 중인지 여부 반환 함수
	return player_moving

##################################################
func set_player_moving(player_moving_value: bool) -> void:
# 플레이어 이동 중인지 여부 설정 함수
	player_moving = player_moving_value
