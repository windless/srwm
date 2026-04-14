## 1. 网格坐标系统

- [x] 1.1 创建 GridCoord 结构体脚本（基于 Vector2i）
- [x] 1.2 实现坐标初始化方法（x, y 参数和 Vector2i）
- [x] 1.3 实现坐标有效性检查方法（边界检查）
- [x] 1.4 实现坐标运算方法（加法、曼哈顿距离、相邻判断）
- [x] 1.5 实现斜视角坐标转换方法（to_screen、from_screen）

## 2. 地形数据定义

- [x] 2.1 创建 TerrainType 枚举脚本（PLAINS, MOUNTAIN, WATER, STRUCTURE）
- [x] 2.2 创建 TerrainData Resource 脚本（定义属性字段，包含 tile_atlas_coords）
- [x] 2.3 实现地形属性字段（name, terrain_type, move_cost, defense_bonus, is_passable, tile_atlas_coords）
- [ ] 2.4 创建 TileSet 资源（定义地形切片集合）
- [ ] 2.5 创建默认地形切片图片（Plain, Mountain, Water, Structure）
- [x] 2.6 创建默认地形数据 Resource 文件（配置切片坐标映射）

## 3. 地图管理节点

- [x] 3.1 创建 GridMapSystem 节点脚本
- [x] 3.2 实现地图数据结构（二维数组存储地形引用）
- [x] 3.3 实现节点初始化方法（数据结构初始化、地形数据缓存、TileMap 引用）
- [x] 3.4 实现地图尺寸配置（width, height 属性）
- [x] 3.5 实现空地图生成方法（指定尺寸，填充默认地形）
- [x] 3.6 实现地图边界设置（最小和最大坐标）
- [x] 3.7 实现 TileMapLayer 同步（设置地形时更新切片）

## 4. 网格可视化系统

- [x] 4.1 创建 GridVisualization 组件脚本（继承 CanvasItem）
- [x] 4.2 实现网格线绘制方法（使用 _draw 绘制边界线）
- [x] 4.3 实现网格线样式配置（颜色、宽度、透明度）
- [x] 4.4 实现编辑器实时预览（@tool 脚本模式）
- [x] 4.5 实现运行时显示控制（显示/隐藏切换）
- [x] 4.6 实现网格高亮功能（单网格和区域高亮）
- [x] 4.7 实现高亮样式配置（填充颜色、边框、透明度）

## 5. TileMapLayer 斜视角配置

- [ ] 5.1 配置 TileMapLayer Isometric 模式
- [ ] 5.2 设置 TileMapLayer 单元格尺寸（如 64x32 斜视角尺寸）
- [ ] 5.3 创建 TileSet Atlas 资源（配置斜视角切片布局）
- [ ] 5.4 实现地形切片与 TerrainData 映射

## 6. 地图数据加载

- [x] 6.1 创建 MapData Resource 格式（尺寸和地形类型数组）
- [x] 6.2 实现地图数据加载方法（从 Resource 文件）
- [x] 6.3 实现加载时 TileMap 自动填充
- [x] 6.4 创建示例地图数据文件（测试地图配置）

## 7. 地形查询接口

- [x] 7.1 实现单网格地形查询方法（返回 TerrainData）
- [x] 7.2 实现地形类型查询方法（返回 TerrainType）
- [x] 7.3 实现无效坐标查询处理（返回 null 或错误）
- [x] 7.4 实现坐标可通过检查方法（is_passable）
- [x] 7.5 实现屏幕坐标查询方法（从触控点获取网格坐标）

## 8. 测试场景创建

- [x] 8.1 创建 GridMapTestScene 场景文件（.tscn）
- [x] 8.2 配置场景节点结构（GridMapSystem + TileMapLayer + GridVisualization）
- [ ] 8.3 设置 TileMapLayer Isometric 模式和单元格尺寸
- [x] 8.4 配置 GridVisualization 为 @tool 模式（编辑器实时预览）
- [ ] 8.5 创建示例地形切片资源（用于测试渲染）
- [ ] 8.6 在编辑器中验证网格线显示效果

## 9. 单元测试

- [x] 9.1 创建 GridCoord 测试文件（坐标运算、有效性检查、斜视角转换）
- [x] 9.2 创建 TerrainData 测试文件（属性加载、切片映射）
- [x] 9.3 创建 GridMapSystem 测试文件（地图生成、地形查询、TileMap 同步）
- [x] 9.4 创建 GridVisualization 测试文件（网格线绘制、高亮功能）
