## 1. 目录结构准备

- [x] 1.1 创建 `resources/` 目录
- [x] 1.2 创建 `resources/units/` 子目录
- [x] 1.3 创建 `resources/pilots/` 子目录
- [x] 1.4 创建 `resources/weapons/` 子目录

## 2. WeaponData Resource

- [x] 2.1 创建 `scripts/weapons/weapon_data.gd` 定义 WeaponData 类
- [x] 2.2 定义 WeaponType 枚举 (PHYSICAL, SHOOTING, SPECIAL)
- [x] 2.3 定义武器属性 (name, power, range_min, range_max, en_cost, accuracy, type)
- [x] 2.4 创建示例武器 `beam_saber.tres` (物理类型)
- [x] 2.5 创建示例武器 `rifle.tres` (射击类型)

## 3. PilotData Resource

- [x] 3.1 创建 `scripts/pilots/pilot_data.gd` 定义 PilotData 类
- [x] 3.2 定义 Faction 枚举 (PLAYER, ENEMY, NEUTRAL)
- [x] 3.3 定义驾驶员属性 (name, level, hp_growth, en_growth, faction)
- [x] 3.4 创建示例驾驶员 `example_player_pilot.tres`
- [x] 3.5 创建示例驾驶员 `example_enemy_pilot.tres`

## 4. UnitData Resource

- [x] 4.1 创建 `scripts/units/unit_data.gd` 定义 UnitData 类
- [x] 4.2 定义机甲属性 (name, max_hp, max_en, armor, mobility)
- [x] 4.3 定义武器列表属性 (weapons: Array[WeaponData])
- [x] 4.4 创建示例单位 `example_player.tres`
- [x] 4.5 创建示例单位 `example_enemy.tres`

## 5. UnitInstance 运行时状态

- [x] 5.1 创建 `scripts/units/unit_instance.gd` 定义 UnitInstance 类
- [x] 5.2 定义运行时属性 (current_hp, current_en)
- [x] 5.3 定义数据引用 (unit_data: UnitData, pilot_data: PilotData)
- [x] 5.4 实现初始化方法 (从 UnitData 和 PilotData 加载状态)
- [x] 5.5 实现阵营判断方法 (is_enemy, is_friendly)

## 6. 单元测试

- [x] 6.1 创建 `test/test_unit_data.gd` 测试 UnitData 加载
- [x] 6.2 创建 `test/test_pilot_data.gd` 测试 PilotData 加载
- [x] 6.3 创建 `test/test_weapon_data.gd` 测试 WeaponData 加载
- [x] 6.4 创建 `test/test_unit_instance.gd` 测试 UnitInstance 初始化
- [x] 6.5 验证示例数据加载正确