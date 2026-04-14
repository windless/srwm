# TerrainLayer 2.5D Isometric 配置指南

## 概述

本指南说明如何配置 TileMapLayer (TerrainLayer) 与 GridVisualization 实现 2.5D 斜视角效果。

## 核心配置参数

| 参数 | 值 | 说明 |
|------|-----|------|
| TileSet.tile_shape | TILE_SHAPE_ISOMETRIC | 斜视角菱形形状 |
| TileSet.tile_layout | TILE_LAYOUT_ISOMETRIC | 斜视角布局 |
| TileSet.tile_size | Vector2i(64, 32) | 单元格尺寸（宽×高） |
| GridVisualization.cell_size | Vector2(64, 32) | 必须与 TileSet.tile_size 一致 |

## 坐标系统说明

### 网格坐标 (GridCoord)

使用整数坐标 `(x, y)` 表示地图上的位置：
- `x` 水平方向（右为正）
- `y` 垂直方向（下为正）

### 屏幕坐标转换公式

```
screen_x = (x - y) * (cell_size.x / 2)
screen_y = (x + y) * (cell_size.y / 2)
```

**示例**: `GridCoord(2, 1)` → `screen(32, 48)`（cell_size=64x32）

### 屏幕坐标逆向转换

```
grid_x = (screen_x / half_width + screen_y / half_height) / 2
grid_y = (screen_y / half_height - screen_x / half_width) / 2
```

## 编辑器配置步骤

### 步骤 1: 创建 TileSet

1. 右键点击 `resources/terrain/` → 新建资源 → 选择 TileSet
2. 设置属性：
   - **Tile Shape**: Isometric
   - **Tile Layout**: Isometric
   - **Tile Size**: X=64, Y=32
3. 添加 Atlas Source：
   - 设置纹理（切片图片）
   - 设置 `Texture Region Size`: 64x32
   - 创建切片：位置 (0,0), (1,0), (2,0), (3,0)

### 步骤 2: 创建切片图片

运行辅助脚本生成切片：

```gdscript
# 在编辑器中执行
IsometricTileSetup.generate_isometric_tiles("res://assets/tiles/")
IsometricTileSetup.create_atlas_texture("res://assets/tiles/", "res://assets/tiles/terrain_atlas.png")
```

或手动创建 64×32 的菱形切片图片。

### 步骤 3: 配置 TileMapLayer

1. 选择 `TerrainLayer` 节点
2. 设置 **Tile Set**: 选择创建的 TileSet 资源
3. TileMapLayer 会自动继承 TileSet 的 Isometric 配置

### 步骤 4: 验证 GridVisualization 对齐

GridVisualization 会自动绘制与 TileMapLayer 对齐的网格线：
- 网格线菱形中心与切片中心对齐
- 网格边界与切片边界吻合

**检查方法**:
- 打开 `grid_map_test_scene.tscn`
- GridVisualization 应显示网格线（@tool 模式）
- 网格线应与 TileMapLayer 的切片位置对齐

## 切片绘制示例

Isometric 切片为菱形，绘制方法：

```
      ┌─────┐
     /       \
    /         \
   └─────┬─────┘
         │
         │ 32px 高
         │
   64px 宽
```

切片图片尺寸为 64×32，菱形区域填充颜色，外部透明。

## TerrainData 与切片映射

TerrainData 的 `tile_atlas_coords` 属性指定切片在 Atlas 中的位置：

| 地形类型 | tile_atlas_coords | 说明 |
|----------|-------------------|------|
| Plains | Vector2i(0, 0) | Atlas 第 1 个切片 |
| Mountain | Vector2i(1, 0) | Atlas 第 2 个切片 |
| Water | Vector2i(2, 0) | Atlas 第 3 个切片 |
| Structure | Vector2i(3, 0) | Atlas 第 4 个切片 |

## GridMapSystem 同步机制

`GridMapSystem.set_terrain_at()` 会自动同步 TileMapLayer：

```gdscript
func set_terrain_at(coord: GridCoord, terrain_type: int) -> void:
    var terrain: TerrainData = _terrain_cache.get(terrain_type)
    _terrain_data[coord.y][coord.x] = terrain
    
    # 同步 TileMapLayer
    tile_layer.set_cell(
        Vector2i(coord.x, coord.y),
        0,  # source_id
        terrain.tile_atlas_coords
    )
```

## 常见问题

### Q: 网格线与切片不对齐

确保 `GridVisualization.cell_size` 与 `TileSet.tile_size` 完全一致。

### Q: 切片显示为矩形而非菱形

检查 TileSet 的 `tile_shape` 是否设置为 `TILE_SHAPE_ISOMETRIC`。

### Q: 坐标转换结果错误

使用 TileMapLayer 内置方法：
```gdscript
# 推荐：使用 TileMapLayer 的方法
var screen_pos: Vector2 = tile_layer.map_to_local(Vector2i(coord.x, coord.y))
var grid_coord: Vector2i = tile_layer.local_to_map(screen_pos)
```

GridCoord 的方法作为备用（无 TileMapLayer 时）。