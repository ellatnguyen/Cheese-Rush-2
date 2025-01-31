extends Resource
class_name MyResource

@export var scatter_targets: Array[NodePath]
@export var at_home_targets: Array[NodePath]

func get_scatter_targets(parent: Node) -> Array[Node2D]:
	var nodes: Array[Node2D] = []
	for path in scatter_targets:
		var node = parent.get_node(path) as Node2D
		if node:
			nodes.append(node)
	return nodes

func get_at_home_targets(parent: Node) -> Array[Node2D]:
	var nodes: Array[Node2D] = []
	for path in at_home_targets:
		var node = parent.get_node(path) as Node2D
		if node:
			nodes.append(node)
	return nodes
