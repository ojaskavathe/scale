extends Node2D

var confetti_preload = preload("res://entity/object/confetti_emitter.tscn")

@onready var first_level: Node2D = $LevelGroups/LG_0/levels/Debug0
@onready var player: CharacterBody2D = $Player

var checkpoint_loc: Vector2
var currentScene: Node2D

func _ready():
	Signals.kill.connect(_on_kill)
	Signals.new_checkpoint.connect(_new_checkpoint)
	Signals.player_exited_lg.connect(_new_lg)
	
	checkpoint_loc = first_level.get_node("SpawnJumpPoint").position
	
	player.position = checkpoint_loc
	player.jump_point_position = checkpoint_loc
	player.bash_state = true

func _on_kill():
	# get_tree().call_deferred("reload_current_scene")
	spawn_confetti(player.position)
	# print("respawn: ", checkpoint_loc)
	player.position = checkpoint_loc
	player.jump_point_position = checkpoint_loc
	player.bash_state = true
	Signals.player_moved.emit(checkpoint_loc)

func spawn_confetti(pos):
	var confetti = confetti_preload.instantiate()
	confetti.set_position(pos)
	add_child.call_deferred(confetti)

func _new_checkpoint(loc, scene):
	# print("new checkpoint: ", loc)
	checkpoint_loc = loc
	
	currentScene = scene
	scene.get_node("BottomKillzone").get_node("KillZone").monitoring = true

func _new_lg():
	var lg_ref: Node2D = currentScene.get_parent().get_parent()
	var next_lg_idx: int = lg_ref.name.substr(3).to_int() + 1
	var next_lg: Node2D = lg_ref.get_parent().get_node("LG_" + str(next_lg_idx));
	
	if next_lg:
		var left_rocks: Node2D = next_lg.get_node("LeftRocks")
		var right_rocks: Node2D = next_lg.get_node("RightRocks")
		
		var tween = get_tree().create_tween()
		tween.set_parallel();
		tween.tween_property(left_rocks, "position", Vector2(0, left_rocks.position.y), 2.5)
		tween.tween_property(right_rocks, "position", Vector2(0, right_rocks.position.y), 2.5)
