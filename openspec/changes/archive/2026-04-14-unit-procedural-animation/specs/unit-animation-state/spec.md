## MODIFIED Requirements

### Requirement: 动画状态定义
系统 SHALL 定义机甲单位的基础动画状态，并支持程序化动画触发。

#### Scenario: 状态类型
- **WHEN** 定义动画状态时
- **THEN** 包含：enter（入场）、takeoff（起飞）、idle（待机）、move（移动）、attack（攻击）、hit（受击）、land（降落）、destroy（击毁）、exit（离场）

#### Scenario: 默认状态
- **WHEN** 单位初始化时
- **THEN** 动画状态为 enter（入场），完成后切换至 idle

#### Scenario: 空中单位初始化
- **WHEN** 空中单位（airborne）初始化时
- **THEN** 动画状态为 enter（入场），完成后切换至 idle，同时设置 airborne 渲染状态

#### Scenario: 程序化动画触发
- **WHEN** enter、takeoff、attack、hit 状态触发时
- **THEN** 启动对应的程序化 Tween 动画

### Requirement: 动画播放
系统 SHALL 支持播放指定状态的动画，并管理 Tween 动画生命周期。

#### Scenario: 状态切换
- **WHEN** 请求切换动画状态时
- **THEN** 停止当前 Tween 动画，启动新状态对应的动画

#### Scenario: 动画完成
- **WHEN** 非循环动画播放完成时
- **THEN** 自动返回 idle 状态（除非是 destroy 状态）

#### Scenario: 循环动画
- **WHEN** idle 或 move 状态时
- **THEN** 动画循环播放

#### Scenario: Tween 动画清理
- **WHEN** 新动画开始时
- **THEN** 停止并清理当前活动的 Tween