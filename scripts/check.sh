#!/bin/bash
# 检查项目代码质量：lint、导入、启动
# 使用方法: scripts/check.sh

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== [1/3] GDScript Lint 检查 ==="
gdlint .

echo "=== [2/3] 资源导入检查 ==="
godot --headless --import --quit 2>&1 | tee /tmp/godot_import.log
if grep -qi "error" /tmp/godot_import.log; then
    echo "❌ 导入错误"
    exit 1
fi

echo "=== [3/3] 项目启动检查 ==="
godot --headless --quit 2>&1 | tee /tmp/godot_run.log
if grep -qi "error" /tmp/godot_run.log; then
    echo "❌ 运行时错误"
    exit 1
fi

echo "✓ 所有检查通过"