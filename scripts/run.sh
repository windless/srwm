#!/bin/bash
# 启动项目
# 使用方法:
#   scripts/run.sh          - 启动编辑器
#   scripts/run.sh <scene>  - 启动编辑器并打开指定场景

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

if [ -n "$1" ]; then
	# 指定场景文件
	SCENE_PATH="$1"
	# 如果不是绝对路径，添加 res:// 前缀
	if [[ ! "$SCENE_PATH" =~ ^res:// ]]; then
		SCENE_PATH="res://$SCENE_PATH"
	fi
	godot --path . "$SCENE_PATH"
else
	# 默认启动编辑器
	godot --path .
fi