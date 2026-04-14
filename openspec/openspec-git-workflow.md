---
name: openspec-git-workflow
description: OpenSpec 变更管理与 Git Feature Branch 工作流配合指南
type: reference
---

# OpenSpec × Git 工作流指南

## 工作流概览

```
┌─────────────────────────────────────────────────────────────────┐
│                    变更生命周期                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  /opsx:propose        /opsx:apply          /opsx:archive        │
│       ↓                    ↓                     ↓              │
│  ┌──────────┐        ┌──────────┐         ┌──────────┐         │
│  │ Proposal │   →    │ Feature  │    →    │ Archive  │  → merge│
│  │  规划    │        │  Branch  │         │  归档    │         │
│  └──────────┘        └──────────┘         └──────────┘         │
│                                                                  │
│  openspec/           feature/xxx            openspec/changes/   │
│  changes/new/        分支开发               archive/            │
│  (活跃变更)           Worktree隔离          YYYY-MM-DD-xxx/     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 分支命名规范

| 变更类型 | 分支命名 | 示例 |
|---------|---------|------|
| 功能开发 | `feature/<变更名>` | `feature/grid-map-system` |
| Bug修复 | `fix/<问题描述>` | `fix/unit-animation-crash` |
| 重构 | `refactor/<重构内容>` | `refactor/battle-controller` |
| 文档 | `docs/<文档内容>` | `docs/api-reference` |

## 完整工作流程

### Phase 1: 提出变更 (`/opsx:propose`)

```bash
# 1. 从 master 创建 Proposal 分支（可选，仅用于文档追踪）
git checkout master
git checkout -b proposal/<变更名>

# 2. 运行 propose 命令，生成 proposal.md, design.md, tasks.md
/opsx:propose

# 3. 提交 OpenSpec 文档变更
git add openspec/changes/<变更名>/
git commit -m "docs: propose <变更名>"
```

### Phase 2: 实现变更 (`/opsx:apply`)

```bash
# 1. 创建隔离 Worktree（推荐）
git worktree add .worktrees/<变更名> -b feature/<变更名>

# 2. 进入 Worktree 开始实现
cd .worktrees/<变更名>
/opsx:apply openspec/changes/<变更名>/tasks.md

# 3. 运行项目测试验证
./scripts/check.sh
./scripts/test.sh

# 4. 提交代码变更（使用 conventional commit）
git add <实现的文件>
git commit -m "feat(<模块>): implement <功能描述>"
```

### Phase 3: 归档变更 (`/opsx:archive`)

```bash
# 1. 返回主工作目录
cd /Users/libright/Documents/mine/godot/srwm

# 2. 合并 Feature 分支到 master
git merge .worktrees/<变更名> --no-ff -m "Merge feature/<变更名> into master"

# 3. 运行归档命令（自动移动到 archive/）
/opsx:archive

# 4. 清理 Worktree
git worktree remove .worktrees/<变更名>
git branch -d feature/<变更名>

# 5. 推送到远程（如果有）
git push origin master
```

## Conventional Commit 规范

| 类型 | 说明 | 示例 |
|-----|------|------|
| `feat` | 新功能 | `feat(grid-map): implement terrain data loading` |
| `fix` | Bug修复 | `fix(unit-renderer): stop tween before new animation` |
| `refactor` | 重构 | `refactor(battle): extract turn management logic` |
| `docs` | 文档 | `docs: add openspec-git-workflow guide` |
| `test` | 测试 | `test(grid-map): add coordinate validation tests` |
| `chore` | 其他 | `chore: add worktree directory to gitignore` |

## Worktree 使用指南

### 创建 Worktree

```bash
# 检查目录是否被忽略
git check-ignore -q .worktrees  # 应返回 0（表示已忽略）

# 创建新 Worktree
git worktree add .worktrees/<变更名> -b feature/<变更名>

# 查看所有 Worktree
git worktree list
```

### Worktree 目录结构

```
.worktrees/
├── grid-map-system/       # GridMapSystem 变更
│   ├── scenes/
│   ├── scripts/
│   └── openspec/
├── unit-system/           # UnitSystem 变更
│   └── ...
└── battle-animation/      # BattleAnimation 变更
```

### 清理 Worktree

```bash
# 移除 Worktree（分支保留）
git worktree remove .worktrees/<变更名>

# 删除分支（合并后）
git branch -d feature/<变更名>
```

## 为什么使用 Worktree？

| 场景 | 无 Worktree | 有 Worktree |
|-----|------------|------------|
| 同时开发多个变更 | 需要频繁 stash/checkout | 每个变更独立目录 |
| 测试其他变更代码 | 会覆盖当前工作 | 可在另一目录测试 |
| 中途需要处理紧急任务 | stash 当前工作，切换分支 | 直接切换到主目录处理 |
| IDE 打开多个项目 | 不可能 | 每个 Worktree 独立 IDE 窗口 |

## OpenSpec 目录结构

```
openspec/
├── config.yaml                    # OpenSpec 配置
├── specs/                         # 活跃规格（最新版本）
│   ├── unit-data/spec.md
│   ├── grid-map-system/spec.md
│   └── ...
├── changes/                       # 变更管理
│   ├── srw-tactical-game-core/   # 活跃变更（进行中）
│   │   ├── .openspec.yaml
│   │   ├── proposal.md
│   │   ├── design.md
│   │   ├── tasks.md
│   │   └── specs/
│   └── archive/                   # 归档变更（已完成）
│       ├── 2026-04-14-unit-system/
│       ├── 2026-04-14-unit-procedural-animation/
│       └── ...
```

## 快速参考命令

```bash
# OpenSpec 命令
/opsx:explore      # 探索模式（思考问题）
/opsx:propose      # 提出新变更
/opsx:apply        # 实现变更任务
/opsx:archive      # 归档完成的变更

# Git 命令
git worktree list                          # 查看 Worktree
git worktree add .worktrees/xxx -b feature/xxx  # 创建
git worktree remove .worktrees/xxx         # 移除
git branch -d feature/xxx                  # 删除分支
git merge feature/xxx --no-ff              # 合并分支

# 项目验证命令
./scripts/check.sh                         # 代码质量检查
./scripts/test.sh                          # 运行测试
./scripts/run.sh                           # 启动编辑器
```