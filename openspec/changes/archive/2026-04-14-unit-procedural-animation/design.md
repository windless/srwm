## Context

当前 UnitRenderer 基于 AnimatedSprite2D 实现动画，仅支持单帧静态显示。机甲的战斗动作需要通过程序化动画（Tween）实现动态视觉效果，包括位移、缩放、透明度变化、震动等。现有代码已定义动画状态枚举（enter, takeoff, idle, move, attack, hit, land, destroy, exit），但缺乏实际的动画播放逻辑。

## Goals / Non-Goals

**Goals:**
- 实现七种核心程序化动画：Enter（入场）、Takeoff（起飞）、Land（降落）、Attack（攻击）、Hit（受击）、Destroy（击毁）、Exit（离场）
- 动画参数可配置（持续时间、偏移量等）
- 动画完成后发出信号通知
- 动画可被中断（如新动画触发时停止旧动画）
- 与现有动画状态系统无缝集成

**Non-Goals:**
- 不实现帧动画（使用现有 AnimatedSprite2D 逻辑）
- 不实现复杂粒子特效系统

## Decisions

### 1. 使用 Tween 而非 AnimationPlayer

**理由**: Tween 更适合程序化、参数化的动画效果，可在代码中动态调整参数，无需预先创建大量动画资源。

**备选方案**: AnimationPlayer 需要为每种动画类型创建 .tres 资源文件，灵活性较低。

### 2. 动画参数使用 @export 配置

**理由**: 用户可在编辑器中调整动画参数（持续时间、偏移量），方便调试和定制。

### 3. 使用 TweenParallel 实现多属性动画

**理由**: 入场动画需要同时位移和淡入，使用 `create_tween().set_parallel(true)` 可同时执行多个属性动画。

### 4. 震动效果使用 Tween 循环

**理由**: Hit 动画的震动效果通过 Tween 的 `set_loops()` 实现小幅位移循环。

## Risks / Trade-offs

**Tween 竞争风险** → 启动新动画前调用 `_stop_current_tween()` 停止当前动画

**动画参数极端值风险** → 使用 @export_range 约束参数范围

**编辑器预览性能** → 仅在非编辑器模式下执行完整动画逻辑