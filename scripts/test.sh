#!/bin/bash
# 运行 GUT 单元测试
# 使用方法: scripts/test.sh

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

if [ ! -d "addons/gut" ]; then
    echo "❌ GUT 未安装"
    echo "请在 Godot 编辑器中打开 Asset Library，搜索 'Gut' 并安装"
    exit 1
fi

echo "=== 运行单元测试 ==="
godot --headless -s addons/gut/gut_cmdln.gd \
    -gdir=res://test \
    -ginclude_subdirs \
    -gexit