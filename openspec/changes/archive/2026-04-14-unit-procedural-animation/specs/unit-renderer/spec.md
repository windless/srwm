## ADDED Requirements

### Requirement: 动画参数配置
系统 SHALL 支持通过编辑器配置程序化动画参数。

#### Scenario: 入场动画参数
- **WHEN** 配置入场动画时
- **THEN** 可设置 enter_duration（持续时间）、enter_offset（起始偏移）

#### Scenario: 起飞动画参数
- **WHEN** 配置起飞动画时
- **THEN** 可设置 takeoff_duration（持续时间）、takeoff_height（上升高度）

#### Scenario: 降落动画参数
- **WHEN** 配置降落动画时
- **THEN** 可设置 land_duration（持续时间）

#### Scenario: 攻击动画参数
- **WHEN** 配置攻击动画时
- **THEN** 可设置 attack_duration（持续时间）、attack_charge_distance（冲锋距离）

#### Scenario: 受击动画参数
- **WHEN** 配置受击动画时
- **THEN** 可设置 hit_duration（持续时间）、hit_shake_intensity（震动强度）、hit_flash_color（闪白颜色）

#### Scenario: 击毁动画参数
- **WHEN** 配置击毁动画时
- **THEN** 可设置 destroy_duration（持续时间）、destroy_flash_count（闪烁次数）、destroy_final_scale（最终缩放）

#### Scenario: 离场动画参数
- **WHEN** 配置离场动画时
- **THEN** 可设置 exit_duration（持续时间）、exit_offset（偏移量）

### Requirement: Tween 动画管理
系统 SHALL 管理 Tween 动画的生命周期。

#### Scenario: Tween 创建
- **WHEN** 启动程序化动画时
- **THEN** 使用 create_tween() 创建 Tween 实例

#### Scenario: Tween 停止
- **WHEN** 动画被中断或完成时
- **THEN** 调用 kill() 停止 Tween 并清理引用

#### Scenario: Tween 并行
- **WHEN** 需要同时动画多个属性时
- **THEN** 使用 set_parallel(true) 并行执行