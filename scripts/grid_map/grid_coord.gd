## GridCoord
## 网格坐标结构体，用于统一表示地图上的网格位置
## 基于 Vector2i 实现，支持斜视角坐标转换

class_name GridCoord
extends RefCounted

## 坐标 X 值
var x: int = 0
## 坐标 Y 值
var y: int = 0


## 通过 x, y 参数初始化
func _init(coord_x: int = 0, coord_y: int = 0) -> void:
	x = coord_x
	y = coord_y


## 通过 Vector2i 初始化
static func from_vector2i(vec: Vector2i) -> GridCoord:
	return GridCoord.new(vec.x, vec.y)


## 转换为 Vector2i
func to_vector2i() -> Vector2i:
	return Vector2i(x, y)


## 检查坐标是否在指定边界范围内
## bounds: Vector2i 格式 (width, height)
func is_valid_in_bounds(bounds: Vector2i) -> bool:
	return x >= 0 and y >= 0 and x < bounds.x and y < bounds.y


## 检查坐标是否为负值
func is_negative() -> bool:
	return x < 0 or y < 0


## 坐标加法运算
func add(other: GridCoord) -> GridCoord:
	return GridCoord.new(x + other.x, y + other.y)


## 计算与另一个坐标的曼哈顿距离
func manhattan_distance(other: GridCoord) -> int:
	return absi(x - other.x) + absi(y - other.y)


## 判断是否与另一个坐标相邻（曼哈顿距离为1）
func is_adjacent(other: GridCoord) -> bool:
	return manhattan_distance(other) == 1


## 将网格坐标转换为斜视角屏幕坐标
## cell_size: TileMap 单元格尺寸，如 Vector2(64, 32)
func to_screen(cell_size: Vector2) -> Vector2:
	# Isometric 坐标转换公式:
	# screen_x = (x - y) * (cell_size.x / 2)
	# screen_y = (x + y) * (cell_size.y / 2)
	var half_width: float = cell_size.x / 2.0
	var half_height: float = cell_size.y / 2.0
	return Vector2(
		(x - y) * half_width,
		(x + y) * half_height
	)


## 从屏幕坐标转换为网格坐标
## screen_pos: 屏幕位置
## cell_size: TileMap 单元格尺寸，如 Vector2(64, 32)
static func from_screen(screen_pos: Vector2, cell_size: Vector2) -> GridCoord:
	# Isometric 坐标逆向转换公式:
	# x = (screen_x / half_width + screen_y / half_height) / 2
	# y = (screen_y / half_height - screen_x / half_width) / 2
	var half_width: float = cell_size.x / 2.0
	var half_height: float = cell_size.y / 2.0
	var grid_x: float = (screen_pos.x / half_width + screen_pos.y / half_height) / 2.0
	var grid_y: float = (screen_pos.y / half_height - screen_pos.x / half_width) / 2.0
	return GridCoord.new(int(roundf(grid_x)), int(roundf(grid_y)))


## 相等比较
func equals(other: GridCoord) -> bool:
	return x == other.x and y == other.y


## 字符串表示
func _to_string() -> String:
	return "GridCoord(%d, %d)" % [x, y]