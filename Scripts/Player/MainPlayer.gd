extends CharacterBody2D
var input

#RunAndWalk Var
@export var runspeed = 120
@export var basicspeed = 70
var speed
@export var gravity = 325

#JumpVar
var jump_count = 0
@export var max_jump = 1
@export var jump_force= 150

#AttackVar
var is_attacking = false
var combo_step = 0
var combo_timer = 0.0
@export var combo_reset_time := 2
var air_attack_used = false

#AttackDashVar
var attack_pulse := 0.0



func _ready() -> void:
	speed = basicspeed
	pass 
	

func _process(delta: float) -> void:
	attack_process(delta)
	movement(delta)
	
	
func movement(delta):
	
	if is_attacking:
		move_and_slide()
		return



	#Run
	if Input.is_action_pressed("IG_Run"):
		speed = runspeed
	else:
		speed = basicspeed
		
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input != 0:
		
		if input > 0:
			velocity.x = speed
			$Sprite2D.scale.x = 1
			

			if Input.is_action_pressed("IG_Run"):
				$anim.play("Run",-1,1.5)
			else:
				$anim.play("Run",-1,1)

		if input < 0:
			velocity.x = -speed
			$Sprite2D.scale.x = -1

			if Input.is_action_pressed("IG_Run"):
				$anim.play("Run",-1,1.5)
			else:
				$anim.play("Run",-1,1)
				
	if input==0:
		velocity.x = 0
		$anim.play("Idle")
		
	#JumpCode
	if is_on_floor():
		jump_count = 0
		air_attack_used = false
		
	if !is_on_floor():
		
		if velocity.y < 0:
			$anim.play("Jump")
		if velocity.y == 0:
			$anim.play("Jump_Peak")
		if velocity.y > 0:
			$anim.play("Fall")
			
	if Input.is_action_pressed("IG_Jump") and is_on_floor() and jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force
		velocity.x = input * speed
		
	if !is_on_floor() and Input.is_action_just_pressed("IG_Jump") and jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force * 1.2
		velocity.x = input * speed
		
	if !is_on_floor() and Input.is_action_just_released("IG_Jump") and jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input * speed
		
	gravity_force(delta)
	move_and_slide()
	
func gravity_force(delta):
	velocity.y += gravity * delta

func play_attack(anim_name):
	if anim_name == "AirAttack":
		velocity.y = max(velocity.y, 0)
	is_attacking = true
	velocity.x = 0
	$anim.play(anim_name)
	


func attack_process(delta):

	if combo_timer > 0:
		combo_timer -= delta
	else:
		combo_step = 0


	if Input.is_action_just_pressed("IG_Attack") and !is_attacking:
		
		var dir = sign($Sprite2D.scale.x)
		attack_pulse = dir * 8
		
		if !is_on_floor() and !air_attack_used:
			air_attack_used = true
			play_attack("AirAttack")
			
		if is_on_floor():
			combo_step += 1
			
			if combo_step > 3:
				combo_step = 1

			match combo_step:
				1:
					play_attack("Attack1")
				2:
					play_attack("Attack2")
				3:
					play_attack("Attack3")
					
			combo_timer = combo_reset_time
			


func _on_anim_animation_finished(anim_name):
	if anim_name.begins_with("Attack") or anim_name == "AirAttack" or anim_name == "SpecialAttack":
		is_attacking = false
		
		
func _physics_process(_delta):

	if attack_pulse != 0:
		move_and_collide(Vector2(attack_pulse, 0))
		attack_pulse = 0

	move_and_slide()
