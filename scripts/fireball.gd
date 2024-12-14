extends Node2D

@onready var timer: Timer = $Timer
@onready var hurtbox: Area2D = $Hurtbox

var speed := 1000
var target := Vector2.ZERO
var direction := Vector2.ZERO
var dmg := 50

func _ready():
	look_at(position + direction)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	if _body.is_in_group('Player'):
		return
	for body in hurtbox.get_overlapping_bodies():
		if body.is_in_group('Enemy'):
			body.hurt(dmg)
	queue_free()
