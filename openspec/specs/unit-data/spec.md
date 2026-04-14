## ADDED Requirements

### Requirement: 机甲基础属性
系统 SHALL 定义机甲单位的基础属性数据模板。

#### Scenario: 属性定义
- **WHEN** 定义机甲属性时
- **THEN** 包含：名称、最大HP、最大EN、装甲值、机动值

#### Scenario: 武器装备
- **WHEN** 机甲装备武器时
- **THEN** 机甲数据包含武器列表，武器以引用方式关联

#### Scenario: 数据模板
- **WHEN** 创建机甲数据文件时
- **THEN** 使用 Godot Resource 格式存储，便于编辑和版本控制

### Requirement: 数据加载
系统 SHALL 支持从 Resource 文件加载机甲数据。

#### Scenario: 运行时加载
- **WHEN** 游戏运行时需要机甲数据时
- **THEN** 系统可从 .tres 文件加载 UnitData Resource

#### Scenario: 属性访问
- **WHEN** 加载机甲数据成功时
- **THEN** 可访问所有定义的属性值

### Requirement: 武器引用
系统 SHALL 支持机甲引用武器数据。

#### Scenario: 武器列表
- **WHEN** 机甲数据定义武器列表时
- **THEN** 列表元素为 WeaponData Resource 引用

#### Scenario: 武器访问
- **WHEN** 访问机甲的武器时
- **THEN** 可遍历武器列表并获取每个武器的属性