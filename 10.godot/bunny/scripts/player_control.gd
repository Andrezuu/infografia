extends Node2D

class_name PlayerControl

# signals
signal do_attack
signal do_move(input_vector)

@export var body: CharacterBody2D
@onready var first_chicken: CharacterBody2D = $"/root/Main/Chicken"
@onready var second_chicken: CharacterBody2D = $"/root/Main/Chicken2"
var xd

@onready var timer = $Timer

@onready var chickens: Array[CharacterBody2D]= [first_chicken, second_chicken]
const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 100
@onready var EGG = preload("res://scenes/egg.tscn")

enum {
	MOVE,
	ATTACK
}

var state = MOVE

var input_vector
var last_direction



func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
			
func move_state(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("Left", "Right")
	input_vector.y = Input.get_axis("Up", "Down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		do_move.emit(input_vector)
		body.velocity = body.velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		last_direction = input_vector
	else:
		body.velocity = body.velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	body.move_and_slide()
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
		do_attack.emit()
		timer.start()
		print("attack")
	
	if Input.is_action_just_pressed("CreateEgg"):
		create_marker_at_position(global_position)


func attack_state(delta):
	body.velocity = Vector2.ZERO
	
func attack_anim_finished():
	state = MOVE
	do_move.emit(last_direction)


func _on_timer_timeout() -> void:
	attack_anim_finished()


func create_marker_at_position(position: Vector2):
	
	var egg = EGG.instantiate() 
	egg.position = position
	var root = get_tree().root.get_child(0)
	if root:
		root.add_child(egg)
		print('xd', egg)
		print(chickens)
		for chicken in chickens:
			if chicken.has_method("add_target"):
				chicken.add_target(egg)
	else:
		print("Error: El nodo actual no es válido para agregar hijos.")

func register_new_chicken(new_chicken: CharacterBody2D) -> void:
	print(new_chicken, 'new chicken')
	
	
	chickens.append(new_chicken)
	add_child(new_chicken)
	#print_all_nodes(xd)
	#var root =/ get_tree().root.get_child(0)
	#print(root, 'root')
	#if root:
		#root.add_child(new_chicken)
