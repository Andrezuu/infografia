extends CharacterBody2D

@export var targets = []
@export var max_speed = 50
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var CHICKEN = preload("res://scenes/chicken.tscn")
@onready var CONTROL_SCRIPT = preload("res://scripts/player_control.gd").new()
func setup():
	await get_tree().physics_frame
	if targets:
		for target in targets:
			navigation.target_position = target.global_position

func _ready() -> void:
	call_deferred("setup")
	print(navigation.get_current_navigation_path())
	
func _physics_process(delta: float) -> void:
	if targets:
		for target in targets:
			if not is_instance_valid(target):
				continue
			navigation.target_position = target.global_position
			if navigation.is_navigation_finished():
				print('antes de convertir')
				convert_egg_to_chicken(target)
				print('despues de convertir')
				return
	
	var nex_path_position = navigation.get_next_path_position()
	
	velocity = global_position.direction_to(nex_path_position) * max_speed
	
	move_and_slide()
	
func add_target(new_target):
	print(new_target, 'mi nuevo target')
	targets.append(new_target)
	print(targets)

func convert_egg_to_chicken(egg: Node2D) -> void:
	var new_chicken = CHICKEN.instantiate()
	new_chicken.set_script(CHICKEN.get_script())
	new_chicken.position = egg.position  # Colocar el nuevo chicken en la posición del huevo
	var root = get_tree().root.get_child(0)
	if root:
		root.add_child(new_chicken)  # Agregar el nuevo chicken a la escena principal
		egg.queue_free()  # Eliminar el huevo
		targets = targets.filter(func(x): x != null)
		print("Egg convertido en Chicken:", new_chicken)
		CONTROL_SCRIPT.register_new_chicken(new_chicken)
		#var xd = root
		

	
