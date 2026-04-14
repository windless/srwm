## ADDED Requirements

### Requirement: 地形类型枚举
系统 SHALL 定义地形类型枚举，标识不同种类的地形。

#### Scenario: 默认地形类型
- **WHEN** 系统初始化时
- **THEN** 提供基础地形类型枚举：PLAINS（平原）、MOUNTAIN（山地）、WATER（水域）、STRUCTURE（建筑）

#### Scenario: 地形类型扩展
- **WHEN** 需要添加新地形类型
- **THEN** 系统支持通过枚举扩展定义新类型

### Requirement: 地形属性定义
系统 SHALL 定义地形属性模板，每种地形具有不同的属性值。

#### Scenario: 地形属性字段
- **WHEN** 定义地形数据模板
- **THEN** 包含以下属性字段：
  - name: 地形名称（String）
  - terrain_type: 地形类型枚举（TerrainType）
  - move_cost: 移动消耗（int，默认1）
  - defense_bonus: 防御修正（int，默认0）
  - is_passable: 是否可通过（bool，默认true）
  - tile_atlas_coords: TileMap 切片坐标（Vector2i，用于视觉渲染）

#### Scenario: 默认地形数据
- **WHEN** 系统初始化时
- **THEN** 提供每种地形类型的默认数据文件：
  - Plains: move_cost=1, defense_bonus=0, passable=true
  - Mountain: move_cost=2, defense_bonus=10, passable=true
  - Water: move_cost=99, defense_bonus=0, passable=false
  - Structure: move_cost=1, defense_bonus=15, passable=true

### Requirement: 地形数据资源文件
系统 SHALL 使用 Resource 文件格式存储地形数据模板。

#### Scenario: Resource 文件格式
- **WHEN** 存储地形数据
- **THEN** 使用 Godot Resource 文件格式（.tres），支持编辑器可视化配置

#### Scenario: 地形数据加载
- **WHEN** 需要获取地形属性
- **THEN** 系统通过 Resource 文件路径加载地形数据实例