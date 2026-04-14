## ADDED Requirements

### Requirement: 动画状态定义
系统 SHALL 定义机甲单位的基础动画状态。

#### Scenario: 状态类型
- **WHEN** 定义动画状态时
- **THEN** 包含：enter（入场）、takeoff（起飞）、idle（待机）、move（移动）、attack（攻击）、hit（受击）、land（降落）、destroy（击毁）、exit（离场）

#### Scenario: 默认状态
- **WHEN** 单位初始化时
- **THEN** 动画状态为 enter（入场），完成后切换至 idle

#### Scenario: 空中单位初始化
- **WHEN** 空中单位（airborne）初始化时
- **THEN** 动画状态为 enter（入场），完成后切换至 idle，同时设置 airborne 渲染状态

### Requirement: 入场动画
系统 SHALL 支持单位入场动画。

#### Scenario: 入场触发
- **WHEN** 单位部署到战场时
- **THEN** 播放 enter 动画

#### Scenario: 入场完成
- **WHEN** 入场动画完成时
- **THEN** 自动切换至 idle 状态

### Requirement: 离场动画
系统 SHALL 支持单位离场动画。

#### Scenario: 离场触发
- **WHEN** 单位撤离战场时
- **THEN** 播放 exit 动画

#### Scenario: 离场完成
- **WHEN** 离场动画完成时
- **THEN** 发出离场完成信号

### Requirement: 起飞动画
系统 SHALL 支持单位起飞动画。

#### Scenario: 起飞触发
- **WHEN** 地面单位切换至空中状态时
- **THEN** 播放 takeoff 动画

#### Scenario: 起飞完成
- **WHEN** 起飞动画完成时
- **THEN** 设置 airborne 状态，切换至 idle 动画，机体和阴影位置偏移

### Requirement: 降落动画
系统 SHALL 支持单位降落动画。

#### Scenario: 降落触发
- **WHEN** 空中单位切换至地面状态时
- **THEN** 播放 land 动画

#### Scenario: 降落完成
- **WHEN** 降落动画完成时
- **THEN** 清除 airborne 状态，机体和阴影位置恢复

### Requirement: 动画播放
系统 SHALL 支持播放指定状态的动画。

#### Scenario: 状态切换
- **WHEN** 请求切换动画状态时
- **THEN** AnimatedSprite2D.play() 播放对应状态的动画名称

#### Scenario: 动画完成
- **WHEN** 非循环动画播放完成时
- **THEN** 自动返回 idle 状态（除非是 destroy 状态）

#### Scenario: 循环动画
- **WHEN** idle 或 move 状态时
- **THEN** 动画循环播放

### Requirement: 状态同步
系统 SHALL 实现动画状态与单位运行时状态的同步。

#### Scenario: 移动触发
- **WHEN** UnitInstance 开始移动时
- **THEN** UnitRenderer 接收信号并切换至 move 状态

#### Scenario: 移动结束
- **WHEN** UnitInstance 完成移动时
- **THEN** UnitRenderer 接收信号并切换至 idle 状态

#### Scenario: 攻击触发
- **WHEN** UnitInstance 开始攻击时
- **THEN** UnitRenderer 接收信号并切换至 attack 状态

#### Scenario: 受击触发
- **WHEN** UnitInstance 受到伤害时
- **THEN** UnitRenderer 接收信号并播放 hit 状态

#### Scenario: 击毁触发
- **WHEN** UnitInstance HP 降至 0 时
- **THEN** UnitRenderer 接收信号并播放 destroy 状态

#### Scenario: 起飞触发
- **WHEN** UnitInstance 切换至 airborne 状态时
- **THEN** UnitRenderer 接收信号并播放 takeoff 动画，完成后设置 airborne 渲染

#### Scenario: 降落触发
- **WHEN** UnitInstance 从 airborne 切换至地面状态时
- **THEN** UnitRenderer 接收信号并播放 land 动画，完成后恢复地面渲染

### Requirement: 动画帧配置
系统 SHALL 支持 SpriteFrames 动画帧配置。

#### Scenario: 动画名称
- **WHEN** 配置 SpriteFrames 时
- **THEN** 定义与状态类型对应的动画名称（enter, takeoff, idle, move, attack, hit, land, destroy, exit）

#### Scenario: 方向动画
- **WHEN** 配置方向动画时
- **THEN** 每个状态包含四个方向的动画帧（south, east, north, west）

#### Scenario: 帧数量
- **WHEN** 配置动画帧时
- **THEN** 每个状态可配置不同数量的动画帧

#### Scenario: 帧速率
- **WHEN** 配置动画播放速度时
- **THEN** 可设置每个动画的帧速率（FPS）

### Requirement: 精灵表裁剪
系统 SHALL 支持从精灵表裁剪单机甲纹理。

#### Scenario: 纹理定位
- **WHEN** 配置机甲纹理时
- **THEN** 通过精灵表索引计算纹理在 PNG 中的位置

#### Scenario: 尺寸定义
- **WHEN** 裁剪机甲纹理时
- **THEN** 使用固定的 128 x 128 尺寸

#### Scenario: 方向偏移
- **WHEN** 获取特定方向的纹理时
- **THEN** 根据方向索引计算 Y 方向偏移

### Requirement: 测试场景信号机制
系统 SHALL 提供测试场景用于验证动画信号同步。

#### Scenario: 信号触发面板
- **WHEN** 创建测试场景时
- **THEN** 包含按钮面板用于发射各种状态信号

#### Scenario: 信号模拟
- **WHEN** 点击测试按钮时
- **THEN** 发出对应的模拟信号（deployed, airborne_changed, action_started 等）

#### Scenario: 动画验证
- **WHEN** 信号触发后
- **THEN** UnitRenderer 播放对应的动画，可通过视觉验证正确性