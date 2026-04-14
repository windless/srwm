## 1. 目录结构创建

- [x] 1.1 创建 scenes/ 目录
- [x] 1.2 创建 scripts/ 目录
- [x] 1.3 创建 test/ 目录

## 2. 主场景创建

- [x] 2.1 创建 scenes/main.tscn 空白 Node 场景
- [x] 2.2 更新 project.godot 设置 run/main_scene

## 3. 开发者脚本创建

- [x] 3.1 创建 scripts/check.sh（三层检查：gdlint、导入、启动）
- [x] 3.2 创建 scripts/test.sh（GUT 测试运行）
- [x] 3.3 创建 scripts/run.sh（项目启动）
- [x] 3.4 设置脚本可执行权限
- [x] 3.5 配置 gdlintrc 排除 addons 目录

## 4. 验证

- [x] 4.1 运行 scripts/check.sh 验证空项目检查通过
- [x] 4.2 运行 scripts/run.sh 验证项目启动正常
- [x] 4.3 验证 scripts/test.sh 正确报告 GUT 未安装