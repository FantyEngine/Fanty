namespace FantyEngine;

extension Fanty
{
	/// Returns the angle between two points.
	public static float PointDirection(float x1, float y1, float x2, float y2)
	{
		return PointDirection(.(x1, y1), .(x2, y2));
	}

	/// Returns the angle between two points.
	public static float PointDirection(Vector2 a, Vector2 b)
	{
		var degrees = Mathf.Atan2(b.y - a.y, b.x - a.x) * 180.0f / Mathf.PI;

		// Ensures the angle is in the range [0, 360] degrees.
		if (degrees < 0)
			degrees += 360;
		return degrees;
	}

	public static float LengthDirX(float length, float direction)
	{
		var angleRad = Mathf.PI * direction / 180.0f;
		return length * Mathf.Cos(angleRad);
	}

	public static float LengthDirY(float length, float direction)
	{
		var angleRad = Mathf.PI * direction / 180.0f;
		return length * Mathf.Sin(angleRad);
	}
}