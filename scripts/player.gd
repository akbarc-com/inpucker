extends CharacterBody2D

@export var speed := 300
@onready var orb_1: Sprite2D = $Orb1
@onready var orb_2: Sprite2D = $Orb2
@onready var orb_3: Sprite2D = $Orb3

const BLUE_ORB = preload("res://assets/blue_orb.png")
const GREEN_ORB = preload("res://assets/green_orb.png")
const RED_ORB = preload("res://assets/red_orb.png")

const SPELLS = {
	'Fireball': {
		'rune': ['e', 'e', 'w'],
		'name': 'Fireball',
		'scene': preload("res://scenes/fireball.tscn"),
	}
}

var target := position
var orbs := ['q', 'w', 'e']
var slots := ['', '', '', '']

var ready_aim = null

@onready var spell_1: Label = $Camera2D/Control/Spell1
@onready var spell_2: Label = $Camera2D/Control/Spell2
@onready var spell_3: Label = $Camera2D/Control/Spell3
@onready var spell_4: Label = $Camera2D/Control/Spell4

func _ready():
	orbitor()
	
func _input(event):
	if event.is_action_pressed(&"click"):
		if ready_aim:
			cast(get_global_mouse_position())
		else:
			target = get_global_mouse_position()

	if event.is_action_pressed(&"q"):
		orbs.push_front('q')
		orbs.pop_back()
		orbitor()
	
	if event.is_action_pressed(&"w"):
		orbs.push_front('w')
		orbs.pop_back()
		orbitor()
	
	if event.is_action_pressed(&"e"):
		orbs.push_front('e')
		orbs.pop_back()
		orbitor()
	
	if event.is_action_pressed(&"invoke"):
		var sorted = orbs.duplicate()
		sorted.sort()
		for spell in SPELLS.values():
			if sorted == spell.rune:
				slots.push_front(spell.name)
				slots.pop_back()
				var i = 0
				for label in [spell_1, spell_2, spell_3, spell_4]:
					label.set_text(slots[i])
					i = i + 1
	
	if event.is_action_pressed('spell1'):
		aim(slots[0])
	if event.is_action_pressed('spell2'):
		aim(slots[1])
	if event.is_action_pressed('spell3'):
		aim(slots[2])
	if event.is_action_pressed('spell4'):
		aim(slots[3])

func aim(spell):
	if spell == '':
		return
	ready_aim = SPELLS[spell]
	
func cast(pos):
	var spell = ready_aim.scene.instantiate()
	spell.position = position
	spell.target = pos
	spell.direction = global_position.direction_to(pos)
	get_tree().get_current_scene().add_child(spell)
	ready_aim = null

func orbitor():
	var i = 0
	for orb in [orb_1, orb_2, orb_3]:
		if orbs[i] == 'q':
			orb.texture = BLUE_ORB
		elif orbs[i] == 'w':
			orb.texture = GREEN_ORB
		elif orbs[i] == 'e':
			orb.texture = RED_ORB
		i = i + 1

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	#look_at(target)
	if position.distance_to(target) > 10:
		move_and_slide()
