extends Node
## An example headless check. Copy it to tests/<topic>_check.gd + .tscn for each system.
## Run: tools/dev.sh check example   (or: godot --headless --path . res://tests/example_check.tscn)
## Exit code = number of failed checks, so scripts and Claude can tell pass from fail.

var _failed: int = 0


func _ready() -> void:
	_check_maths()
	print("example_check: %d failed" % _failed)
	get_tree().quit(_failed)


## Replace with real checks: load a scene or Resource, poke it, compare the result.
func _check_maths() -> void:
	_check("two plus two", 2 + 2 == 4, str(2 + 2))


func _check(label: String, ok: bool, got: String = "") -> void:
	if ok:
		return
	_failed += 1
	print("FAIL %s (got %s)" % [label, got])
