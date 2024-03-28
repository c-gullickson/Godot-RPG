extends Node

func load_json_by_path(file_path: String) -> Dictionary:
	print("Loading Filepath: " + file_path)
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	
	return json_data
	
func load_spritesheet_by_path(file_path: String):
	print("Loading Filepath: " + file_path)
