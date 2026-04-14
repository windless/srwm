## Why

单位系统是战棋游戏的核心数据层，定义了机甲、驾驶员、武器的属性模型。作为独立系统，它不依赖战斗流程或地图系统，可以优先实现并验证数据结构设计。

从 `srw-tactical-game-core` 大型变更中拆分出来，降低实现复杂度，便于分阶段交付。

## What Changes

建立单位系统的数据模型和运行时状态管理：

- **UnitData Resource**: 机甲单位数据模板，包含基础属性和武器装备
- **PilotData Resource**: 驾驶员数据模板，包含等级和成长率
- **WeaponData Resource**: 武器数据模板，包含攻击属性和类型
- **UnitInstance**: 单位运行时状态管理
- **示例数据**: 最小验证数据集（2个单位）

## Capabilities

### New Capabilities

- `unit-data`: 机甲单位数据模板，定义 HP、EN、装甲、机动等属性
- `pilot-data`: 驾驶员数据模板，定义等级、成长率、阵营
- `weapon-data`: 武器数据模板，定义攻击力、射程、EN消耗、命中率、类型

### Modified Capabilities

无（全新系统）

## Impact

- 目录结构: 创建 `resources/` 目录存放 Resource 文件
- 数据模型: 三种 Resource 类型定义
- 运行时状态: UnitInstance 脚本管理单位实例

## Dependencies

- 需要先创建 `resources/` 目录（包含在任务中）
- 不依赖其他系统（GridMap、BattleController 等）

## Out of Scope

- 射程检查逻辑（需要地图坐标）
- 经验值获取和升级逻辑（需要战斗流程）
- 精神指令系统
- 单位状态效果系统