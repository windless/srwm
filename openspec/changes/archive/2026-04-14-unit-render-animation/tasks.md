## 1. 基础结构搭建

- [x] 1.1 创建 scenes/units/ 目录结构
- [x] 1.2 创建 assets/sprites/ 目录存放精灵表 PNG 文件
- [x] 1.3 创建 UnitRenderer.tscn 场景模板（Node2D + ShadowSprite + AnimatedSprite2D）

## 2. 精灵表纹理处理

- [x] 2.1 创建精灵表索引数据结构（机甲在表中的行列位置）
- [x] 2.2 实现从精灵表裁剪 AtlasTexture 的方法
- [x] 2.3 计算单机甲纹理位置：x = (索引 % 8) * 128, y = (索引 / 8) * 128
- [x] 2.4 实现四方向纹理偏移计算（南、东、北、西）
- [x] 2.5 创建 placeholder 精灵表（临时测试资源）- SpriteGenerator
- [x] 2.6 创建阴影精灵纹理（半透明灰色椭圆）- SpriteGenerator

## 3. UnitRenderer 核心脚本

- [x] 3.1 创建 UnitRenderer.gd 脚本（继承 Node2D，添加 @tool 注解）
- [x] 3.2 实现精灵表索引配置方法
- [x] 3.3 实现四方向朝向设置方法
- [x] 3.4 实现阴影渲染（ShadowSprite 配置）
- [x] 3.5 实现 disabled 状态灰度显示（modulate 设置）
- [x] 3.6 实现 airborne 状态渲染（机体 y 轴偏移、阴影位置调整）
- [x] 3.7 实现 airborne 偏移量配置（机体偏移、阴影偏移）
- [x] 3.8 实现编辑器实时预览（Engine.is_editor_hint() 区分逻辑）

## 4. SpriteFrames 动画配置

- [x] 4.1 创建 SpriteFrames 资源模板 - 动态创建
- [x] 4.2 配置 enter 动画（四方向帧集合）
- [x] 4.3 配置 takeoff 动画（四方向帧集合）
- [x] 4.4 配置 idle 动画（四方向帧集合）
- [x] 4.5 配置 move 动画（四方向帧集合）
- [x] 4.6 配置 attack 动画（四方向帧集合）
- [x] 4.7 配置 hit 动画（四方向帧集合）
- [x] 4.8 配置 land 动画（四方向帧集合）
- [x] 4.9 配置 destroy 动画（四方向帧集合）
- [x] 4.10 配置 exit 动画（四方向帧集合）
- [x] 4.11 设置各动画的帧速率（FPS）

## 5. 动画状态管理

- [x] 5.1 创建动画状态枚举（AnimationState）
- [x] 5.2 实现动画状态切换方法（play_animation）
- [x] 5.3 实现入场动画完成回调（切换至 idle）
- [x] 5.4 实现起飞动画完成回调（设置 airborne 状态，切换至 idle）
- [x] 5.5 实现降落动画完成回调（清除 airborne 状态）
- [x] 5.6 实现离场动画完成回调（发出离场信号）
- [x] 5.7 实现动画完成回调（自动返回 idle，destroy/exit 除外）
- [x] 5.8 实现循环动画设置（idle/move）
- [x] 5.9 实现方向动画选择（根据朝向选择对应帧集合）

## 6. 状态同步机制

- [x] 6.1 定义 UnitInstance 信号（deployed, airborne_changed, action_started, action_completed, hit_received, destroyed, disabled_changed, exiting）
- [x] 6.2 实现 UnitRenderer 信号连接方法 - connect_to_unit_instance
- [x] 6.3 实现 deployed 信号处理（播放 enter 动画）
- [x] 6.4 实现 airborne_changed 信号处理（起飞时播放 takeoff，降落时播放 land）
- [x] 6.5 实现 action_started 信号处理（切换动画状态）
- [x] 6.6 实现 action_completed 信号处理（返回 idle）
- [x] 6.7 实现 hit_received 信号处理（播放 hit 动画）
- [x] 6.8 实现 destroyed 信号处理（播放 destroy 动画）
- [x] 6.9 实现 disabled_changed 信号处理（设置灰度显示）
- [x] 6.10 实现 exiting 信号处理（播放 exit 动画）

## 7. 测试与验证

- [x] 7.1 创建 UnitRenderer 测试场景（包含信号触发按钮面板）
- [x] 7.2 实现测试信号发射器（模拟 UnitInstance 各状态信号）
- [x] 7.3 测试精灵表纹理裁剪 - 需在编辑器中运行测试场景
- [x] 7.4 测试阴影渲染效果 - 需在编辑器中运行测试场景
- [x] 7.5 测试朝向调整（四方向切换按钮） - 需在编辑器中运行测试场景
- [x] 7.6 测试 airborne 状态渲染（y 轴偏移、阴影位置） - 需在编辑器中运行测试场景
- [x] 7.7 测试起飞和降落动画（通过 airborne_changed 信号触发） - 需在编辑器中运行测试场景
- [x] 7.8 测试动画状态切换（通过信号触发 enter/takeoff/idle/move/attack/hit/land/destroy/exit） - 需在编辑器中运行测试场景
- [x] 7.9 测试 disabled 状态灰度显示（通过 disabled_changed 信号触发） - 需在编辑器中运行测试场景
- [x] 7.10 测试编辑器实时预览 - 需在编辑器中验证
- [x] 7.11 测试信号同步机制（验证各信号对应的动画播放正确） - 需在编辑器中运行测试场景