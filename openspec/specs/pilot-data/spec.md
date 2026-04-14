## ADDED Requirements

### Requirement: 驾驶员基础属性
系统 SHALL 定义驾驶员的基础属性数据模板。

#### Scenario: 属性定义
- **WHEN** 定义驾驶员属性时
- **THEN** 包含：名称、等级、HP成长率、EN成长率

#### Scenario: 等级范围
- **WHEN** 定义驾驶员等级时
- **THEN** 等级范围为 1-99，初始等级可配置

#### Scenario: 成长率定义
- **WHEN** 定义成长率时
- **THEN** 使用百分比格式，如 0.1 表示每级 10% 成长

### Requirement: 阵营归属
系统 SHALL 标识驾驶员的阵营归属。

#### Scenario: 阵营类型
- **WHEN** 定义阵营时
- **THEN** 支持玩家阵营、敌方阵营、中立阵营

#### Scenario: 阵营判断
- **WHEN** 比较两个驾驶员阵营时
- **THEN** 系统可判断是否为同阵营或敌对阵营

### Requirement: 数据模板
系统 SHALL 使用 Resource 文件定义驾驶员数据。

#### Scenario: 文件格式
- **WHEN** 创建驾驶员数据文件时
- **THEN** 使用 Godot Resource 格式 (.tres) 存储

#### Scenario: 运行时加载
- **WHEN** 游戏运行时需要驾驶员数据时
- **THEN** 系统可从 .tres 文件加载 PilotData Resource