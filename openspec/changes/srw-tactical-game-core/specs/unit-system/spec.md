## ADDED Requirements

### Requirement: 单位基础属性
系统 SHALL 定义机甲单位的基础属性模型。

#### Scenario: 属性定义
- **WHEN** 定义单位属性时
- **THEN** 包含：名称、HP、EN、装甲、机动、攻击力、防御力

#### Scenario: 属性初始化
- **WHEN** 创建单位实例时
- **THEN** 从单位数据模板加载基础属性值

### Requirement: 武器系统
系统 SHALL 定义单位的武器装备系统。

#### Scenario: 武器属性
- **WHEN** 定义武器时
- **THEN** 包含：武器名称、攻击力、射程、EN消耗、命中率、类型（物理/射击/特殊）

#### Scenario: 多武器配置
- **WHEN** 单位装备武器时
- **THEN** 单位可携带多种武器，每回合可选择使用

#### Scenario: 武器射程检查
- **WHEN** 单位选择武器攻击时
- **THEN** 系统检查目标是否在武器射程内

### Requirement: 单位等级与成长
系统 SHALL 支持单位的等级和成长系统。

#### Scenario: 等级定义
- **WHEN** 单位具有等级属性时
- **THEN** 等级范围为 1-99，初始等级可配置

#### Scenario: 经验值获取
- **WHEN** 单位击败敌方单位时
- **THEN** 获得经验值，积累到一定值可升级

#### Scenario: 升级属性提升
- **WHEN** 单位升级时
- **THEN** 基础属性按预设成长率提升

### Requirement: 单位阵营标识
系统 SHALL 标识单位的阵营归属。

#### Scenario: 阵营类型
- **WHEN** 定义阵营时
- **THEN** 支持玩家阵营、敌方阵营、中立阵营

#### Scenario: 阵营判断
- **WHEN** 检查单位关系时
- **THEN** 系统根据阵营判断是否为友军、敌军或中立单位