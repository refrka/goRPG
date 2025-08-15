extends Node

const SceneKey = Enums.SceneKey

var active_scene: Scene
var scenes: Array
var roots: Array

class Root:
	var root_node: Node
	func _init(node: Node) -> void:
		root_node = node

class Scene:
	var scene_path: String
	var scene_packed: PackedScene
	var scene_node: Node
	func _init(scene_key: SceneKey) -> void:
		scene_path = Reference.get_scene_path(scene_key)
		if scene_path == "":
			Debug.log_error(Enums.ErrorKey.SCENE_PATH)
		else:
			scene_packed = load(scene_path)
			scene_node = scene_packed.instantiate()

	func _get_path(scene_key: SceneKey) -> String:
		var path = ""
		if Reference.scene_ref.has(scene_key):
			path = Reference.get_scene_path(scene_key)
		return path

func load_scene(_scene: Scene) -> void:
	if !scenes.has(_scene):
		scenes.append(_scene)
	else:
		Debug.log_error(Enums.ErrorKey.SCENE_DUPLICATE)

func add_root(node: Node) -> Root:
	var new_root = Root.new(node)
	roots.append(new_root)
	return new_root

func add_scene(scene_key: SceneKey, root: Root) -> void:
	var new_scene = Scene.new(scene_key)
	if validate_root(root):
		root.root_node.add_child(new_scene.scene_node)

func validate_root(node: Root) -> bool:
	if !roots.has(node):
		Debug.log_error(Enums.ErrorKey.SCENE_ROOT)
		return false
	else:
		return true
	

