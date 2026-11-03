extends Node
## The smoke check: every script in the project loads, and the main scene loads and plays for a
## moment. A script error while it plays fails it too: tools/dev.sh reads the output for one.
## Run: tools/dev.sh check smoke   (or: godot --headless --path . res://tests/smoke_check.tscn)
## A check for one system copies this pattern to tests/<topic>_check.gd + .tscn: load a scene or
## Resource, poke it, compare the result with _check(). Exit code 1 = a failure.

const PLAY_SECONDS := 1.0

var _failed: int = 0


func _ready() -> void:
	_check_scripts("res://")
	var scene := _load_main_scene()
	print("smoke_check: %d failed" % _failed)
	# Quit through the tree, not this node: the game may change scene, which frees this node.
	var tree := get_tree()
	var code := 1 if _failed > 0 else 0
	tree.create_timer(PLAY_SECONDS).timeout.connect(func() -> void: tree.quit(code))
	if scene:
		tree.root.add_child.call_deferred(scene)


## Every .gd outside addons/ and folders with a .gdignore must load: a parse error shows up here
## even in a script no scene uses yet.
func _check_scripts(dir: String) -> void:
	for sub in DirAccess.get_directories_at(dir):
		var path := dir.path_join(sub)
		if sub.begins_with(".") or path == "res://addons":
			continue
		if FileAccess.file_exists(path.path_join(".gdignore")):
			continue
		_check_scripts(path)
	for file in DirAccess.get_files_at(dir):
		if file.get_extension() == "gd":
			var script := load(dir.path_join(file)) as Script
			_check(
				"script loads: " + dir.path_join(file), script != null and script.can_instantiate()
			)


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
