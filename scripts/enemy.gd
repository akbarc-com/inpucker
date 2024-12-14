extends CharacterBody2D

const speed := 50

@onready var player := get_tree().get_current_scene().get_node('Player')
var player_pos
var target_pos
var hp := 100

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(player.position) * speed
	if position.distance_to(player.position) > 10:
		move_and_slide()

func hurt(dmg):
	hp -= dmg
	
	if hp <= 0:
		queue_free()
