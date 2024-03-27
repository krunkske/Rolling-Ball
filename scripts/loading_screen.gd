extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect._set_size(get_viewport().get_visible_rect().size)
	self.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func scroll_to_left():
	self.set_visible(true)
	load.loading_screen_playing = true
	trans_in()
	await trans_in

func scroll_to_right():
	trans_out()
	await trans_out


func trans_in():
	$AnimationPlayer.play("in")

func trans_out():
	$AnimationPlayer.play("out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "in":
		load.loading_screen_playing = false
	elif anim_name == "out":
		load.loading_screen_playing = false
		self.set_visible(false)
