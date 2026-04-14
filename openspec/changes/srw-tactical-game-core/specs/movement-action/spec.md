## ADDED Requirements

### Requirement: 移动范围计算
系统 SHALL 计算单位可移动的范围。

#### Scenario: 基础移动计算
- **WHEN** 单位选择移动时
- **THEN** 系统根据单位机动值计算最大移动距离

#### Scenario: 地形消耗计算
- **WHEN** 计算移动路径时
- **THEN** 系统考虑每格地形的移动消耗，总消耗不超过机动值

#### Scenario: 阻碍路径计算
- **WHEN** 移动路径上有其他单位阻挡
- **THEN** 被阻挡的网格不可作为目的地，但可作为途经点

### Requirement: 移动执行
系统 SHALL 执行单位移动操作。

#### Scenario: 移动确认
- **WHEN** 玩家选择目的地并确认
- **THEN** 单位移动到目标位置，消耗行动机会

#### Scenario: 移动动画
- **WHEN** 单位移动时
- **THEN** 系统播放单位从起点到终点的移动动画

#### Scenario: 移动取消
- **WHEN** 玩家取消移动操作时
- **THEN** 单位保持原位置，不消耗行动机会

### Requirement: 攻击行动
系统 SHALL 实现攻击行动逻辑。

#### Scenario: 攻击目标选择
- **WHEN** 单位选择攻击时
- **THEN** 系统列出攻击范围内的敌方单位

#### Scenario: 武器选择
- **WHEN** 攻击前选择武器时
- **THEN** 系统显示可用武器列表及对目标的预估效果

#### Scenario: 攻击执行
- **WHEN** 确认攻击时
- **THEN** 系统计算伤害、命中判定，更新目标 HP

### Requirement: 其他行动类型
系统 SHALL 支持其他类型的行动。

#### Scenario: 待机行动
- **WHEN** 单位选择待机时
- **THEN** 单位结束本回合行动，保持当前位置

#### Scenario: 防御行动
- **WHEN** 单位选择防御时
- **THEN** 单位本回合防御力提升，结束行动