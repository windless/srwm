## Why

战棋游戏的核心是在网格地图上进行战术决策。当前项目缺少网格地图系统，无法实现单位移动、地形效果、地图定位等基础功能。这是构建战斗系统的前提条件，必须先实现地图系统才能继续开发回合制战斗流程。

本变更实现类似《超级机器人大战》的 2D 网格地图，采用经典斜视角（Isometric）2.5D 显示效果，支持编辑器中实时显示网格线和 TileMap 地图切片。

## What Changes

- 新增 GridCoord 结构体，用于统一表示网格坐标
- 新增 TerrainData Resource，定义地形属性模板
- 新增 TerrainType 枚举和默认地形数据文件
- 新增 GridMapSystem 节点，管理地图网格状态和查询
- 新增 TileMapLayer 集成，支持自定义地形切片绘制
- 新增网格线可视化组件，支持编辑器实时预览
- 新增斜视角相机配置，实现 2.5D 显示效果
- 新增地图数据加载功能，支持预定义地图配置

## Capabilities

### New Capabilities

- `grid-coord`: 网格坐标系统，提供统一的坐标表示和有效性检查
- `terrain-data`: 地形类型定义，包含地形属性模板和默认地形数据
- `grid-map-system`: 地图管理节点，处理地图生成、加载和地形查询
- `grid-visualization`: 网格可视化系统，实现斜视角显示、网格线绘制、编辑器预览

### Modified Capabilities

<!-- 无修改的现有能力 -->

## Impact

- **新文件**: `scripts/grid_coord.gd`, `scripts/terrain_data.gd`, `scripts/grid_map_system.gd`, `scripts/grid_visualization.gd`
- **新目录**: `resources/terrain/` 用于存放地形数据文件，`assets/tiles/` 用于存放地形切片
- **场景**: 需在 BattleScene 中添加 GridMapSystem + TileMap + GridVisualization 节点组合
- **依赖**: 将被回合制战斗系统、移动与行动系统、单位渲染系统使用