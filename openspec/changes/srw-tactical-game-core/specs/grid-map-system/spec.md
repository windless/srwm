## ADDED Requirements

### Requirement: 网格坐标系统
系统 SHALL 提供统一的网格坐标系统，用于定位地图上的所有位置。

#### Scenario: 坐标表示
- **WHEN** 系统需要表示地图位置
- **THEN** 使用 GridCoord 结构，包含 x 和 y 整数坐标

#### Scenario: 坐标有效性检查
- **WHEN** 检查坐标是否在地图范围内
- **THEN** 系统返回该坐标是否有效（在地图边界内）

### Requirement: 地形类型定义
系统 SHALL 定义不同类型的地形，每种地形具有不同的属性。

#### Scenario: 地形属性存储
- **WHEN** 定义地形类型
- **THEN** 包含地形名称、移动消耗、防御修正、是否可通过

#### Scenario: 默认地形类型
- **WHEN** 系统初始化时
- **THEN** 提供基础地形类型：平原、山地、水域、建筑

### Requirement: 地图生成与加载
系统 SHALL 支持地图的生成和加载功能。

#### Scenario: 空地图创建
- **WHEN** 创建新地图时指定尺寸
- **THEN** 系统生成指定大小的空地图，填充默认地形

#### Scenario: 地图数据加载
- **WHEN** 加载预定义地图数据
- **THEN** 系统根据数据文件设置每个网格的地形类型

### Requirement: 地形信息查询
系统 SHALL 提供地形信息查询接口。

#### Scenario: 单网格查询
- **WHEN** 查询指定坐标的地形信息
- **THEN** 系统返回该位置的地形类型和属性

#### Scenario: 区域查询
- **WHEN** 查询矩形区域内所有网格的地形
- **THEN** 系统返回区域内每个网格的地形信息列表