extends Node

var attemps = 0

func _ready():
	load.playing = true
	load.current_level_name = "level_base"
	load.post_loading_setup()
func _process(delta):
	if load.loading and not load.loading_screen_playing:
		load.get_level_loading_status()
	if load.player.global_transform.origin.y < -0.1 and load.playing:
		game_over()

func game_over():
	load.playing = false
	load.load_level(load.current_level_name)

func _on_finish_body_entered(area):
	if area == load.player:
		load.playing = false
		$GUI/finish_screen.set_visible(true)
