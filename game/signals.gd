extends Node

signal kill()
signal player_moved(pos)
signal player_entered_bash_state()
signal player_exited_bash_state(bash)

signal player_exited_lg()

signal new_checkpoint(loc, scene)
