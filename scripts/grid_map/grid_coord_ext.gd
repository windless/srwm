## GridCoordExt
## GridCoord 的扩展静态方法集合

class_name GridCoordExt


## 获取指定坐标的所有相邻坐标（上下左右四个方向）
static func get_adjacent_coords(coord: GridCoord) -> Array[GridCoord]:
	var adjacent: Array = []
	adjacent.append(GridCoord.new(coord.x, coord.y - 1))  # 上
	adjacent.append(GridCoord.new(coord.x, coord.y + 1))  # 下
	adjacent.append(GridCoord.new(coord.x - 1, coord.y))  # 左
	adjacent.append(GridCoord.new(coord.x + 1, coord.y))  # 右
	return adjacent


## 获取矩形区域内的所有坐标
static func get_rect_coords(min_coord: GridCoord, max_coord: GridCoord) -> Array[GridCoord]:
	var coords: Array = []
	for y in range(min_coord.y, max_coord.y + 1):
		for x in range(min_coord.x, max_coord.x + 1):
			coords.append(GridCoord.new(x, y))
	return coords


## 获取指定半径范围内的所有坐标（曼哈顿距离）
static func get_coords_in_range(center: GridCoord, radius: int) -> Array[GridCoord]:
	var coords: Array = []
	for y in range(center.y - radius, center.y + radius + 1):
		for x in range(center.x - radius, center.x + radius + 1):
			var coord := GridCoord.new(x, y)
			if center.manhattan_distance(coord) <= radius:
				coords.append(coord)
	return coords