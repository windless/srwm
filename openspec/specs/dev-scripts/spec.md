# dev-scripts - 开发者工具脚本规格

此能力定义项目的开发者工具脚本系统。

## Requirements

### Requirement: check 脚本功能
系统 SHALL 提供 check.sh 脚本用于检查项目代码质量。

#### Scenario: lint 检查执行
- **WHEN** 执行 check.sh 时
- **THEN** 调用 gdlint 检查所有 GDScript 文件的命名、结构和格式

#### Scenario: lint 排除目录
- **WHEN** 执行 lint 检查时
- **THEN** 排除 addons/ 目录（第三方插件不参与检查）

#### Scenario: 导入检查执行
- **WHEN** 执行 check.sh 时
- **THEN** 调用 godot --headless --import --quit 检查资源导入错误

#### Scenario: 启动检查执行
- **WHEN** 执行 check.sh 时
- **THEN** 调用 godot --headless --quit 检查项目能否正常启动

#### Scenario: 检查失败报告
- **WHEN** 任何检查步骤发现错误时
- **THEN** 脚本以非零退出码退出，显示错误信息

#### Scenario: 检查全部通过
- **WHEN** 所有检查步骤都通过时
- **THEN** 脚本以零退出码退出，显示成功信息

### Requirement: test 脚本功能
系统 SHALL 提供 test.sh 脚本用于运行单元测试。

#### Scenario: GUT 依赖检查
- **WHEN** 执行 test.sh 时
- **THEN** 检查 addons/gut 目录是否存在

#### Scenario: GUT 未安装提示
- **WHEN** GUT 未安装时
- **THEN** 脚本输出错误信息并提示通过 Asset Library 安装，以非零退出码退出

#### Scenario: 测试执行
- **WHEN** GUT 已安装时
- **THEN** 调用 godot --headless 运行 GUT CLI，执行 test 目录下的所有测试

#### Scenario: 测试结果报告
- **WHEN** 测试执行完成时
- **THEN** 显示测试结果摘要和退出码

### Requirement: run 脚本功能
系统 SHALL 提供 run.sh 脚本用于启动项目。

#### Scenario: 项目启动
- **WHEN** 执行 run.sh 时
- **THEN** 调用 godot --path . 启动项目编辑器/运行模式

### Requirement: 脚本可执行权限
脚本 SHALL 具有可执行权限。

#### Scenario: 权限设置
- **WHEN** 创建脚本文件时
- **THEN** 设置 755 权限（owner 可执行，其他用户可读可执行）

### Requirement: 脚本路径处理
脚本 SHALL 正确处理项目根路径。

#### Scenario: 相对路径解析
- **WHEN** 脚本位于 scripts/ 目录时
- **THEN** 自动定位到项目根目录执行命令