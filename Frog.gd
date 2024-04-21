extends CharacterBody2D

var SPEED = 50
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var PLAYER
var CHASE = false

func _ready():
	get_node("AnimatedSprite2D").play("Jump")

func _physics_process(delta):
	# Gravity for frog
	velocity.y += GRAVITY * delta
	
	# Chase player logic
	if CHASE == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
			PLAYER = get_node("../../Player/Player")
			var direction = (PLAYER.position - self.position).normalized()
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = true
			else:
				get_node("AnimatedSprite2D").flip_h = false
			velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
			velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		CHASE = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		CHASE = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		body.HEALTH -= 5
		death()

func death():
	CHASE = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
		
