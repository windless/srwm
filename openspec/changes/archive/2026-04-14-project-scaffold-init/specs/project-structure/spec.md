## ADDED Requirements

### Requirement: scenes 目录
项目 SHALL 包含 scenes 目录用于存放场景文件。

#### Scenario: 目录存在
- **WHEN** 项目初始化时
- **THEN** scenes/ 目录被创建

#### Scenario: 目录用途
- **WHEN** 开发者创建新场景时
- **THEN** 场景文件（.tscn）存放于 scenes/ 目录或其子目录

### Requirement: scripts 目录
项目 SHALL 包含 scripts 目录用于存放开发者工具脚本。

#### Scenario: 目录存在
- **WHEN** 项目初始化时
- **THEN** scripts/ 目录被创建

#### Scenario: 目录用途
- **WHEN** 存放开发者工具时
- **THEN** check.sh、test.sh、run.sh 等脚本存放于 scripts/ 目录

### Requirement: test 目录
项目 SHALL 包含 test 目录用于存放单元测试。

#### Scenario: 目录存在
- **WHEN** 项目初始化时
- **THEN** test/ 目录被创建

#### Scenario: 目录用途
- **WHEN** 编写单元测试时
- **THEN** 测试脚本存放于 test/ 目录或其子目录

### Requirement: 主场景配置
项目 SHALL 配置主场景路径。

#### Scenario: 主场景路径设置
- **WHEN** 项目初始化时
- **THEN** project.godot 中设置 run/main_scene="res://scenes/main.tscn"

#### Scenario: 主场景文件存在
- **WHEN** 项目初始化时
- **THEN** scenes/main.tscn 场景文件被创建

### Requirement: 主场景内容
主场景 SHALL 为空白 Node 场景。

#### Scenario: 场景结构
- **WHEN** 创建 main.tscn 时
- **THEN** 包含一个根节点 Node，名称为 "Main"

#### Scenario: 无附加内容
- **WHEN** 创建 main.tscn 时
- **THEN** 不包含任何子节点、脚本或资源引用