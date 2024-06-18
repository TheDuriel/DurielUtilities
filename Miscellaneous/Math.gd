class_name DurielMath
extends RefCounted
## DurielMath Function Libary
##
## Uses Duriel Logic at times.


static func clamp_vector2i(vector: Vector2i, x_min: int, x_max: int, y_min: int, y_max: int) -> Vector2i:
	vector.x = clampi(vector.x, x_min, x_max)
	vector.y = clampi(vector.y, y_min, y_max)
	return vector


static func is_pair(a: int, b: int) -> bool:
	return a == b


static func is_odd(n: int) -> bool:
	return n % 2 == 1


static func is_even(n: int) -> bool:
	return n % 2 == 0


static func is_between_inclusive(value: float, minimum: float, maximum: float) -> bool:
	return value >= minimum and value <= maximum


static func add_with_cap(a: float, b: float, ceiling: float) -> Array[float]:
	var result_raw: float = a + b
	var result_capped: float = clamp(a + b, 0.0, ceiling)
	var overflow: float = result_raw - ceiling
	var remainder: float = max(overflow, 0.0)
	return [result_capped, remainder]


static func sub_with_cap(a: float, b: float) -> Array[float]:
	var result: float = a - b
	var remainder: float = 0
	if result < 0.0:
		remainder = abs(result)
		result = 0.0
	
	return [result, remainder]


@warning_ignore("untyped_declaration")
static func get_random_from_array(array: Array):# -> any:
	if array.is_empty():
		return null
	
	if array.size() == 1:
		return array[0]
	
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var r: int = rng.randi_range(0, array.size() - 1)
	
	return array[r]


static func normalize_weights(weights: Array) -> Array[float]:
	var total_weight: float = 0.0
	var normalized_weights: Array[float] = []
	
	for i: int in weights.size():
		total_weight += weights[i]
	
	for i: int in weights.size():
		var normalized_weight: float = weights[i] / total_weight
		normalized_weights.append(normalized_weight)
	
	return normalized_weights
