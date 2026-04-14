## Context

本项目是一个 Godot 4.6 移动端战棋游戏，复刻《超级机器人大战》的核心玩法。当前已实现核心组件：

- **GridMapSystem**: 网格地图管理，支持地形数据和 TileMapLayer 渲染
- **UnitInstance**: 单位运行时状态管理（HP、EN、阵营关系）
- **UnitRenderer**: 单位渲染场景（包含 AnimatedSprite2D）
- **TerrainData/UnitData/PilotData**: 数据模型和 Resource 文件

当前缺乏一个整合这些组件的生产级战斗场景。测试场景 `grid_map_test_scene.tscn` 仅用于验证网格系统，不具备完整的战斗交互能力。

技术环境：
- **引擎**: Godot 4.6
- **平台**: 移动端（触控操作优先）
- **渲染**: Mobile 渲染器
- **网格**: 2.5D 等距投影（Isometric）

## Goals / Non-Goals

**Goals:**
- 创建生产级战斗场景 `battle_map.tscn`，整合现有地图和单位组件
- 实现移动端触控友好的相机控制（缩放、平移、网格选择）
- 实现基础 HUD 框架，显示单位信息和操作按钮
- 实现单位初始放置系统，支持预设玩家位置和动态敌方生成
- 为后续回合管理和战斗逻辑开发提供场景基础

**Non-Goals:**
- 本阶段不实现完整回合制流程（玩家回合/敌方回合切换）
- 不实现战斗计算和伤害处理
- 不实现单位移动和攻击的完整交互流程
- 不实现战斗演出动画
- 不实现关卡选择或战斗结算流程

## Decisions

### 决策 1: 战斗场景节点结构

**选择**: 采用分层节点结构

```
BattleMap (Node2D)
├── BattleCamera (Camera2D + 控制脚本)
├── GridMapSystem (地图管理)
├── TileMapLayer (地形渲染)
├── GridVisualization (网格线渲染)
├── UnitsLayer (Node2D) - 单位容器
│   └── UnitRenderer instances
├── UnitPlacement (单位放置管理)
└── BattleHUD (CanvasLayer)
    ├── UnitInfoPanel
    └── ActionButtons
```

**理由**:
- 分层结构便于独立测试和管理
- UnitsLayer 作为单位容器便于批量操作（如单位聚焦时更新渲染顺序）
- HUD 使用 CanvasLayer 确保不受相机变换影响

**备选方案**:
- 单层结构（所有节点平铺）→ 拒绝：难以管理单位渲染顺序
- 多场景组合（Camera/Map/HUD 作为独立场景）→ 拒绝：当前阶段简单场景足够，过度拆分增加复杂度

### 决策 2: 相机控制实现

**选择**: 使用 Godot 内置 InputEvent 处理 + 自定义边界限制

**理由**:
- 移动端触控事件（InputEventScreenTouch、InputEventScreenDrag）原生支持
- 自定义边界限制确保相机始终在地图范围内
- 支持双指缩放（pinch gesture）和单指平移

**备选方案**:
- 使用第三方相机插件 → 拒绝：增加依赖，当前需求简单
- 纯按钮控制（无触控）→ 拒绝：不符合移动端触控优先设计

### 决策 3: 单位放置数据流

**选择**: 使用 MapData Resource 预设单位位置 + 运行时动态生成敌方

**理由**:
- MapData 可在编辑器中预设玩家单位初始位置
- 敌方单位根据战斗配置动态生成，支持不同难度和关卡
- UnitInstance 作为运行时状态，引用 UnitData 和 PilotData 模板

**备选方案**:
- 纯代码配置（无 Resource）→ 拒绝：难以可视化编辑和调试
- 全部预设（无动态生成）→ 拒绝：缺乏灵活性，难以支持不同关卡

### 册策 4: HUD 响应式布局

**选择**: 使用 Godot Container 节点 + anchors 实现移动端适配

**理由**:
- HBoxContainer/VBoxContainer 自动排列子节点
- anchors 确保不同屏幕尺寸下 HUD 位置正确
- 触控友好的按钮尺寸（最小 48x48 像素）

**备选方案**:
- 固定像素布局 → 拒绝：不适配不同移动设备屏幕
- 自定义布局脚本 → 拒绝：Container 节点已满足需求

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 移动端触控精度影响网格选择 | 放大点击判定区域，支持长按辅助选择 |
| 大地图相机平移性能 | 限制地图尺寸（最大 30x30），启用视口裁剪 |
| HUD 占用屏幕空间影响战斗视野 | 使用可收起的 HUD 设计，战斗时自动隐藏部分面板 |
| 单位渲染顺序在等距视角下不正确 | 实现动态 Y-sorting，根据单位网格 Y 坐标排序 |
| 单位放置系统与后续回合系统接口不清晰 | 定义清晰的信号接口，便于后续回合管理接入 |

## Open Questions

1. **相机初始位置**: 相机是否应该自动聚焦到玩家单位集中区域，还是固定在地图中心？（倾向于地图中心，后续可优化）
2. **HUD 单位信息显示时机**: 是否只在选中单位时显示，还是始终显示最近单位的简要信息？（倾向于选中时显示完整信息）
3. **单位放置预设格式**: MapData 是否需要新增字段存储单位初始位置，还是创建独立的 UnitPlacementData？（倾向于扩展 MapData，保持数据一致性）