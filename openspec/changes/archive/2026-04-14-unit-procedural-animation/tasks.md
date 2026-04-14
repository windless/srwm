## 1. 动画参数配置

- [x] 1.1 在 UnitRenderer.gd 中添加动画参数 @export 变量（enter_duration, enter_offset 等）
- [x] 1.2 使用 @export_range 约束参数范围
- [x] 1.3 添加动画参数分组 @export_group("Animation Settings")

## 2. Tween 动画管理基础设施

- [x] 2.1 创建 _current_tween: Tween 变量存储当前活动 Tween
- [x] 2.2 实现 _stop_current_tween() 方法停止并清理当前动画
- [x] 2.3 实现 _create_parallel_tween() 方法创建并行 Tween
- [x] 2.4 在 play_animation() 中添加 Tween 停止逻辑

## 3. 入场动画实现

- [x] 3.1 实现 _play_enter_animation() 方法
- [x] 3.2 计算入场起始位置（基于 enter_offset 和当前方向）
- [x] 3.3 设置初始透明度为 0，位置为起始位置
- [x] 3.4 创建并行 Tween：位置动画 + 透明度动画
- [x] 3.5 动画完成回调发出 animation_completed 信号

## 4. 起飞动画实现

- [x] 4.1 实现 _play_takeoff_animation() 方法
- [x] 4.2 创建机体位置动画（向上移动 takeoff_height）
- [x] 4.3 创建阴影位置动画（向下分离）
- [x] 4.4 动画完成回调设置 is_airborne 状态

## 5. 攻击动画实现

- [x] 5.1 实现 _play_attack_animation() 方法
- [x] 5.2 计算冲锋方向（基于当前朝向）
- [x] 5.3 创建冲锋动画（向前移动 attack_charge_distance）
- [x] 5.4 创建返回动画（返回原位）
- [x] 5.5 使用 Tween 序列（set_parallel(false)）实现冲锋 → 返回

## 6. 受击动画实现

- [x] 6.1 实现 _play_hit_animation() 方法
- [x] 6.2 创建闪白动画（modulate 切换为 hit_flash_color）
- [x] 6.3 创建震动动画（小幅位移循环）
- [x] 6.4 使用 set_loops() 实现震动循环
- [x] 6.5 动画完成恢复原始 modulate 和位置

## 7. 动画状态集成

- [x] 7.1 在 play_animation() 中匹配动画状态调用对应程序化动画方法
- [x] 7.2 更新 _on_animation_finished() 处理程序化动画完成逻辑
- [x] 7.3 确保信号处理正确（enter → idle, takeoff → airborne idle 等）
- [x] 7.4 重构 play_animation() 使用 _try_play_procedural_animation() 减少 return 语句

## 8. 降落动画实现

- [x] 8.1 添加 land_duration 动画参数
- [x] 8.2 实现 _play_land_animation() 方法（机体下降）
- [x] 8.3 动画完成回调清除 is_airborne 状态
- [x] 8.4 更新 play_animation() 匹配 LAND 状态

## 9. 击毁动画实现

- [x] 9.1 添加 destroy_duration、destroy_flash_count、destroy_final_scale 参数
- [x] 9.2 实现 _play_destroy_animation() 方法（闪烁 + 缩放爆炸）
- [x] 9.3 动画完成后保持消失状态，不自动切换
- [x] 9.4 更新 play_animation() 匹配 DESTROY 状态

## 10. 离场动画实现

- [x] 10.1 添加 exit_duration、exit_offset 动画参数
- [x] 10.2 实现 _play_exit_animation() 方法（滑出 + 淡出）
- [x] 10.3 动画完成回调发出 exit_completed 信号
- [x] 10.4 更新 play_animation() 匹配 EXIT 状态

## 11. 测试与验证

- [x] 11.1 更新测试场景说明标签（所有动画现为程序化动画）
- [x] 11.2 测试入场动画（视觉验证淡入 + 滑入效果）- ✓ 已验证
- [x] 11.3 测试起飞动画（视觉验证上升 + 阴影分离）- ✓ 已验证
- [x] 11.4 测试降落动画（视觉验证下降效果）- ✓ 已验证
- [x] 11.5 测试攻击动画（视觉验证冲锋 + 返回）- ✓ 已验证
- [x] 11.6 测试受击动画（视觉验证闪白 + 震动）- ✓ 已验证
- [x] 11.7 测试击毁动画（视觉验证闪烁 + 缩放爆炸）- ✓ 已验证
- [x] 11.8 测试离场动画（视觉验证滑出 + 淡出）- ✓ 已验证
- [x] 11.9 测试动画中断（新动画触发时旧动画正确停止）- ✓ 已验证
- [x] 11.10 测试参数配置（修改参数后动画效果正确变化）- ✓ 已验证