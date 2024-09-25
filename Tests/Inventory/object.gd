extends Node2D


var draggable = false
var is_inside_dropable = false
var body_ref
var initialPos:Vector2
var offset:Vector2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "position", body_ref.position, 0)
			else:
				tween.tween_property(self, "global_position", initialPos, 0)
				
			






func _on_area_2d_body_entered(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.modulate = Color(0, 0, 0, 1)
		body_ref = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(0, 0, 0, 0.2)










func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1.0, 1.0)
