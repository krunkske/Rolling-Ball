extends Node

@onready var levelFile = "res://levels.csv"
@onready var levelFileContent = load_file(levelFile)

@onready var main = get_tree().root.get_node("main")
@onready var player = main.get_node("player")
@onready var level = main.get_node("level_base")
@onready var grid = level.get_node("GridMap")
@onready var spawnPoint = level.get_node("Spawn")
@onready var finish = level.get_node("Finish")

@onready var GUI_node = main.get_node("GUI")
@onready var loading_screen_node = GUI_node.get_node("loading_screen")

@export var current_level_name = ""

var playing = false
var loading = false
var loading_screen_playing = false

#get_next_level will get the next level name in the levelfile.
#load_level will check if the specified levelname exist and start loading the level
#finished_loading will be called when get_level_loading_status calls it when the level is done loading. this function will replace the current level with the new one
#post_loading_setup will reset some variables and get the gridmap, spawnpoint and finish. it resets the player and connects the finish collision signal
#get_level_loading_status will get the status of the ResourceLoader and act according to it's return value

func get_next_level():
	var next = false
	for i in levelFileContent:
		if next and i[0] != "":
			return i[0]
		if i[0] == current_level_name:
			next = true
	return levelFileContent[0][0]

func load_level(levelName):
	if ResourceLoader.exists("res://scenes/levels/" + levelName + ".tscn"):
		ResourceLoader.load_threaded_request("res://scenes/levels/" + levelName + ".tscn")
		current_level_name = levelName
		loading = true
		loading_screen_node.scroll_to_left()
	else:
		print(levelName + " does not exist")

func finished_loading():
	var newLevel:PackedScene = ResourceLoader.load_threaded_get("res://scenes/levels/" + current_level_name + ".tscn")
	level.queue_free()
	level = newLevel.instantiate()
	main.add_child(load.level)
	
	post_loading_setup()

func post_loading_setup():
	grid = level.get_node("GridMap")
	spawnPoint = level.get_node("Spawn")
	finish = level.get_node("Finish")
	
	player.global_transform.origin = spawnPoint.global_transform.origin
	player.linear_velocity = Vector3.ZERO
	player.angular_velocity = Vector3.ZERO
	
	finish.body_entered.connect(main._on_finish_body_entered)
	load.playing = true

func get_level_loading_status():
	var status = ResourceLoader.load_threaded_get_status("res://scenes/levels/" + load.current_level_name + ".tscn")
	if status == 0:
		print("Invalid resource")
		loading = false
	elif status == 1:
		pass
	elif status == 2:
		print("Loading " + current_level_name + " failed.")
		load_level(current_level_name)
	elif status == 3:
		print("level loaded.")
		loading_screen_node.scroll_to_right()
		finished_loading()
		loading = false
	else:
		print("invalid or no error code: " + str(status))

func load_file(file):
	var File = FileAccess.open(file, FileAccess.READ)
	var content = []
	while not File.eof_reached():
		content.append(File.get_csv_line())
	return content
