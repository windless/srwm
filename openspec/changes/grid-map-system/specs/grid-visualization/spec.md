## ADDED Requirements

### Requirement: 斜视角显示配置
系统 SHALL 支持 2.5D 斜视角（Isometric）显示效果。

#### Scenario: TileMap Isometric 模式
- **WHEN** 配置 TileMap 节点
- **THEN** 使用 Isometric 模式，设置适当的单元格尺寸（如 64x32）

#### Scenario: 坐标转换
- **WHEN** 需要将网格坐标转换为屏幕坐标
- **THEN** 系统提供 GridCoord.to_screen() 方法，返回斜视角下的屏幕位置

#### Scenario: 屏幕坐标逆向转换
- **WHEN** 需要将屏幕坐标（如触控点）转换为网格坐标
- **THEN** 系统提供 GridCoord.from_screen() 方法，返回对应的网格坐标

### Requirement: 网格线可视化
系统 SHALL 支持网格线的实时显示和编辑器预览。

#### Scenario: 网格线绘制
- **WHEN** 启用网格线显示
- **THEN** 系统在地图上绘制每个网格的边界线

#### Scenario: 网格线颜色配置
- **WHEN** 配置网格线样式
- **THEN** 支持设置网格线颜色、宽度和透明度

#### Scenario: 编辑器实时预览
- **WHEN** 在编辑器中编辑地图
- **THEN** 网格线实时显示，辅助地图设计

#### Scenario: 运行时显示控制
- **WHEN** 游戏运行时
- **THEN** 支持动态切换网格线的显示/隐藏状态

### Requirement: TileMapLayer 集成
系统 SHALL 与 Godot TileMapLayer 节点集成，实现地图切片绘制。

#### Scenario: TileMapLayer 节点配置
- **WHEN** 设置地图场景
- **THEN** GridMapSystem 与 TileMapLayer 节点关联，TileMapLayer 负责视觉渲染

#### Scenario: 地形切片映射
- **WHEN** 定义地形数据
- **THEN** TerrainData 包含对应的切片 ID（tile_set atlas source + atlas coords）

#### Scenario: 切片自动更新
- **WHEN** GridMapSystem 设置某网格的地形类型
- **THEN** TileMapLayer 自动更新对应位置的切片显示

### Requirement: 网格高亮显示
系统 SHALL 支持网格区域的高亮显示功能。

#### Scenario: 单网格高亮
- **WHEN** 需要高亮指定网格
- **THEN** 系统支持设置高亮颜色和显示效果

#### Scenario: 区域高亮
- **WHEN** 需要高亮多个网格（如移动范围）
- **THEN** 系统支持批量设置高亮网格列表

#### Scenario: 高亮样式配置
- **WHEN** 配置高亮样式
- **THEN** 支持设置填充颜色、边框颜色、透明度