## ADDED Requirements

### Requirement: 单位渲染节点结构
系统 SHALL 提供 UnitRenderer 节点用于机甲单位的 2D 渲染。

#### Scenario: 节点组成
- **WHEN** 创建 UnitRenderer 时
- **THEN** 包含 Node2D 作为定位根节点，AnimatedSprite2D 作为动画显示节点

#### Scenario: 场景独立
- **WHEN** UnitRenderer 作为场景文件时
- **THEN** 可独立加载和实例化，不依赖战场场景

### Requirement: 阴影渲染
系统 SHALL 支持机甲单位的阴影渲染。

#### Scenario: 阴影精灵
- **WHEN** 配置阴影时
- **THEN** UnitRenderer 包含 ShadowSprite (Sprite2D) 节点

#### Scenario: 阴影位置
- **WHEN** 渲染阴影时
- **THEN** 阴影精灵位于机甲下方，有固定偏移

#### Scenario: 阴影透明度
- **WHEN** 显示阴影时
- **THEN** 阴影使用半透明效果（灰色 + 透明度）

### Requirement: Disabled 状态视觉
系统 SHALL 支持 disabled 状态的灰色显示。

#### Scenario: 灰色显示
- **WHEN** 单位处于 disabled 状态时
- **THEN** 机甲精灵显示为灰色（通过 modulate 或 shader）

#### Scenario: 状态恢复
- **WHEN** 单位从 disabled 恢复时
- **THEN** 机甲精灵恢复正常颜色

### Requirement: Airborne 状态渲染
系统 SHALL 支持空中状态（airborne）的视觉渲染。

#### Scenario: 机体 y 轴偏移
- **WHEN** 单位处于 airborne 状态时
- **THEN** AnimatedSprite2D 的 position.y 向上偏移（如 -20）

#### Scenario: 阴影位置调整
- **WHEN** 单位处于 airborne 状态时
- **THEN** 阴影 ShadowSprite 的 position.y 向下偏移（产生悬空效果）

#### Scenario: 偏移量配置
- **WHEN** 配置 airborne 偏移参数时
- **THEN** 可设置机体偏移量和阴影偏移量

#### Scenario: 地面状态恢复
- **WHEN** 单位从 airborne 状态切换至地面状态时
- **THEN** 机体和阴影位置恢复至正常偏移

### Requirement: 编辑器实时预览
系统 SHALL 支持编辑器中实时预览渲染效果。

#### Scenario: @tool 脚本
- **WHEN** UnitRenderer.gd 使用 @tool 注解时
- **THEN** 可在编辑器中实时显示渲染效果

#### Scenario: 参数调整
- **WHEN** 在编辑器中调整精灵索引或朝向时
- **THEN** 立即更新渲染显示

### Requirement: 精灵资源加载
系统 SHALL 支持加载机甲单位的 2D 精灵资源。

#### Scenario: SpriteFrames 资源
- **WHEN** 配置单位动画时
- **THEN** 使用 SpriteFrames 资源定义各状态的动画帧

#### Scenario: 精灵关联
- **WHEN** UnitRenderer 初始化时
- **THEN** 可根据 UnitData 关联对应的 SpriteFrames 资源

#### Scenario: 默认精灵
- **WHEN** 未指定精灵资源时
- **THEN** 使用 placeholder 精灵作为默认显示

### Requirement: 单位朝向
系统 SHALL 支持调整机甲单位的朝向。

#### Scenario: 四方向支持
- **WHEN** 定义单位朝向时
- **THEN** 支持四个方向：南（South）、东（East）、北（North）、西（West）

#### Scenario: 方向选择
- **WHEN** 单位改变朝向时
- **THEN** 切换至对应方向的精灵帧集合

#### Scenario: 面向目标
- **WHEN** 单位需要面向目标时
- **THEN** 根据目标相对位置选择最接近的方向（南/东/北/西）