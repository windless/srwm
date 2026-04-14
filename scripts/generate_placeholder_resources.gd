@tool
extends EditorScript

## 编辑器脚本：生成 placeholder 精灵资源
## 在编辑器中运行此脚本可生成测试所需的精灵表和阴影纹理

func _run() -> void:
	print("=== 生成 Placeholder 精灵资源 ===")

	# 生成精灵表
	var sprite_sheet := SpriteGenerator.generate_placeholder_sprite_sheet(8)
	var sprite_path := "res://assets/sprites/placeholder_sprite_sheet.png"
	var err := SpriteGenerator.save_sprite_sheet(sprite_sheet, sprite_path)
	if err == OK:
		print("精灵表已保存至: %s" % sprite_path)
	else:
		print("保存精灵表失败: %d" % err)

	# 生成阴影纹理
	var shadow_tex := SpriteGenerator.generate_shadow_texture(64)
	var shadow_path := "res://assets/sprites/shadow.png"
	err = SpriteGenerator.save_shadow_texture(shadow_tex, shadow_path)
	if err == OK:
		print("阴影纹理已保存至: %s" % shadow_path)
	else:
		print("保存阴影纹理失败: %d" % err)

	# 重新导入资源
	EditorInterface.get_resource_filesystem().scan_sources()

	print("=== 资源生成完成 ===")