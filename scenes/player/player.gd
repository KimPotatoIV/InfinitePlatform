extends CharacterBody2D

##################################################
enum STATE {
	IDLE_L,
	IDLE_R,
	JUMP_L,
	JUMP_R
}
# 현재 상태 설정 가능한 열거형 변수 설정

const MOVING_SPEED = 200.0
# 이동 속도
const JUMP_VELOCITY = -550.0
# 점프 강도
const INIT_POSITION: Vector2 = Vector2(180.0, 484.0)
# 초기 좌표
const GRAVITY_SCALE = 2.0
# 중력 강도 조절 값
const VELOCITY_X_SCALE = 145.0
# 좌우 이동 강도 조절 값
const GAME_OVER_VELOCITY_Y = 300.0
# 게임 오버 확인 가능한 velocity Y 값

var camera_node: Camera2D
# 카메라 노드
var anim_sprite_node: AnimatedSprite2D
# 애니메이션 스프라이트 노드
var direction: int = -1
# 방향. 왼쪽: -1, 오른쪽: 1
var state: STATE = STATE.IDLE_L
# 현재 상태
var played_sound: bool = false
# 효과음 재생 여부

##################################################
func _ready() -> void:
	global_position = INIT_POSITION
	# 현재 좌표를 초기 좌표로 설정
	
	camera_node = $Camera2D
	# 카메라 노드 설정
	camera_node.position_smoothing_enabled = true
	# 카메라 지연 이동 설정
	
	anim_sprite_node = $AnimatedSprite2D
	# 애니메이션 스프라이트 노드 설정
	set_state(state)
	# state 값에 따라 애니메이션 설정

##################################################
func _physics_process(delta: float) -> void:
	if not is_on_floor():
	# 바닥에 닿아 있지 않으면
		velocity += get_gravity() * delta * GRAVITY_SCALE
		# GRAVITY_SCALE에 따라 중력 적용
		if direction == -1:
			state = STATE.JUMP_L
		else:
			state = STATE.JUMP_R
		# direction에 따라 state 값 설정
	else:
	# 바닥에 닿아 있다면
		velocity.x = 0
		# 좌우 이동 멈추기 위한 설정
		if direction == -1:
			state = STATE.IDLE_L
		else:
			state = STATE.IDLE_R
		# direction에 따라 state 값 설정
	
	set_state(state)
	# state 값에 따라 애니메이션 설정
	
	if Input.is_action_just_pressed("ui_space"):
	# 스페이스 키를 눌렀을 때
		if is_on_floor() and not GM.get_game_over():
		# 바닥에 닿아 있고 게임 오버 상태가 아니라면
		# 위는 플랫폼 회전과 오르기를 동시에 하는 상태
			change_direction()
			# 방향 전환 관련 설정
			climbing()
			# 플랫폼 오르기 관련 설정
			GM.set_score(GM.get_score() + 1)
			# 게임 매니저 실시간 점수 1 증가
			GM.set_player_moving(true)
			# 게임 매니저 플레이어 이동 중으로 설정
			GM.save_best_score()
			# 게임 매니저 최고 점수 저장
			SM.score_sound_play()
			# 사운드 매니저 점수 올라가는 효과음 재생
		elif GM.get_game_over():
		# 게임 오버 상태라면
			reset_game()
			# 게임 초기화
	
	if Input.is_action_just_pressed("ui_enter") and is_on_floor():
	# 엔터 키를 눌렀으면서 바닥에 닿아 있다면
	# 위는 플랫폼 오르기를 하는 상태
		climbing()
		# 플랫폼 오르기 관련 설정
		GM.set_score(GM.get_score() + 1)
		# 게임 매니저 실시간 점수 1 증가
		GM.set_player_moving(true)
		# 게임 매니저 플레이어 이동 중으로 설정
		GM.save_best_score()
		# 게임 매니저 최고 점수 저장
		SM.score_sound_play()
		# 사운드 매니저 점수 올라가는 효과음 재생

	move_and_slide()
	# 물리 효과 적용

##################################################
func _process(delta: float) -> void:
	if velocity.y > GAME_OVER_VELOCITY_Y:
	# GAME_OVER_VELOCITY_Y보다 velocity.y가 크디면
	# 위는 플랫폼에 안착하지 못하고 낙하하는 상태
		GM.set_game_over(true)
		# 게임 매니저 게임 오버 설정
		if not played_sound:
		# 효과음 재생 여부 변수가 false라면
			played_sound = true
			#효과음 재생 여부 변수 true로 설정
			SM.game_over_sound_play()
			# 사운드 매니저 게임 오버 효과음 재생

##################################################
func climbing() -> void:
# 플랫폼 오르기 관련 설정 함수
	velocity.x = direction * VELOCITY_X_SCALE
	# VELOCITY_X_SCALE에 따른 좌우 이동 강도 설정
	velocity.y = JUMP_VELOCITY
	# JUMP_VELOCITY에 따른 점프 강도 설정

##################################################
func change_direction() -> void:
# 방향 전환 관련 설정 함수
	direction = -direction
	# 방향 전환 1에서 -1 또는 -1에서 1로
	anim_sprite_node.flip_h = (direction == -1)
	# 왼쪽 방향이면 anim_sprite_node 가로 대칭 전환

##################################################
func reset_game() -> void:
# 게임 초기화 함수
	global_position = INIT_POSITION
	# 현재 좌표를 초기 좌표로 설정
	GM.set_score(0)
	# 게임 매니저 게임 점수 초기화
	direction = -1
	# 방향 초기화
	anim_sprite_node.flip_h = true
	# 왼쪽을 바라보도록 초기화
	SB.reset_game()
	# 시그널 버스(SB) reset_game() 함수 호출
	# 이 호출로 spawner.gd에서 플랫폼을 초기화
	played_sound = false
	# 효과음 재생 여부 변수 초기화

##################################################
func set_state(state_value: STATE) -> void:
# state_value 값에 따라 애니메이션 설정하는 함수
	match state_value:
	# state_value에 따라
		STATE.IDLE_L:
			anim_sprite_node.flip_h = true
			# 명시적으로 적어줌
			anim_sprite_node.play("idle_l")
		STATE.IDLE_R:
			anim_sprite_node.flip_h = false
			anim_sprite_node.play("idle_r")
		STATE.JUMP_L:
			anim_sprite_node.flip_h = true
			# 명시적으로 적어줌
			anim_sprite_node.play("jump_l")
		STATE.JUMP_R:
			anim_sprite_node.flip_h = false
			anim_sprite_node.play("jump_r")
