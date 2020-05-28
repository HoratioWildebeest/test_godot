tool
extends Control

export var background_color: Color
export var focus_color: Color

var stats: = []
var focus: = false
var grabbed: = false

func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_process_input(false)
	
	$Label/Panel.modulate = background_color

func _process(delta):
	var label_text = ""
	
	for s in stats:
		var value = null
		if s[1] and is_instance_valid(s[1]):
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		label_text += s[0] + ": " + str(value) + "\n"
	
	$Label.text = label_text

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_QUOTELEFT and not event.is_pressed():
			focus = not focus
			if focus:
				$Label/Panel.modulate = focus_color
			else:
				$Label/Panel.modulate = background_color
				grabbed = false
	
	
	if event is InputEventMouseButton:
		if focus:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					var mouse_pos = get_local_mouse_position()
					if mouse_pos.x >= 0 and mouse_pos.y >= 0 and mouse_pos.x <= rect_size.x and mouse_pos.y <= rect_size.y:
						grabbed = true
				else:
					grabbed = false
	
	if event is InputEventMouseMotion:
		if grabbed:
			rect_global_position += event.relative

func add_stat(stat_name, object, stat_ref, is_method):
	stats.append([stat_name, object, stat_ref, is_method])
