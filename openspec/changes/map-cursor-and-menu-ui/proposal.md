## Why

当前战斗场景缺乏可见的网格光标和完整的行动菜单系统。用户点击格子后，无法直观地看到当前选中的格子位置（仅通过 HUD 显示单位信息来间接提示）。同时，现有的操作按钮（Move、Attack、Wait）过于简单，无法支持完整的战棋游戏行动流程（如精神指令、武器选择、目标确认等）。这些交互缺陷直接影响移动端战棋游戏的核心体验。

## What Changes

- 新增 GridCursor 组件：在地图上渲染当前选中/聚焦格子的视觉指示器（高亮边框或覆盖层）
- 新增 ActionMenu 系统：替代现有简单按钮，支持完整行动流程（移动、攻击、精神指令、待机）
- 新增 MenuPanel 基础组件：可复用的移动端触控友好菜单面板
- 修改 BattleCamera 信号：新增 cursor 相关事件（光标移动、光标确认）
- **BREAKING**: 移除 BattleHUD 的硬编码按钮（Move/Attack/Wait），改为动态菜单系统

## Capabilities

### New Capabilities

- `grid-cursor`: 网格光标组件，在地图上渲染选中格子的视觉指示，支持光标移动动画和选中状态切换
- `action-menu`: 单位行动菜单系统，包含行动选项列表（移动、攻击、精神指令、待机），支持菜单选择和回调
- `menu-panel`: 可复用的移动端触控友好菜单面板基础组件，支持列表布局和选项高亮

### Modified Capabilities

- `battle-hud`: REQUIREMENTS 变化：从硬编码按钮改为动态菜单系统整合，新增菜单面板容器和信号连接
- `battle-camera`: REQUIREMENTS 变化：新增光标相关信号（cursor_moved, cursor_confirmed），支持光标驱动的交互模式

## Impact

- **新增文件**: `scripts/ui/grid_cursor.gd`, `scripts/ui/action_menu.gd`, `scripts/ui/menu_panel.gd`
- **新增场景**: `scenes/ui/grid_cursor.tscn`, `scenes/ui/action_menu.tscn`, `scenes/ui/menu_panel.tscn`
- **修改文件**: `scripts/battle/battle_hud.gd`, `scripts/battle/battle_camera.gd`, `scripts/battle/battle_map_controller.gd`
- **修改场景**: `scenes/battle/battle_map.tscn`（添加 GridCursor 节点，重构 HUD 结构）
- **依赖关系**: GridCursor 依赖 GridMapSystem 进行坐标转换；ActionMenu 依赖 BattleHUD 显示；BattleCamera 信号连接到 GridCursor