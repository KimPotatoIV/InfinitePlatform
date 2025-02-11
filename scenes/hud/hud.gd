extends CanvasLayer

##################################################
var score_label: Label
# 실시간 점수 라벨
var best_score_label: Label
# 최고 점수 라벨
var game_over_container: VBoxContainer
# 게임 오버 문구 컨테이너. 라벨 두 개가 포함되어 있음
var score: int = 0
# 실시간 점수 지역 변수
var best_score: int = 0
# 최고 점수 지역 변수
# 위 두 변수는 잦은 업데이트를 막기 위해 사용하는 변수

##################################################
func _ready() -> void:
	score_label = $MarginContainer2/ScoreLabel
	best_score_label = $MarginContainer/BestScoreLabel
	game_over_container = $GameOverVBoxContainer
	# 각 라벨 및 컨테이너 설정

##################################################
func _process(delta: float) -> void:
	if not score == GM.get_score():
	# 실시간 점수 지역 변수가 게임 매니저의 실시간 점수와 같지 않다면
		score = GM.get_score()
		# 실시간 점수 지역 변수에 게임 매니저의 실시간 점수 설정
		score_label.text = str(score)
		# score_label 텍스트 설정
	
	if not best_score == GM.get_game_best_score():
	# 최고 점수 지역 변수가 게임 매니저의 최고 점수와 같지 않다면
		best_score = GM.get_game_best_score()
		# 최고 점수 지역 변수에 게임 매니저의 최고 점수 설정
		best_score_label.text = str(best_score)
		# best_score_label 텍스트 설정
	
	game_over_container.visible = GM.get_game_over()
	# 게임 매니저의 게임 오버 여부에 따라 game_over_container를 나타냄
