using System;

namespace FantyEngine;

public static class Mathf
{
	public const float PI = Math.PI_f;
	public const float PIOver4 = (Math.PI_f / 4.0f);

	/// A representation of positive infinity.
	public const float Infinity = float.PositiveInfinity;

	/// A representation of negative infinity.
	public const float NegativeInfinity = float.NegativeInfinity;

	/// Degrees to radians conversion constant.
	public const float Deg2Rad = PI * 2f / 360f;

	/// Radians to degrees conversion constant.
	public const float Rad2Deg = 1f / Deg2Rad;

	/// Returns the sine of the angle (f) in radians.
	public static float Sin(float f) { return (float)Math.Sin(f); }

	/// Returns the cosine of the angle (f) in radians.
	public static float Cos(float f) { return (float)Math.Cos(f); }

	/// Returns the tangent of the angle (f) in radians.
	public static float Tan(float f) { return (float)Math.Tan(f); }

	/// Returns the arc-sine of (f) - the angle in radians whose sine is (f).
	public static float Asin(float f) { return (float)Math.Asin(f); }

	/// Returns the arc-cosine of (f) - the angle in radians whose cosine is (f).
	public static float Acos(float f) { return (float)Math.Acos(f); }

	/// Returns the arc-tangent of (f) - the angle in radians whose tangent is (f).
	public static float Atan(float f) { return (float)Math.Atan(f); }

	/// Returns the angle in radians whose Tan is (y/x).
	public static float Atan2(float y, float x) { return(float)Math.Atan2(y, x); }

	/// Returns square root of (f).
	public static float Sqrt(float f) { return (float)Math.Sqrt(f); }

	/// Returns the absolute value of (f).
	public static float Abs(float f) { return (float)Math.Abs(f); }

	/// Returns the absolute value of (f).
	public static int Abs(int f) { return Math.Abs(f); }

	/// Returns the sign of (f).
	public static float Sign(float f) { return f >= 0F ? 1F : -1F; }

	/// Returns (f) raised to power of (p).
	public static float Pow(float f, float p) { return (float)Math.Pow(f, p); }

	/// Returns e raised to the specified power.
	public static float Exp(float power) { return (float)Math.Exp(power); }

	/// Returns the logarithm of a specified number in a specified base.
	public static float Log(float f, float p) { return (float)Math.Log(f, p); }

	/// Returns the natural (base e) logarithm of a specified number.
	public static float Log(float f) { return (float)Math.Log(f); }

	/// Returns the base 10 logarithm of a specified number.
	public static float Log10(float f) { return (float)Math.Log10(f); }

	/// Returns the smallest integer greater to or equal to (f).
	public static float Ceil(float f) { return (float)Math.Ceiling(f); }

	/// Returns the largest integer smaller to or equal to (f).
	public static float Floor(float f) { return (float)Math.Floor(f); }

	/// Returns (f) rounded to the nearest integer.
	public static float Round(float f) { return (float)Math.Round(f); }

	/// Returns the smallest integer greater to or equal to (f).
	public static int CeilToInt(float f) { return (int)Math.Ceiling(f); }

	/// Returns the largest integer smaller to or equal to (f).
	public static int FloorToInt(float f) { return (int)Math.Floor(f); }

	/// Returns (f) rounded to the nearest integer.
	public static int RoundToInt(float f) { return (int)Math.Round(f); }

	/// Returns largest of two values.
	public static float Max(float a, float b) { return a > b ? a : b; }

	/// Returns smallest of two values.
	public static float Min(float a, float b) { return a < b ? a : b; }


	/// Clamps value between (min) and (max).
	public static float Clamp(float value, float min, float max)
	{
		var value;
		if (value < min)
			value = min;
		else if (value > max)
			value = max;
		return value;
	}

	/// Clamps value between (min) and (max).
	public static int Clamp(int value, int min, int max)
	{
		var value;
		if (value < min)
			value = min;
		else if (value > max)
			value = max;
		return value;
	}

	/// Clamps (value) between 0 and 1.
	public static float Clamp01(float value)
	{
		if (value < 0F)
			return 0F;
		else if (value > 1f)
			return 1f;
		else
			return value;
	}

	/// Interpolates between (a) and (b) by (t).
	/// (t) is clamped between 0 and 1.
	public static float Lerp(float a, float b, float t)
	{
		return a + (b - a) * Clamp01(t);
	}

	/// Interpolates between (a) and (b) by (t).
	public static float LerpUnclamped(float a, float b, float t)
	{
		return a + (b - a) * t;
	}
	
	/// Converts two numbers to a range of 0 - 1.
	public static float Normalize(float val, float min, float max)
	{
		return (val - min) / (max - min);
	}

	/// Converts a normalized value to a set range from (min) - (max).
	public static float DeNormalize(float val, float min, float max)
	{
		return (val * (max - min) + min);
	}

	/// Loops the value (t), so that it is never larger than (length) and never smaller than 0.
	public static float Repeat(float t, float length)
	{
		return Clamp(t - Mathf.Floor(t / length) * length, 0.0f, length);
	}

	/// Rounds float to nearest interval.
	public static float Round2Nearest(float a, float interval)
	{
		return a - (a % interval);
	}

	/// Returns true if a value is within a certain range.
	public static bool IsWithin(float val, float min, float max)
	{
		return val >= min && val <= max;
	}

	/// Returns true if a value is within a certain range.
	public static bool IsWithin(this int val, int min, int max)
	{
		return val >= min && val <= max;
	}

	/// Returns true if a value is within a certain range.
	public static bool IsWithin(Vector2 val, Vector2 min, Vector2 max)
	{
		return IsWithin(val.x, min.x, max.x) && IsWithin(val.y, min.y, max.y);
	}

	public static bool IsWithin(Vector2 val, Rectangle rect)
	{
		return IsWithin(val, Vector2(rect.x, rect.y), Vector2(rect.width, rect.height));
	}

	/// Counts the amount of digits in an integer.
	public static int CountDigits(int number)
	{
		var number;
		if (number == 0)
			return 1; // Handle special case for zero, which has one digit

		int count = 0;
		while (number != 0)
		{
			count++;
			number /= 10;
		}

		return count;
	}
}