## Why

当前 UnitRenderer 仅支持单帧静态显示，缺乏动态视觉表现。机甲的入场、起飞、降落、攻击、受击、击毁、离场等关键战斗动作需要程序化动画效果来增强战斗演出体验，提升游戏的可玩性和视觉吸引力。

## What Changes

- 为 UnitRenderer 添加 Tween 驱动的程序化动画系统
- 实现 Enter 入场动画：从战场边缘滑入 + 淡入效果
- 实现 Takeoff 起飞动画：机体上升动画
- 实现 Land 降落动画：机体下降动画
- 实现 Attack 攻击动画：冲锋效果 + 返回
- 实现 Hit 受击动画：闪白 + 震动效果
- 实现 Destroy 击毁动画：闪烁 + 缩放爆炸 + 淡出
- 实现 Exit 离场动画：滑出 + 淡出效果
- 新增动画参数配置（持续时间、偏移量等）
- 动画完成信号通知机制

## Capabilities

### New Capabilities

- `unit-procedural-animation`: 机甲单位的程序化动画系统，包含入场、起飞、降落、攻击、受击、击毁、离场七种核心动画效果

### Modified Capabilities

- `unit-animation-state`: 扩展动画状态，支持程序化动画触发和参数配置
- `unit-renderer`: 集成程序化动画播放能力

## Impact

- **代码变更**: `scenes/units/unit_renderer.gd` - 添加 Tween 动画逻辑
- **规格变更**: `openspec/specs/unit-animation-state/spec.md` - 新增程序化动画要求
- **规格变更**: `openspec/specs/unit-renderer/spec.md` - 新增动画参数配置要求
- **依赖**: 无新增外部依赖，使用 Godot 内置 Tween 系统