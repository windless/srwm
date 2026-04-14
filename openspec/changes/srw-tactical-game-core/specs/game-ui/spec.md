## ADDED Requirements

### Requirement: 战场信息显示
系统 SHALL 在战场界面显示关键信息。

#### Scenario: 回合信息
- **WHEN** 战斗进行时
- **THEN** 显示当前回合数和当前阵营

#### Scenario: 单位数量统计
- **WHEN** 显示战场概览时
- **THEN** 显示双方剩余单位数量

### Requirement: 单位状态面板
系统 SHALL 提供选中单位的详细状态面板。

#### Scenario: 属性显示
- **WHEN** 选中单位时
- **THEN** 显示单位名称、HP/EN条、主要属性值

#### Scenario: 武器列表
- **WHEN** 查看单位武器时
- **THEN** 显示武器列表及各武器状态

#### Scenario: 位置坐标显示
- **WHEN** 选中单位时
- **THEN** 显示单位当前位置坐标

### Requirement: 行动菜单
系统 SHALL 提供单位行动选择菜单。

#### Scenario: 菜单显示
- **WHEN** 选中未行动的单位时
- **THEN** 显示行动菜单：移动、攻击、防御、待机

#### Scenario: 子菜单展开
- **WHEN** 选择"攻击"选项时
- **THEN** 展开武器选择子菜单

#### Scenario: 菜单关闭
- **WHEN** 取消行动或完成行动时
- **THEN** 关闭行动菜单

### Requirement: 移动范围可视化
系统 SHALL 可视化显示单位的移动范围。

#### Scenario: 移动范围高亮
- **WHEN** 单位选择移动选项时
- **THEN** 可移动的网格高亮显示

#### Scenario: 路径预览
- **WHEN** 鼠标悬停或点击可移动网格时
- **THEN** 显示从当前位置到目标位置的路径预览

### Requirement: 攻击范围可视化
系统 SHALL 可视化显示单位的攻击范围。

#### Scenario: 攻击范围显示
- **WHEN** 选择攻击选项时
- **THEN** 显示当前武器射程内的网格范围

#### Scenario: 目标高亮
- **WHEN** 攻击范围内有敌方单位时
- **THEN** 敌方单位位置特殊高亮显示