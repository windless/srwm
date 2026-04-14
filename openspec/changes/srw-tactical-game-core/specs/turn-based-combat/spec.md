## ADDED Requirements

### Requirement: 回合制流程
系统 SHALL 实现回合制战斗流程。

#### Scenario: 回合顺序
- **WHEN** 战斗开始时
- **THEN** 系统按玩家回合→敌方回合顺序交替进行

#### Scenario: 回合切换
- **WHEN** 当前阵营所有单位完成行动
- **THEN** 系统切换到下一阵营的回合

#### Scenario: 回合结束触发
- **WHEN** 回合结束时
- **THEN** 触发回合结束事件，更新单位状态（EN恢复等）

### Requirement: 行动队列管理
系统 SHALL 管理单位行动队列。

#### Scenario: 行动单位列表
- **WHEN** 回合开始时
- **THEN** 系统列出当前阵营所有可行动单位

#### Scenario: 行动完成标记
- **WHEN** 单位完成一个行动后
- **THEN** 单位标记为"已行动"，本回合不可再次行动

#### Scenario: 行动恢复
- **WHEN** 新回合开始时
- **THEN** 所有单位的"已行动"标记清除

### Requirement: 战斗胜负判定
系统 SHALL 判定战斗胜负条件。

#### Scenario: 玩家失败条件
- **WHEN** 玩家阵营所有单位被消灭时
- **THEN** 战斗结束，判定玩家失败

#### Scenario: 玩家胜利条件
- **WHEN** 敌方阵营所有单位被消灭时
- **THEN** 战斗结束，判定玩家胜利

#### Scenario: 特殊胜利条件
- **WHEN** 满足预设特殊条件（如占领特定位置）
- **THEN** 战斗结束，判定相应结果

### Requirement: 战斗初始化
系统 SHALL 提供战斗初始化流程。

#### Scenario: 单位部署
- **WHEN** 战斗初始化时
- **THEN** 根据部署配置将单位放置到指定位置

#### Scenario: 初始状态设置
- **WHEN** 战斗初始化时
- **THEN** 单位恢复初始 HP、EN，清除临时状态效果