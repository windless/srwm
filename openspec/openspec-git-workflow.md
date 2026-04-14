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
│  changes/<变更名>/    分支开发               archive/            │
│  (活跃变更)           单分支开发             YYYY-MM-DD-xxx/    │
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
# 1. 确保 master 分支干净
git checkout master
git status  # 应无未提交变更

# 2. 运行 propose 命令，生成 proposal.md, design.md, tasks.md
/opsx:propose

# 3. 提交 OpenSpec 文档变更
git add openspec/changes/<变更名>/
git commit -m "docs(openspec): propose <变更名>"
```

### Phase 2: 实现变更 (`/opsx:apply`)

```bash
# 1. 创建 Feature 分支
git checkout -b feature/<变更名>

# 2. 运行 apply 命令，按 tasks.md 实现功能
/opsx:apply openspec/changes/<变更名>/tasks.md

# 3. 验证代码质量
./scripts/check.sh
./scripts/test.sh

# 4. 提交代码变更（使用 conventional commit）
git add <实现的文件>
git commit -m "feat(<模块>): implement <功能描述>"
```

### Phase 3: 合并并归档 (`/opsx:archive`)

```bash
# 1. 切回 master
git checkout master

# 2. 合并 Feature 分支
git merge feature/<变更名> --no-ff -m "Merge feature/<变更名> into master"

# 3. 运行归档命令（自动移动到 archive/）
/opsx:archive

# 4. 删除 Feature 分支
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
| `chore` | 其他 | `chore: add gitignore rules` |

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

## 示例：完整变更流程

```bash
# === Phase 1: 提出变更 ===
git checkout master
/opsx:propose  # 输入变更描述

# 生成的文件：
#   openspec/changes/battle-animation/proposal.md
#   openspec/changes/battle-animation/design.md
#   openspec/changes/battle-animation/tasks.md

git add openspec/changes/battle-animation/
git commit -m "docs(openspec): propose battle-animation"

# === Phase 2: 实现变更 ===
git checkout -b feature/battle-animation

# 按 tasks.md 逐项实现
# 任务 1: 创建 BattleAnimation 场景模板
# 任务 2: 实现演出触发和结束流程
# ...

/opsx:apply openspec/changes/battle-animation/tasks.md

# 验证
./scripts/check.sh
./scripts/test.sh

# 提交实现代码
git add scenes/battle/
git commit -m "feat(battle): implement animation scene template"
git add scripts/battle_controller.gd
git commit -m "feat(battle): add animation trigger logic"

# === Phase 3: 合并并归档 ===
git checkout master
git merge feature/battle-animation --no-ff

# 归档（移动变更到 archive/）
/opsx:archive

# 清理
git branch -d feature/battle-animation
```

## 处理紧急任务

当正在 Feature 分支开发时，需要处理紧急任务：

```bash
# 1. 保存当前工作（如果未完成）
git stash  # 或直接提交 WIP

# 2. 切回 master 处理紧急任务
git checkout master
git checkout -b fix/urgent-issue

# 3. 修复并合并
git commit -m "fix: ..."
git checkout master
git merge fix/urgent-issue --no-ff

# 4. 返回 Feature 分支继续开发
git checkout feature/<变更名>
git stash pop  # 如果之前 stash 了
```

## 快速参考命令

```bash
# OpenSpec 命令
/opsx:explore      # 探索模式（思考问题）
/opsx:propose      # 提出新变更
/opsx:apply        # 实现变更任务
/opsx:archive      # 归档完成的变更

# Git 命令
git checkout master                    # 切换到主分支
git checkout -b feature/xxx            # 创建 Feature 分支
git merge feature/xxx --no-ff          # 合并分支
git branch -d feature/xxx              # 删除已合并分支
git branch -a                          # 查看所有分支
git log --oneline -10                  # 查看最近提交

# 项目验证命令
./scripts/check.sh                     # 代码质量检查
./scripts/test.sh                      # 运行测试
./scripts/run.sh                       # 启动编辑器
```