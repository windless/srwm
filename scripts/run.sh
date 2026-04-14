#!/bin/bash
# 启动项目
# 使用方法: scripts/run.sh

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

godot --path .