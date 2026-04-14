# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Communication

有问题时，使用 AskUserQuestion 提问工具，一个问题一个问题地问，不要一次问多个问题。

## Restrictions

禁止使用 Python 脚本生成游戏素材（图片、纹理等）。素材生成应使用 Godot 内置的 Image 类或 GDScript 脚本。

## Project Overview

这是一个 Godot 4.6 移动端战棋游戏项目，复刻《超级机器人大战》(Super Robot Wars) 的核心玩法。项目目标是实现网格地图战术战斗系统，包含回合制战斗、机甲单位管理、战斗演出等核心功能。

技术配置：
- 引擎：Godot 4.6
- 平台：Mobile（移动端优化）
- 物理：Jolt Physics (3D)
- 渲染：Mobile 渲染器

## Development Commands

### 代码质量检查
```bash
./scripts/check.sh
```
执行三项检查：gdlint 代码检查、资源导入检查、项目启动检查。gdlint 会排除 `addons/` 目录。

### 运行测试
```bash
./scripts/test.sh
```
使用 GUT (Godot Unit Testing) 运行 `test/` 目录下的所有测试。GUT 需通过 Asset Library 安装。

### 启动项目
```bash
./scripts/run.sh
```
启动 Godot 编辑器。

## Architecture

### 核心系统设计

项目采用以下架构设计（详见 `openspec/changes/srw-tactical-game-core/design.md`）：

1. **场景架构**: 单一战场场景 + 子场景组合模式，避免频繁场景切换
2. **地图实现**: Godot GridMap 节点 + 自定义逻辑层处理地形属性
3. **单位数据**: Resource 文件定义单位/武器数据模板，运行时实例化
4. **战斗控制**: BattleController 单例管理战斗流程（回合/阶段管理）
5. **UI 系统**: Control 节点树 + 信号驱动更新

### 目录结构

- `scenes/` - 场景文件 (.tscn)
- `scripts/` - 开发者工具脚本 (check.sh, test.sh, run.sh)
- `test/` - GUT 单元测试
- `addons/gut/` - GUT 测试框架（第三方插件）
- `openspec/` - OpenSpec 变更管理和规格文档
- `resources/` - Resource 数据文件（待创建）
- `data/` - 数据定义文件（待创建）

### 计划中的核心节点

- `GridMapSystem` - 网格地图管理
- `UnitInstance` - 单位运行时状态
- `BattleController` - 战斗流程单例（Autoload）
- `BattleHUD` - 战场 UI 控制

## Testing

测试使用 GUT 框架，测试文件位于 `test/` 目录。测试类继承 `GutTest`：

```gdscript
class_name TestSample
extends GutTest

func test_example() -> void:
    assert_eq(1 + 1, 2, "basic math")
```

运行单个测试文件：
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test/test_file.gd
```

## OpenSpec Workflow

项目使用 OpenSpec 进行变更管理。规格文档位于 `openspec/specs/` 和 `openspec/changes/`。

完整 Git 工作流指南见 `openspec/openspec-git-workflow.md`。

可用命令：
- `/opsx:explore` - 探索模式，思考问题
- `/opsx:propose` - 提出新变更
- `/opsx:apply` - 实现变更任务
- `/opsx:archive` - 归档完成的变更