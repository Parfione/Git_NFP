extends Node

func ImportCSV(path:String):
	if !FileAccess.file_exists(path) : return {}
	var file = FileAccess.open(path,FileAccess.READ)
	var data = {}
	var keys = Array(file.get_csv_line())
	
	while !file.eof_reached():
		var line = Array(file.get_csv_line())
		if !line[0]: continue
		var data_set = {}
		data[line[0]] = data_set
		for k in range(1,len(keys)):
			data_set[keys[k]] = line[k]
	
	return data


