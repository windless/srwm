## IsometricTileSetup
## TileSet Isometric 配置指南和辅助脚本
## 用于创建 2.5D 斜视角地图

@tool
class_name IsometricTileSetup
extends RefCounted

## Isometric 斜视角配置参数
const ISOMETRIC_CONFIG := {
	"cell_size": Vector2i(64, 32),    # 斜视角菱形尺寸
	"tile_shape": TileSet.TILE_SHAPE_ISOMETRIC,
	"tile_layout": TileSet.TILE_LAYOUT_ISOMETRIC,
	"tile_offset_axis": TileSet.TILE_OFFSET_AXIS_VERTICAL,
}

## 创建 Isometric TileSet 资源
static func create_isometric_tileset() -> TileSet:
	var tileset := TileSet.new()

	# 设置斜视角属性
	tileset.tile_shape = ISOMETRIC_CONFIG.tile_shape
	tileset.tile_layout = ISOMETRIC_CONFIG.tile_layout
	tileset.tile_offset_axis = ISOMETRIC_CONFIG.tile_offset_axis
	tileset.tile_size = ISOMETRIC_CONFIG.cell_size

	# 创建 Atlas Source
	var source := TileSetAtlasSource.new()
	source.texture_region_size = ISOMETRIC_CONFIG.cell_size
	source.margins = Vector2i(0, 0)
	source.separation = Vector2i(0, 0)

	# 创建切片（需要在编辑器中设置纹理）
	# 0: Plains, 1: Mountain, 2: Water, 3: Structure
	for i in range(4):
		source.create_tile(Vector2i(i, 0))

	tileset.add_source(source, 0)

	return tileset


## 配置 TileMapLayer 为 Isometric 模式
static func configure_tilemap_layer(layer: TileMapLayer) -> void:
	if layer == null:
		return

	# TileMapLayer 继承 TileSet 的设置
	# 需要先设置 TileSet
	var tileset := create_isometric_tileset()
	layer.tile_set = tileset


## 生成简单斜视角切片图片（用于测试）
static func generate_isometric_tiles(output_dir: String) -> void:
	var cell_size: Vector2i = ISOMETRIC_CONFIG.cell_size

	# 平原 - 绿色
	_create_isometric_tile(cell_size, Color(0.4, 0.7, 0.3), output_dir + "plain.png")

	# 山地 - 棕色
	_create_isometric_tile(cell_size, Color(0.6, 0.4, 0.2), output_dir + "mountain.png")

	# 水域 - 蓝色
	_create_isometric_tile(cell_size, Color(0.2, 0.5, 0.8), output_dir + "water.png")

	# 建筑 - 灰色
	_create_isometric_tile(cell_size, Color(0.5, 0.5, 0.55), output_dir + "structure.png")


## 创建单个斜视角切片图片
static func _create_isometric_tile(
	size: Vector2i,
	fill_color: Color,
	output_path: String
) -> void:
	var image := Image.new()
	image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

	var half_width: int = size.x / 2
	var half_height: int = size.y / 2

	for py in range(size.y):
		for px in range(size.x):
			# Isometric 菱形判断
			var dx: float = absf(px - half_width) / float(half_width)
			var dy: float = absf(py - half_height) / float(half_height)

			if dx + dy <= 1.0:
				var color := fill_color
				# 边缘稍微深色
				if dx + dy > 0.8:
					color = fill_color.darkened(0.15)
				image.set_pixel(px, py, color)

	image.save_png(output_path)


## 创建 Atlas 纹理（合并所有切片）
static func create_atlas_texture(input_dir: String, output_path: String) -> void:
	var tile_size: Vector2i = ISOMETRIC_CONFIG.cell_size
	var atlas_width: int = tile_size.x * 4  # 4 种地形
	var atlas_height: int = tile_size.y

	var atlas := Image.new()
	atlas.create(atlas_width, atlas_height, false, Image.FORMAT_RGBA8)

	var tile_names: Array = ["plain", "mountain", "water", "structure"]

	for i in range(tile_names.size()):
		var tile_image := Image.new()
		var path: String = input_dir + tile_names[i] + ".png"
		if FileAccess.file_exists(path):
			tile_image.load(path)
			atlas.blit_rect(tile_image, Rect2i(0, 0, tile_size.x, tile_size.y), Vector2i(i * tile_size.x, 0))

	atlas.save_png(output_path)