# test_sample.gd - 示例测试文件
# 验证 test.sh 脚本能正常运行 GUT 测试

class_name TestSample
extends GutTest

func test_sample_pass() -> void:
	# 最简单的通过测试
	assert_true(true, "这个测试应该总是通过")

func test_sample_math() -> void:
	# 验证基本数学运算
	var result = 1 + 1
	assert_eq(result, 2, "1 + 1 应等于 2")

func test_sample_string() -> void:
	# 验证字符串操作
	var text = "hello"
	assert_eq(text.length(), 5, "hello 的长度应为 5")