extends Node
## The smoke check: every script, scene, resource and shader in the project loads, and the main
## scene plays for a moment. Any error Godot prints fails it too (a missing node, a failed load,
## a push_error): tools/dev.sh reads the output for one. An error a check expects on purpose goes
## in tests/expected_errors.txt.
## Run: tools/dev.sh check smoke   (or: godot --headless --path . res://tests/smoke_check.tscn)
## A check for one system copies this pattern to tests/<topic>_check.gd + .tscn: load a scene or
## Resource, poke it, compare the result with _check(). Exit code 1 = a failure.

const PLAY_SECONDS := 1.0
## What must load, by file extension.
const LOADED: PackedStringArray = ["gd", "tscn", "tres", "gdshader"]

var _failed: int = 0


func _ready() -> void:
	_check_files("res://")
	var scene := _load_main_scene()
	print("smoke_check: %d failed" % _failed)
	# Quit through the tree, not this node: the game may change scene, which frees this node.
	var tree := get_tree()
	var code := 1 if _failed > 0 else 0
	tree.create_timer(PLAY_SECONDS).timeout.connect(func() -> void: tree.quit(code))
	if scene:
		print("smoke_check: playing the main scene")
		tree.root.add_child.call_deferred(scene)


## Every script, scene, resource and shader outside addons/ and folders with a .gdignore must
## load: a parse error, a file a scene points at that is gone, or a shader that doesn't compile
## shows up here even when nothing uses it yet. Each file is named before it loads, so
## tools/dev.sh can say which one an error Godot prints belongs to.
func _check_files(dir: String) -> void:
	for sub in DirAccess.get_directories_at(dir):
		var path := dir.path_join(sub)
		if sub.begins_with(".") or path == "res://addons":
			continue
		if FileAccess.file_exists(path.path_join(".gdignore")):
			continue
		_check_files(path)
	for file in DirAccess.get_files_at(dir):
		if not LOADED.has(file.get_extension()):
			continue
		var path := dir.path_join(file)
		print("smoke_check: checking ", path)
		var loaded: Resource = load(path)
		if loaded is Script:
			_check("script loads: " + path, (loaded as Script).can_instantiate())
		elif loaded is Shader:
			# Godot compiles a shader when it is first used, not when it loads: asking for its
			# uniforms uses it.
			(loaded as Shader).get_shader_uniform_list()
		else:
			_check("loads: " + path, loaded != null)


func _load_main_scene() -> Node:
	var path: String = ProjectSettings.get_setting("application/run/main_scene", "")
	if path.is_empty():
		_check("a main scene is set (Project > Project Settings > Application > Run)", false)
		return null
	var packed := load(path) as PackedScene
	_check("main scene loads: " + path, packed != null)
	return packed.instantiate() if packed else null


func _check(label: String, ok: bool) -> void:
	if ok:
		return
	_failed += 1
	print("FAIL %s" % label)
