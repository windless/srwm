@tool
class_name SpriteGenerator
extends RefCounted

## 精灵资源生成器，用于创建 placeholder 精灵表和阴影纹理

const SPRITE_SIZE := 128
const SPRITES_PER_ROW := 8
const DIRECTION_COUNT := 4

## 生成 placeholder 精灵表图像
## 返回一个 Image 对象，包含多台机甲的四方向 placeholder 图像
static func generate_placeholder_sprite_sheet(unit_count: int = 8) -> Image:
	var total_rows := ceili(unit_count / SPRITES_PER_ROW) * DIRECTION_COUNT
	var width := SPRITES_PER_ROW * SPRITE_SIZE
	var height := total_rows * SPRITE_SIZE

	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)

	# 填充每台机甲的四方向 placeholder
	for unit_idx in range(unit_count):
		for dir_idx in range(DIRECTION_COUNT):
			var x := (unit_idx % SPRITES_PER_ROW) * SPRITE_SIZE
			var y := ((unit_idx / SPRITES_PER_ROW) * DIRECTION_COUNT + dir_idx) * SPRITE_SIZE

			_draw_placeholder_unit(image, x, y, unit_idx, dir_idx)

	return image

## 在指定位置绘制一台机甲的 placeholder 图像
static func _draw_placeholder_unit(
	image: Image,
	x: int,
	y: int,
	unit_idx: int,
	dir_idx: int
) -> void:
	# 根据单位索引生成不同颜色
	var colors := [
		Color(0.2, 0.6, 0.8),  # 蓝
		Color(0.8, 0.3, 0.3),  # 红
		Color(0.3, 0.8, 0.3),  # 绿
		Color(0.8, 0.6, 0.2),  # 黄
		Color(0.6, 0.3, 0.8),  # 紫
		Color(0.3, 0.3, 0.8),  # 深蓝
		Color(0.8, 0.3, 0.6),  # 粉
		Color(0.5, 0.5, 0.5),  # 灰
	]
	var base_color: Color = colors[unit_idx % colors.size()]

	# 绘制机甲主体（简单的矩形 + 方向指示）
	var center_x := x + SPRITE_SIZE / 2
	var center_y := y + SPRITE_SIZE / 2

	# 主体
	var body_rect := Rect2i(x + 32, y + 32, 64, 64)
	image.fill_rect(body_rect, base_color)

	# 方向指示箭头
	var arrow_color := Color.WHITE
	_draw_direction_arrow(image, center_x, center_y, dir_idx, arrow_color)

## 绘制方向指示箭头
static func _draw_direction_arrow(
	image: Image,
	cx: int,
	cy: int,
	direction: int,
	color: Color
) -> void:
	# 方向：南=0 (下), 东=1 (右), 北=2 (上), 西=3 (左)
	var arrow_length := 20

	var end_x := cx
	var end_y := cy

	match direction:
		0:  # 南 (下)
			end_y = cy + arrow_length
		1:  # 东 (右)
			end_x = cx + arrow_length
		2:  # 北 (上)
			end_y = cy - arrow_length
		3:  # 西 (左)
			end_x = cx - arrow_length

	# 绘制箭头主线
	_draw_line(image, cx, cy, end_x, end_y, color)

	# 绘制箭头头部
	var head_size := 8
	match direction:
		0:  # 南
			_draw_line(image, end_x - head_size, end_y - head_size, end_x, end_y, color)
			_draw_line(image, end_x + head_size, end_y - head_size, end_x, end_y, color)
		1:  # 东
			_draw_line(image, end_x - head_size, end_y - head_size, end_x, end_y, color)
			_draw_line(image, end_x - head_size, end_y + head_size, end_x, end_y, color)
		2:  # 北
			_draw_line(image, end_x - head_size, end_y + head_size, end_x, end_y, color)
			_draw_line(image, end_x + head_size, end_y + head_size, end_x, end_y, color)
		3:  # 西
			_draw_line(image, end_x + head_size, end_y - head_size, end_x, end_y, color)
			_draw_line(image, end_x + head_size, end_y + head_size, end_x, end_y, color)

## 绘制简单的线段
static func _draw_line(image: Image, x1: int, y1: int, x2: int, y2: int, color: Color) -> void:
	var dx := absi(x2 - x1)
	var dy := absi(y2 - y1)
	var sx := 1 if x1 < x2 else -1
	var sy := 1 if y1 < y2 else -1
	var err := dx - dy

	var x := x1
	var y := y1

	while true:
		if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
			image.set_pixel(x, y, color)

		if x == x2 and y == y2:
			break

		var e2 := 2 * err
		if e2 > -dy:
			err -= dy
			x += sx
		if e2 < dx:
			err += dx
			y += sy

## 生成阴影纹理图像
## 返回一个 Image 对象，包含半透明椭圆阴影
static func generate_shadow_texture(size: int = 64) -> Image:
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)

	var center := Vector2(size / 2.0, size / 2.0)
	var radius_x := size / 2.0 - 2.0
	var radius_y := size / 3.0 - 1.0  # 椭圆，y 方向压缩

	for y in range(size):
		for x in range(size):
			var dx := (x - center.x) / radius_x
			var dy := (y - center.y) / radius_y
			var dist_sq := dx * dx + dy * dy

			if dist_sq <= 1.0:
				# 根据距离计算透明度
				var alpha := 1.0 - dist_sq
				alpha = clamp(alpha * 0.5, 0.1, 0.5)  # 半透明灰色
				image.set_pixel(x, y, Color(0.3, 0.3, 0.3, alpha))
			else:
				image.set_pixel(x, y, Color.TRANSPARENT)

	return image

## 保存生成的图像到文件
static func save_sprite_sheet(image: Image, path: String) -> Error:
	return image.save_png(path)

static func save_shadow_texture(image: Image, path: String) -> Error:
	return image.save_png(path)