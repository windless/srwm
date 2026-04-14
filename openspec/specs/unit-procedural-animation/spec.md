## Requirements

### Requirement: 入场动画
系统 SHALL 实现机甲单位的入场程序化动画。

#### Scenario: 入场触发
- **WHEN** 单位部署到战场时
- **THEN** 从战场边缘滑入至目标位置，同时淡入显示

#### Scenario: 入场参数
- **WHEN** 配置入场动画时
- **THEN** 可设置入场方向、持续时间、起始偏移量

#### Scenario: 入场完成
- **WHEN** 入场动画完成时
- **THEN** 发出 animation_completed 信号，动画状态切换至 idle

### Requirement: 起飞动画
系统 SHALL 实现机甲单位的起飞程序化动画。

#### Scenario: 起飞触发
- **WHEN** 地面单位切换至空中状态时
- **THEN** 机体向上移动，阴影位置分离

#### Scenario: 起飞参数
- **WHEN** 配置起飞动画时
- **THEN** 可设置上升高度、持续时间

#### Scenario: 起飞完成
- **WHEN** 起飞动画完成时
- **THEN** 设置 airborne 状态，动画切换至 idle

### Requirement: 攻击动画
系统 SHALL 实现机甲单位的攻击程序化动画。

#### Scenario: 攻击触发
- **WHEN** 单位发起攻击时
- **THEN** 向目标方向冲锋，然后返回原位

#### Scenario: 攻击参数
- **WHEN** 配置攻击动画时
- **THEN** 可设置冲锋距离、持续时间

#### Scenario: 攻击完成
- **WHEN** 攻击动画完成时
- **THEN** 发出 animation_completed 信号，动画状态切换至 idle

### Requirement: 受击动画
系统 SHALL 实现机甲单位的受击程序化动画。

#### Scenario: 受击触发
- **WHEN** 单位受到伤害时
- **THEN** 精灵闪白并震动

#### Scenario: 受击参数
- **WHEN** 配置受击动画时
- **THEN** 可设置震动幅度、持续时间、闪白颜色

#### Scenario: 受击完成
- **WHEN** 受击动画完成时
- **THEN** 精灵恢复正常颜色和位置，动画状态切换至 idle

### Requirement: 降落动画
系统 SHALL 实现机甲单位的降落程序化动画。

#### Scenario: 降落触发
- **WHEN** 空中单位切换至地面状态时
- **THEN** 机体向下移动至地面位置

#### Scenario: 降落参数
- **WHEN** 配置降落动画时
- **THEN** 可设置持续时间（land_duration）

#### Scenario: 降落完成
- **WHEN** 降落动画完成时
- **THEN** 清除 airborne 状态，阴影位置恢复，动画切换至 idle

### Requirement: 击毁动画
系统 SHALL 实现机甲单位的击毁程序化动画。

#### Scenario: 击毁触发
- **WHEN** 单位 HP 降至 0 时
- **THEN** 精灵闪烁红色，然后缩放爆炸并淡出消失

#### Scenario: 击毁参数
- **WHEN** 配置击毁动画时
- **THEN** 可设置持续时间、闪烁次数、最终缩放比例

#### Scenario: 击毁完成
- **WHEN** 击毁动画完成时
- **THEN** 单位保持消失状态，发出 destroy 完成信号，不自动切换状态

### Requirement: 离场动画
系统 SHALL 实现机甲单位的离场程序化动画。

#### Scenario: 离场触发
- **WHEN** 单位撤离战场时
- **THEN** 向当前朝向方向滑出，同时淡出消失

#### Scenario: 离场参数
- **WHEN** 配置离场动画时
- **THEN** 可设置持续时间、偏移量

#### Scenario: 离场完成
- **WHEN** 离场动画完成时
- **THEN** 发出 exit_completed 信号

### Requirement: 动画中断
系统 SHALL 支持动画中断机制。

#### Scenario: 动画抢占
- **WHEN** 新动画触发时存在正在播放的动画
- **THEN** 当前动画被停止，新动画立即开始

#### Scenario: 中断状态恢复
- **WHEN** 动画被中断时
- **THEN** 精灵位置、透明度、颜色恢复至动画前状态

### Requirement: 动画参数配置
系统 SHALL 支持通过编辑器配置动画参数。

#### Scenario: 参数范围
- **WHEN** 配置动画参数时
- **THEN** 参数值在有效范围内（通过 @export_range 约束）

#### Scenario: 实时预览
- **WHEN** 在编辑器中修改动画参数时
- **THEN** 预览效果即时更新