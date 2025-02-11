extends Node

##################################################
const SCORE_SOUND = preload("res://sounds/maou_se_onepoint26.wav")
const GAME_OVER_SOUND = preload("res://sounds/maou_se_8bit21.wav")
# 각 사운드 스트림 미리 불러오기

var sound_effect_player: AudioStreamPlayer
# 효과음 사운드 플레이어

##################################################
func _ready() -> void:
	sound_effect_player = AudioStreamPlayer.new()
	# sound_effect_player 초기화 설정
	add_child(sound_effect_player)
	# sound_effect_player 인스턴스화
	sound_effect_player.volume_db = -10.0
	# sound_effect_player 소리 크기 설정

##################################################
func score_sound_play() -> void:
# 점수 올라가는 사운드 재생 함수
	sound_effect_player.stream = SCORE_SOUND
	# SCORE_SOUND 스트림 설정
	sound_effect_player.play()
	# 효과음 재생

##################################################
func game_over_sound_play() -> void:
# 게임 오버 사운드 재생 함수
	sound_effect_player.stream = GAME_OVER_SOUND
	# GAME_OVER_SOUND 스트림 설정
	sound_effect_player.play()
	# 효과음 재생
