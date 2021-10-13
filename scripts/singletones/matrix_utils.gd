extends Node

var right = Vector2(1, 0)
var bot = Vector2(0, 1)
var left = -right
var top = -bot
var bot_right = bot + right
var right_bot = bot_right
var bot_left = bot + left
var left_bot = bot_left
var top_left = top + left
var left_top = top_left
var top_right = top + right
var right_top = top_right

var front_1 = [bot]
var front_3 = [bot_left, bot, bot_right]
var sides = [left, right]
var closest_neighbours = [left, bot, right, top]
var all_neighbours = [left, left_bot, bot, bot_right, right, right_top, top, top_left]

func shift_by(position: Vector2, shifts: Array) -> Array:
	var results: Array = []
	for shift in shifts:
		assert(shift is Vector2)
		results.append(position + shift)
	return results

func filter_existent_positions(positions: Array) -> Array:
	var results: Array = []
	for pos in positions:
		if pos.x < 0 or pos.y < 0:
			continue
		if pos.x >= Matrix.matrix_width or pos.y >= Matrix.matrix_height:
			continue
		results.append(pos)
	return results

func filter_empty_positions(positions: Array) -> Array:
	var results: Array = []
	for pos in positions:
		if Matrix.get_cell(pos).unit != null:
			continue
		results.append(pos)
	return results

func filter_empty_existent_positions(positions: Array) -> Array:
	return filter_empty_positions(filter_existent_positions(positions))

func get_units_by_positions(positions: Array) -> Array:
	var results: Array = []
	for pos in filter_existent_positions(positions):
		var unit = Matrix.get_unit(pos)
		if unit != null:
			results.append(unit)
	return results
	
func filter_units__exclude_race(units: Array, exclude_race) -> Array:
	var results: Array = []
	for unit in units:
		if unit.get_race() != exclude_race:
			results.append(unit)
	return results
	
func filter_units__only_race(units: Array, only_race) -> Array:
	var results: Array = []
	for unit in units:
		if unit.get_race == only_race:
			results.append(unit)
	return results
	
	
func get_units_by_shifts(position_or_unit, shifts: Array, exclude_race=null) -> Array:
	var position = position_or_unit
	if position_or_unit is Unit:
		position = Matrix.get_unit_coordinates(position_or_unit)
	var units = get_units_by_positions(MatrixUtils.shift_by(position, shifts))
	if exclude_race != null:
		units = filter_units__exclude_race(units, exclude_race)
	return units
