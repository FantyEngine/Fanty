using System;
using Bon;

namespace FantyEngine;

[BonTarget]
public struct Vector2
{
	public float x = 0;
	public float y = 0;

	public const float kEpsilon = 0.00001f;
	public const float kEpsilonNormalSqrt = 1e-15f;

	public this()
	{
	}

	public this(float x, float y)
	{
		this.x = x; this.y = y;
	}

	public this(float xy)
	{
		this.x = xy; this.y = xy;
	}

	public float magnitude { [Inline] get { return (float)Math.Sqrt(x * x + y * y); } }
	public float sqrMagnitude { [Inline] get { return x * x + y * y; } }
	
	public static Vector2 zero 	{ [Inline] get { return Vector2(0, 0); } }
	public static Vector2 one 	{ [Inline] get { return Vector2(1, 1); } }
	public static Vector2 up 	{ [Inline] get { return Vector2(0f, 1f); } }
	public static Vector2 down 	{ [Inline] get { return Vector2(0f, -1f); } }
	public static Vector2 left 	{ [Inline] get { return Vector2(-1f, 0f); } }
	public static Vector2 right { [Inline] get { return Vector2(1f, 0f); } }

	public static Vector2 positiveInfinity { [Inline] get { return .(float.PositiveInfinity, float.PositiveInfinity); } }
	public static Vector2 negativeInfinity { [Inline] get { return .(float.NegativeInfinity, float.NegativeInfinity); } }

	[Inline]
	public void Normalize() mut
	{
		float mag = magnitude;
		if (mag > kEpsilon)
			this = this / mag;
		else
			this = zero;
	}

	public Vector2 normalized
	{
		get
		{
			var v = Vector2(x, y);
			v.Normalize();
			return v;
		}
	}

	[Inline]
	/// Linearly interpolates between two vectors.
	public static Vector2 Lerp(Vector2 a, Vector2 b, float t)
	{
		var t;
		var a;
		var b;
		t = Mathf.Abs(t);

		if (b.x.IsNaN || b.y.IsNaN) b = a;

		return Vector2(
			a.x + (b.x - a.x) * t,
			a.y + (b.y - a.y) * t
		);
	}

	[Inline]
	/// Dot Product of two vectors.
	public static float Dot(Vector2 lhs, Vector2 rhs) { return lhs.x * rhs.x + lhs.y * rhs.y; }

	[Inline]
	/// Returns the angle in degrees between (from) and (to).
	public static float Angle(Vector2 from, Vector2 to)
	{
		// sqrt(a) * sqrt(b) = sqrt(a * b) -- valid for real numbers
		float denominator = (float)Mathf.Sqrt(from.sqrMagnitude * to.sqrMagnitude);
		if (denominator < kEpsilonNormalSqrt)
			return 0F;

		float dot = Mathf.Clamp(Dot(from, to) / denominator, -1F, 1F);
		return (float)Mathf.Acos(dot) * Mathf.Rad2Deg;
	}

	[Inline]
	/// Returns the signed angle in degress between (from) and (to).
	/// Always returns the smallest possible angle.
	public static float SignedAngle(Vector2 from, Vector2 to)
	{
		float unsigned_angle = Angle(from, to);
		float sign = Mathf.Sign(from.x * to.y - from.y * to.x);
		return unsigned_angle * sign;
	}

	[Inline]
	/// Returns the distance between (from) and (to).
	public static float Distance(Vector2 from, Vector2 to)
	{
		var diffX = from.x - to.x;
		var diffY = from.y - to.y;
		return (float)Mathf.Sqrt(diffX * diffX + diffY * diffY);
	}

	[Inline]
	/// Returns a copy of (vector) with its magnitude clamped to (maxLength).
	public static Vector2 ClampMagnitude(Vector2 vector, float maxLength)
	{
		float sqrMagnitude = vector.sqrMagnitude;
		if (sqrMagnitude > maxLength * maxLength)
		{
			float mag = (float)Math.Sqrt(sqrMagnitude);

			//these intermediate variables force the intermediate result to be
			//of float precision. without this, the intermediate result can be of higher
			//precision, which changes behavior.
			float normalized_x = vector.x / mag;
			float normalized_y = vector.y / mag;
			return Vector2(normalized_x * maxLength,
				normalized_y * maxLength);
		}
		return vector;
	}

	public bool Equals(Vector2 other)
	{
		return x == other.x && y == other.y;
	}

	/// Adds two vectors.
	public static Vector2 operator +(Vector2 a, Vector2 b) { return Vector2(a.x + b.x, a.y + b.y); }
	/// Subtracts two vectors.
	public static Vector2 operator -(Vector2 a, Vector2 b) { return Vector2(a.x - b.x, a.y - b.y); }
	/// Mulitplies two vectors.
	public static Vector2 operator *(Vector2 a, Vector2 b) { return Vector2(a.x * b.x, a.y * b.y); }
	/// Divides two vectors.
	public static Vector2 operator /(Vector2 a, Vector2 b) { return Vector2(a.x / b.x, a.y / b.y); }
	/// Negates a vector.
	public static Vector2 operator -(Vector2 a) { return Vector2(-a.x, -a.y); }
	/// Adds a vector by a number.
	public static Vector2 operator +(Vector2 a, float d) { return Vector2(a.x + d, a.y + d); }
	public static Vector2 operator +(float a, Vector2 d) { return Vector2(a + d.x, a + d.y); }
	/// Subtracts a vector by a number.
	public static Vector2 operator -(Vector2 a, float d) { return Vector2(a.x - d, a.y - d); }
	public static Vector2 operator -(float a, Vector2 d) { return Vector2(a - d.x, a - d.y); }
	/// Multiplies a vector by a number.
	public static Vector2 operator *(Vector2 a, float d) { return Vector2(a.x * d, a.y * d); }
	public static Vector2 operator *(float a, Vector2 d) { return Vector2(a * d.x, a * d.y); }
	/// Divides a vector by a number.
	public static Vector2 operator /(Vector2 a, float d) { return Vector2(a.x / d, a.y / d); }
	public static Vector2 operator /(float a, Vector2 d) { return Vector2(a / d.x, a / d.y); }
}

[BonTarget]
public struct Vector2Int
{
	public int x = 0;
	public int y = 0;

	public this()
	{
	}

	public this(int x, int y)
	{
		this.x = x; this.y = y;
	}

	public this(int xy)
	{
		this.x = xy; this.y = xy;
	}
}