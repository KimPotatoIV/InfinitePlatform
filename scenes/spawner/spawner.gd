extends Node2D

##################################################
const PLATFORM = preload("res://scenes/platform/platform.tscn")
# platform 씬 미리 불러오기 
const PLATFORM_SIZE: Vector2 = Vector2(64.0, 64.0)
# 플랫폼 크기
const OFFSET: Vector2 = Vector2(180.0, 484.0)
# 플랫폼 생성 시작 기준 위치. 플레이어 위치와 동일
const SCREEN_SIZE: Vector2 = Vector2(360.0, 640.0)
# 화면 크기
const PLATFORM_COUNT: int = 20
# 생성되는 플랫폼 개수

var platform_array: Array = []
# 각 플랫폼 좌표의 기준값을 저장하는 배열
var steps: int = 0
# 플랫폼 단 수

##################################################
func _ready() -> void:
	init_platforms()
	# 처음 두 단 플랫폼 설정 함수
	generate_platforms()
	# PLATFORM_COUNT 개수만큼 플랫폼 설정 함수
	draw_platforms()
	# 각 플랫폼 인스턴스화 및 그리는 함수
	
	SB.connect("reset_game_signal", Callable(self, "_on_reset_game_signal"))
	# 시그널 버스(SB)의 reset_game_signal 발산 신호와 _on_reset_game_signal 함수 연결

##################################################
func _process(delta: float) -> void:
	if GM.get_player_moving():
	# 플레이어가 이동 중일 때
		GM.set_player_moving(false)
		# 플레이어 이동 중이 아니도록 설정
		var player_position = $"../Player".global_position.y
		# 플레이어 포지션
		for platform in get_tree().get_nodes_in_group("Platform"):
		# 그룹이 Platform인 인스턴스들을 platform으로 순회하며
			if platform.global_position.y >= player_position + (SCREEN_SIZE.y / 1.5):
			# platform의 Y 좌표가 플레이어 기준으로 일정 거리 이상 아래에 있으면
			# 위는 플랫폼이 화면 밖으로 나갔다는 의미
				remove_child(platform)
				platform.queue_free()
				# platform 인스턴스 제거
				
				for i in range(platform_array.size()):
				# platform_array를 순회하며
					var platform_position: Vector2 = \
					get_platform_position(platform_array[i].x, platform_array[i].y)
					# 순회 중인 platform_array 좌표를 구함
					if platform_position == platform.global_position:
					# 순회 중인 platform 인스턴스와 platform_position의 좌표가 같으면
					# 위는 같은 인스턴스와 배열 인자라는 의미
						platform_array.remove_at(i)
						# platform_array에서 순회 중인 인자 삭제
						break
						# 순회 정지
	
	generate_platforms()
	# PLATFORM_COUNT 개수만큼 플랫폼 설정 함수
	draw_platforms()
	# 각 플랫폼 인스턴스화 및 그리는 함수

##################################################
func init_platforms() -> void:
# 처음 두 단 플랫폼 설정 함수
	platform_array.append(Vector2i(-1, steps))
	steps += 1
	platform_array.append(Vector2i(-2, steps))
	steps += 1
	# 플레이어 기준 왼쪽으로 두 단 설정

##################################################
func generate_platforms() -> void:
# PLATFORM_COUNT 개수만큼 플랫폼 설정 함수
	while platform_array.size() < PLATFORM_COUNT:
	# platform_array 크기가 PLATFORM_COUNT보다 작다면
	# 위는 현재 인스턴스화 된 플랫폼이 PLATFORM_COUNT보다 적다는 의미
		var rand_i = randi_range(0, 1)
		# 임의의 수 설정. 발판 좌우 생성 위치를 정하기 위함
		var x = platform_array.back().x
		# 맨 위 발판 X 좌표 기준점 불러오기
		
		if rand_i == 0:
		# 임의의 수가 0이면
			x -= 1
			# 맨 위 발판 X 좌표 기준점 왼쪽으로 기준점 설정
		else:
		# 임의의 수가 1이면
			x += 1
			# 맨 위 발판 X 좌표 기준점 오른쪽으로 기준점 설정
		
		if x < -2:
			x = platform_array.back().x + 1
		elif x > 2:
			x = platform_array.back().x - 1
		# 기준점이 화면 밖으로 나가지 않도록 제한. 기준점은 -2에서 2 사이
		
		platform_array.append(Vector2i(x, steps))
		# 설정된 기준점 platform_array에 삽입
		steps += 1
		# steps 1 추가

##################################################
func draw_platforms() -> void:
# 각 플랫폼 인스턴스화 및 그리는 함수
	for platform in platform_array:
	# platform_array를 platform로 순회하며
		var platform_instance = PLATFORM.instantiate()
		# 새로운 인스턴스 생성
		var platform_position: Vector2 = get_platform_position(platform.x, platform.y)
		# 설정할 좌표 얻어오기
		platform_instance.global_position = platform_position
		# 새로운 인스턴스 좌표 설정
		
		add_child(platform_instance)
		# 자식 노드로 추가
		platform_instance.add_to_group("Platform")
		# 새로운 인스턴스 Platform 그룹에 추가

##################################################
func get_platform_position(x: int, y: int) -> Vector2:
# 플랫폼 좌표 반환 함수
	return Vector2(x * PLATFORM_SIZE.x + OFFSET.x, -y * PLATFORM_SIZE.y + OFFSET.y)
	# PLATFORM_SIZE와 OFFSET을 이용하여 플랫폼 좌표 반환

##################################################
func _on_reset_game_signal() -> void:	
# 게임 리셋 신호 수신 시 실행할 함수
	for platform in get_tree().get_nodes_in_group("Platform"):
	# 그룹이 Platform인 인스턴스들을 platform으로 순회하며
		remove_child(platform)
		# 자식 노드에서 제거
		platform.queue_free()
		# 인스턴스 제거
		platform = null
		# 혹시 모를 쓰레기 객체가 되지 않기 위해 설정

	platform_array.clear()
	# platform_array 초기화
	steps = 0
	# steps 초기화
	
	init_platforms()
	# 처음 두 단 플랫폼 설정 함수
	generate_platforms()
	# PLATFORM_COUNT 개수만큼 플랫폼 설정 함수
	draw_platforms()
	# 각 플랫폼 인스턴스화 및 그리는 함수
	
	GM.set_game_over(false)
	# 개임 매니저 게임 오버 아니도록 설정
