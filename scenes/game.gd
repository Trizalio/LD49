extends MarginContainer

onready var map = $parts/centered/map

func _ready():
	Matrix.connect("appear_on_the_field", self, 'unit_appeared')
	
	GameState.start_new_game()

func unit_appeared(column_pos, line_pos):
	print('unit_appeared:', column_pos, " ", line_pos)
	var unit = Matrix.get_cell(column_pos, line_pos)
	var node_name = str(column_pos) + str(line_pos)
#	map.get_child()
#	map.add_child_below_node(node_name)
	


func _on_Button_pressed():
	GameState._next_turn()
