extends Node
@warning_ignore_start("unused_signal")

signal DEBUG_error_generated(error: Debug.Error) # on new Error generation
signal DEBUG_print_errors # for now, at end of game.gd _ready, after GAME_started

signal GAME_quit # when quit is selected in the menu
signal GAME_started(game: Node) # at end if game.gd _ready()
signal GAME_save_loaded(save_file: ConfigFile) # upon successful load of a save
signal GAME_update_save(section: String, key: String, value: Variant) # in many places