namespace System;

extension Boolean
{
	public static explicit operator Int(Boolean other)
	{
		if (other == true)
			return (Int)1;
		return (Int)0;
	}
}

extension Math
{
	public static bool IsWithin(float val, float min, float max)
	{
		return val >= min && val <= max;
	}

	public static bool IsWithin(int val, int min, int max)
	{
		return val >= min && val <= max;
	}
}