## GridMapEditorSetup
## 编辑器辅助脚本，用于配置 TileMap Isometric 模式和生成切片
## 在编辑器中运行此脚本以完成测试场景配置

@tool
class_name GridMapEditorSetup
extends RefCounted

## 生成测试切片图片并创建 TileSet
static func setup_test_tileset() -> void:
	print("=== GridMap Editor Setup ===")

	# 1. 生成切片图片
	generate_tile_images()
	print("Tile images generated.")

	# 2. 创建 TileSet 资源
	create_tileset_resource()
	print("TileSet resource created.")

	print("=== Setup Complete ===")
	print("Please open the scene and configure TileMap:")
	print("1. Open scenes/grid_map/grid_map_test_scene.tscn")
	print("2. Select TileMap node")
	print("3. Set tile_set to res://resources/terrain/terrain_tileset.tres")
	print("4. Set cell_size to Vector2(64, 32)")


## 生成四种地形切片图片
static func generate_tile_images() -> void:
	var output_dir: String = "res://assets/tiles/"
	var tile_size: Vector2i = Vector2i(64, 32)

	# 平原 - 绿色菱形
	create_isometric_tile(tile_size, Color(0.4, 0.7, 0.3), output_dir + "plain.png")

	# 山地 - 棕色菱形
	create_isometric_tile(tile_size, Color(0.6, 0.4, 0.2), output_dir + "mountain.png")

	# 水域 - 蓝色菱形
	create_isometric_tile(tile_size, Color(0.2, 0.5, 0.8), output_dir + "water.png")

	# 建筑 - 灰色菱形
	create_isometric_tile(tile_size, Color(0.5, 0.5, 0.55), output_dir + "structure.png")


## 创建单个斜视角切片图片
static func create_isometric_tile(size: Vector2i, fill_color: Color, output_path: String) -> void:
	var image := Image.new()
	image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

	var half_width: int = size.x / 2
	var half_height: int = size.y / 2

	for py in range(size.y):
		for px in range(size.x):
			var dx: float = absf(px - half_width) / float(half_width)
			var dy: float = absf(py - half_height) / float(half_height)

			if dx + dy <= 1.0:
				var color := fill_color
				# 边缘深色
				if dx + dy > 0.85:
					color = fill_color.darkened(0.2)
				image.set_pixel(px, py, color)

	var err := image.save_png(output_path)
	if err != OK:
		print("Failed to save: " + output_path)


## 创建 TileSet 资源文件
static func create_tileset_resource() -> void:
	# 创建 TileSet
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(64, 32)

	# 创建 TileSetAtlasSource
	var source := TileSetAtlasSource.new()
	source.texture = load("res://assets/tiles/terrain_atlas.png")
	source.margins = Vector2i(0, 0)
	source.separation = Vector2i(0, 0)
	source.texture_region_size = Vector2i(64, 32)

	# 添加四个切片（假设 atlas 中有 4x1 布局）
	for i in range(4):
		source.create_tile(Vector2i(i, 0))

	tileset.add_source(source)

	# 保存 TileSet
	ResourceSaver.save(tileset, "res://resources/terrain/terrain_tileset.tres")


## 创建合并的 atlas 图片（包含所有切片）
static func create_terrain_atlas() -> void:
	var atlas_width: int = 256  # 4 tiles * 64
	var atlas_height: int = 32

	var atlas := Image.new()
	atlas.create(atlas_width, atlas_height, false, Image.FORMAT_RGBA8)

	var tile_files: Array = [
		"res://assets/tiles/plain.png",
		"res://assets/tiles/mountain.png",
		"res://assets/tiles/water.png",
		"res://assets/tiles/structure.png"
	]

	for i in range(tile_files.size()):
		var tile_image := Image.new()
		tile_image.load(tile_files[i])
		atlas.blit_rect(tile_image, Rect2i(0, 0, 64, 32), Vector2i(i * 64, 0))

	var err := atlas.save_png("res://assets/tiles/terrain_atlas.png")
	if err == OK:
		print("Terrain atlas created successfully.")