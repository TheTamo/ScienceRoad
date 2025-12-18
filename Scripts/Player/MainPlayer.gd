extends CharacterBody2D


var input
@export var runspeed = 150
@export var basicspeed = 75
var speed
@export var gravity = 10

#Jumpvar
var jump_count = 0
@export var max_jump = 1
@export var jump_force=375



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta)


func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input != 0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed,100.0,speed)
			$Sprite2D.scale.x = 1
			if Input.get_action_strength("IG_Run")>10:
				$anim.play("Walk",-1,1.5)
			else:
				$anim.play("Walk",-1,1)
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed,100.0,-speed)
			$Sprite2D.scale.x = -1
			if Input.get_action_strength("IG_Run")>10:
				$anim.play("Walk",-1,1.5)
			else:
				$anim.play("Walk",-1,1)
						
	if input==0:
		velocity.x = 0	
		$anim.play("Idle")
	
	#Run
	if Input.is_action_pressed("IG_Run"):
		speed = runspeed
		
	if !Input.is_action_pressed("IG_Run"):
		speed = basicspeed
		
	
	
	#JumpCode
	
	if is_on_floor():
		jump_count = 0
	
	if !is_on_floor():
		if velocity.y < 0:
			$anim.play("Jump")
		if velocity.y > 0:
			$anim.play("Fall")
	
	
	if Input.is_action_pressed("IG_Jump") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force
		velocity.x = input
		
		
	if !is_on_floor() && Input.is_action_just_pressed("IG_Jump") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force * 1.2
		velocity.x = input			
			
		
		
	if !is_on_floor() && Input.is_action_just_released("IG_Jump") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
	else:
		gravity_force()
	
	
	
	
		
	gravity_force()
	move_and_slide()

	
func gravity_force():
	velocity.y += gravity
