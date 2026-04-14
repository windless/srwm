## Why

当前项目已实现核心网格地图系统、单位数据模型和单位渲染器，但缺乏一个生产级战斗地图场景来整合这些组件进行实际战斗测试。需要一个完整的战斗场景作为游戏核心战斗循环的入口点，整合地图、单位、相机和 UI 系统，为后续回合管理和战斗逻辑开发提供基础。

## What Changes

- 创建生产级战斗地图场景 `scenes/battle/battle_map.tscn`
- 整合现有组件：GridMapSystem、TileMapLayer、GridVisualization、UnitRenderer
- 实现战斗相机控制器 BattleCamera，支持移动端触控操作（缩放、平移、点击选择）
- 实现基础单位放置系统，支持在地图上放置玩家和敌方单位
- 实现战场 HUD 框架，包含单位信息显示区和操作按钮区

## Capabilities

### New Capabilities

- `battle-camera`: 战斗场景相机控制系统，支持移动端触控操作（双指缩放、单指平移、点击选择网格），包含相机边界限制和单位聚焦功能
- `battle-hud`: 战场 HUD 界面系统，显示单位信息、回合状态、操作按钮，支持移动端触控友好的 UI 设计
- `unit-placement`: 单位放置系统，管理单位在地图上的初始部署位置，支持玩家单位预设位置和敌方单位动态生成

### Modified Capabilities

- 无现有 capability 需要修改（现有系统仅被集成，不需要修改规格）

## Impact

- **新增场景文件**: `scenes/battle/battle_map.tscn`（主战斗场景）
- **新增脚本文件**:
  - `scripts/battle/battle_camera.gd`（相机控制）
  - `scripts/battle/battle_hud.gd`（HUD 控制）
  - `scripts/battle/unit_placement.gd`（单位放置）
- **集成现有组件**: GridMapSystem、UnitRenderer、TerrainData、UnitData、PilotData
- **依赖**: 移动端触控输入处理，需要适配移动设备屏幕尺寸和触控精度