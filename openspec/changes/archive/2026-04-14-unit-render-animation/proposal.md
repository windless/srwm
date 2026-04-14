## Why

机甲单位需要在战场场景中进行可视化的呈现和动态表现。当前项目已有单位数据模型（UnitData、WeaponData）和运行时状态（UnitInstance），但缺少单位的视觉呈现层。玩家需要能够看到战场上的机甲单位，并通过动画效果理解单位的当前状态（站立、移动、攻击、受击等）。

## What Changes

实现机甲单位的 2D 渲染和动画系统：

- **UnitRenderer 节点**: 负责机甲单位的 2D 精灵渲染和视觉表现（不处理坐标转换）
- **阴影渲染**: 使用 ShadowSprite 渲染机甲阴影，空中状态时阴影位置偏移
- **空中状态**: 支持 airborne 状态，机体 y 轴偏移显示，阴影位置相应调整
- **降落/起飞动画**: 支持 land（降落）和 takeoff（起飞）动画状态
- **动画系统**: 使用 AnimatedSprite2D 管理单位的帧动画（入场、起飞、待机、移动、攻击、受击、降落、击毁、离场）
- **四方向支持**: 南、东、北、西四个方向的独立精灵帧
- **Disabled 状态**: 支持灰色显示状态
- **编辑器预览**: 使用 @tool 脚本实现编辑器实时渲染
- **动画资源**: 定义 SpriteFrames 动画帧集合，从精灵表裁剪纹理
- **状态同步**: 动画状态与 UnitInstance 运行时状态的同步机制

## Capabilities

### New Capabilities

- `unit-renderer`: 机甲单位的 2D 渲染节点，处理精灵显示、阴影渲染、空中状态偏移、动画播放、disabled 状态、编辑器预览（坐标转换由外部系统处理）
- `unit-animation-state`: 单位动画状态管理，处理入场/离场、起飞/降落、动画状态切换、方向选择、同步机制

### Modified Capabilities

无。本变更为新增视觉呈现层，不修改现有数据层规格。

## Impact

- 新增 UnitRenderer 场景和脚本文件（使用 Node2D + ShadowSprite + AnimatedSprite2D）
- 新增 SpriteFrames 动画资源文件（含 9 种动画状态的四方向帧集合）
- 新增精灵表纹理处理逻辑（AtlasTexture 裁剪）
- UnitRenderer 需要支持 airborne 状态的 y 轴偏移和阴影位置调整
- UnitInstance 需要与 UnitRenderer 建立信号连接（含 airborne 状态变化）
- 需要引入机甲 2D 精灵图像资源（精灵表 PNG）和阴影纹理