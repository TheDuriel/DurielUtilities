class_name DurielMath
extends RefCounted
## DurielMath Function Libary
##
## Uses Duriel Logic at times.


static func clamp_vector2i(vector: Vector2i, x_min: int, x_max: int, y_min: int, y_max: int) -> Vector2i:
	vector.x = clampi(vector.x, x_min, x_max)
	vector.y = clampi(vector.y, y_min, y_max)
	return vector
