extends Area

func _on_Keycard_body_entered(body):
	if body.name == "Player":
		var exit = get_node_or_null("/root/Game/Maze/Exit")
		if exit != null:
			var door_unlock = get_node_or_null("/root/Game/Key")
			if door_unlock != null:
				door_unlock.playing = true
			exit.unlock()
			queue_free()
