extends Node
@warning_ignore_start("unused_signal")

signal DEBUG_error_generated(error: Debug.Error) # on new Error generation
signal DEBUG_print_errors # for now, at end of game.gd _ready, after GAME_started

signal GAME_started(game: Node) # at end if game.gd _ready()
signal GAME_new_game_created # upon successful creation of a new Save