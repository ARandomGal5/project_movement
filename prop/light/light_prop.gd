@tool
extends Node3D
class_name LightProp3D
var emissive_textures : Array[StandardMaterial3D]
var lights : Array[Light3D]
var EmissiveToggled := true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_child_count():
		if get_child(i).name.begins_with("-toggle") && get_child(i) is MeshInstance3D:
			var node: MeshInstance3D = get_child(i)
			var mesh := node.mesh;
			var unique_material = mesh.surface_get_material(0).duplicate()
			node.set_surface_override_material(0, unique_material);
			emissive_textures.append(unique_material);
		if get_child(i) is Light3D:
			lights.append(get_child(i));
			
func _physics_process(delta: float) -> void:
	for i in lights.size():
		if lights[i].visible:
			if !EmissiveToggled:
				toggle_emissives(true)
			break;
		if i == lights.size() - 1 && !lights[i].visible:
			toggle_emissives(false);

func toggle_emissives(on: bool):
	for i in emissive_textures.size():
		emissive_textures[i].emission_enabled = on;
		EmissiveToggled = on;
