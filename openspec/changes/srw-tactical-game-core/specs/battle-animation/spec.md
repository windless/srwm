## ADDED Requirements

### Requirement: 战斗演出触发
系统 SHALL 在攻击发生时触发战斗演出。

#### Scenario: 演出开始
- **WHEN** 单位攻击目标时
- **THEN** 系统进入战斗演出模式，显示攻击者与目标的特写

#### Scenario: 演出结束
- **WHEN** 演出动画播放完毕
- **THEN** 系统返回战场视图，显示战斗结果

### Requirement: 攻击动画呈现
系统 SHALL 呈现攻击动画效果。

#### Scenario: 攻击者动作
- **WHEN** 演出显示攻击时
- **THEN** 攻击者单位执行攻击姿态动画

#### Scenario: 武器特效
- **WHEN** 攻击命中时
- **THEN** 显示对应武器的攻击特效（光束、导弹、斩击等）

### Requirement: 命中与伤害反馈
系统 SHALL 呈现命中判定和伤害数值。

#### Scenario: 命中显示
- **WHEN** 攻击判定结果时
- **THEN** 显示"命中"或"未命中"提示

#### Scenario: 伤害数值显示
- **WHEN** 攻击命中时
- **THEN** 显示造成的伤害数值动画

#### Scenario: 暴击提示
- **WHEN** 攻击触发暴击时
- **THEN** 显示特殊暴击效果和加成伤害数值

### Requirement: 被击动画
系统 SHALL 呈现被攻击单位的反应。

#### Scenario: 受击反应
- **WHEN** 单位被攻击命中时
- **THEN** 被击单位播放受击动画（震动、后退等）

#### Scenario: 击毁效果
- **WHEN** 单位 HP 降为 0 时
- **THEN** 播放单位爆炸/击毁动画，然后从战场移除