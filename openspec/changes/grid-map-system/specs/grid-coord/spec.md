## ADDED Requirements

### Requirement: 网格坐标表示
系统 SHALL 提供统一的网格坐标结构，用于定位地图上的所有位置。

#### Scenario: 坐标结构定义
- **WHEN** 系统需要表示地图位置
- **THEN** 使用 GridCoord 结构，包含 x 和 y 整数坐标

#### Scenario: 坐标初始化
- **WHEN** 创建新的坐标实例
- **THEN** 系统支持通过 x, y 参数或 Vector2i 初始化

### Requirement: 坐标有效性检查
系统 SHALL 提供坐标有效性检查方法。

#### Scenario: 边界内检查
- **WHEN** 检查坐标是否在指定地图范围内
- **THEN** 系统返回布尔值表示该坐标是否有效

#### Scenario: 负坐标检查
- **WHEN** 检查负值坐标
- **THEN** 系统返回无效（false）

### Requirement: 坐标运算
系统 SHALL 提供坐标基本运算方法。

#### Scenario: 坐标加法
- **WHEN** 对两个坐标进行加法运算
- **THEN** 系统返回新坐标，值为两坐标之和

#### Scenario: 坐标距离计算
- **WHEN** 计算两个坐标之间的曼哈顿距离
- **THEN** 系统返回整数距离值（|x1-x2| + |y1-y2|）

#### Scenario: 相邻坐标判断
- **WHEN** 判断两个坐标是否相邻（曼哈顿距离为1）
- **THEN** 系统返回布尔值

### Requirement: 斜视角坐标转换
系统 SHALL 提供斜视角下的坐标转换方法。

#### Scenario: 网格坐标转屏幕坐标
- **WHEN** 需要获取网格在斜视角下的屏幕位置
- **THEN** 系统提供 to_screen(cell_size: Vector2) 方法，返回屏幕坐标

#### Scenario: 屏幕坐标转网格坐标
- **WHEN** 需要从屏幕位置获取对应网格
- **THEN** 系统提供 from_screen(screen_pos: Vector2, cell_size: Vector2) 方法，返回网格坐标

#### Scenario: 坐标转换精度
- **WHEN** 进行坐标转换
- **THEN** 转换结果在网格边界范围内精确对应