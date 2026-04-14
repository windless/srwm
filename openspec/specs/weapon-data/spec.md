## ADDED Requirements

### Requirement: 武器基础属性
系统 SHALL 定义武器的基础属性数据模板。

#### Scenario: 属性定义
- **WHEN** 定义武器属性时
- **THEN** 包含：名称、攻击力、最小射程、最大射程、EN消耗、命中率

#### Scenario: 射程定义
- **WHEN** 定义武器射程时
- **THEN** 最小射程和最大射程为整数，表示网格距离

#### Scenario: EN消耗
- **WHEN** 武器消耗 EN 时
- **THEN** EN 消耗值定义在武器数据中，可为 0（不消耗）

### Requirement: 武器类型
系统 SHALL 定义武器的类型分类。

#### Scenario: 类型枚举
- **WHEN** 定义武器类型时
- **THEN** 支持物理、射击、特殊三种类型

#### Scenario: 类型标识
- **WHEN** 武器数据定义时
- **THEN** 必须指定武器类型

### Requirement: 数据模板
系统 SHALL 使用 Resource 文件定义武器数据。

#### Scenario: 文件格式
- **WHEN** 创建武器数据文件时
- **THEN** 使用 Godot Resource 格式 (.tres) 存储

#### Scenario: 运行时加载
- **WHEN** 游戏运行时需要武器数据时
- **THEN** 系统可从 .tres 文件加载 WeaponData Resource

#### Scenario: 武器复用
- **WHEN** 多个机甲使用相同武器时
- **THEN** 可引用同一个 WeaponData Resource