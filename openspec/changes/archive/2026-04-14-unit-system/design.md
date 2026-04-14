## Context

本项目是一个 Godot 4.6 移动端战棋游戏，复刻《超级机器人大战》的核心玩法。单位系统是核心数据层，需要支持：

- 机甲与驾驶员分离的数据模型
- 武器装备系统
- 等级和成长机制

技术环境：
- **引擎**: Godot 4.6
- **数据格式**: Resource 文件 (.tres)
- **脚本语言**: GDScript

## Goals / Non-Goals

**Goals:**
- 定义清晰的数据模型结构
- 支持运行时单位状态管理
- 创建最小示例数据验证设计
- 单位与驾驶员分离
- 武器类型分类

**Non-Goals:**
- 射程检查逻辑实现
- 经验值获取和升级逻辑
- 精神指令系统
- 状态效果系统
- UI 显示

## Decisions

### 决策 1: 机甲与驾驶员分离

**选择**: UnitData 和 PilotData 分离为两个 Resource 类型

**理由**:
- 原作中驾驶员和机甲是独立概念，同一驾驶员可以换乘不同机甲
- 分离设计便于未来扩展换乘系统
- 驾驶员成长率独立于机甲属性

**备选方案**:
- 合并到单一 UnitData → 拒绝：不符合原作设定，难以扩展换乘功能

### 决策 2: 武器装备引用

**选择**: UnitData 内部包含 WeaponData 引用数组

**理由**:
- 符合"单位装备武器"的语义
- 武器可复用（相同武器类型可被多个单位使用）
- 便于武器独立编辑和版本控制

**备选方案**:
- 武器属性内嵌到 UnitData → 拒绝：武器数据难以复用，维护成本高

### 决策 3: 成长率设计

**选择**: 使用百分比成长率

**理由**:
- 原作采用百分比成长
- 计算简单：每级属性 = 基础属性 * (1 + 等级 * 成长率)
- 便于设计平衡

**备选方案**:
- 固定值成长 → 拒绝：高等级时属性差异过大，难以平衡

### 决策 4: 武器类型分类

**选择**: 三种基本类型：物理、射击、特殊

**理由**:
- 简化初期实现
- 原作武器分类核心是格斗 vs 尪射击
- 特殊类型预留扩展空间

**备选方案**:
- 细分格斗/射击/地图/辅助 → 拒绝：初期过于复杂

### 决策 5: 运行时状态管理

**选择**: UnitInstance 脚本引用 UnitData + PilotData

**理由**:
- 数据与状态分离，符合 Godot 最佳实践
- UnitData 作为模板不变，UnitInstance 管理变化状态（HP、EN）
- 便于单位状态恢复（如战斗结束后）

**备选方案**:
- 直接修改 UnitData → 拒绝：破坏数据模板，无法复用

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| Resource 引用循环 | 避免双向引用，使用单向引用（Unit → Weapon） |
| 成长率计算精度 | 使用整数运算，避免浮点误差 |
| 数据文件膨胀 | 分目录管理，建立命名规范 |

## Data Structure Design

```
┌─────────────────────────────────────────────┐
│              Resource 文件结构               │
├─────────────────────────────────────────────┤
│                                             │
│  resources/                                 │
│    units/                                   │
│      example_player.tres                    │
│      example_enemy.tres                     │
│    pilots/                                  │
│      example_player_pilot.tres              │
│      example_enemy_pilot.tres               │
│    weapons/                                 │
│      beam_saber.tres                        │
│      rifle.tres                             │
│                                             │
└─────────────────────────────────────────────┘
```

## Attribute Design

### UnitData 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| name | String | 机甲名称 |
| max_hp | int | 最大 HP |
| max_en | int | 最大 EN |
| armor | int | 装甲值 |
| mobility | int | 机动值 |
| weapons | Array[WeaponData] | 武器列表 |

### PilotData 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| name | String | 驾驶员名称 |
| level | int | 当前等级 (1-99) |
| hp_growth | float | HP 成长率 |
| en_growth | float | EN 成长率 |
| faction | Faction | 阵营归属 |

### WeaponData 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| name | String | 武器名称 |
| power | int | 攻击力 |
| range_min | int | 最小射程 |
| range_max | int | 最大射程 |
| en_cost | int | EN 消耗 |
| accuracy | int | 基础命中率 |
| type | WeaponType | 武器类型 |

### Faction 枚举

```gdscript
enum Faction { PLAYER, ENEMY, NEUTRAL }
```

### WeaponType 枚举

```gdscript
enum WeaponType { PHYSICAL, SHOOTING, SPECIAL }
```