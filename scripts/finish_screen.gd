extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect._set_size(get_viewport().get_visible_rect().size)
	self.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_next_pressed():
	load.load_level(load.get_next_level())
	self.set_visible(false)

