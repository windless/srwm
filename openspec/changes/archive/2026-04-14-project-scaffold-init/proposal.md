## Why

项目目前是空的，没有任何目录结构、脚本文件或主场景。在开始开发游戏功能之前，需要建立标准的项目骨架和开发者工具链（check、test、run 脚本），确保项目可以正常运行、检查和测试。

## What Changes

- **目录结构**: 创建 scenes/、scripts/、test/ 标准目录
- **主场景**: 创建空白 Node 场景作为项目入口点
- **开发者脚本**: 创建 check.sh、test.sh、run.sh 三个脚本
- **项目配置**: 更新 project.godot 设置主场景路径

## Capabilities

### New Capabilities

- `dev-scripts`: 开发者工具脚本（check、test、run），用于检查、测试和运行项目
- `project-structure`: 项目目录结构规范，定义各目录的用途

### Modified Capabilities

无（全新功能）

## Impact

- 目录创建: scenes/、scripts/、test/
- 场景文件: scenes/main.tscn（空白 Node 场景）
- 脚本文件: scripts/check.sh、scripts/test.sh、scripts/run.sh
- 配置修改: project.godot 添加 run/main_scene 设置
- 依赖引入: 需要安装 GUT 测试框架（test.sh 依赖）