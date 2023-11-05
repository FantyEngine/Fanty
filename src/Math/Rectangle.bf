using System;
using Bon;

namespace FantyEngine;

[BonTarget]
public struct Rectangle
{
	public float x = 0;
	public float y = 0;
	public float width = 0;
	public float height = 0;

	public Vector2 size
	{
		get { return .(width, height); }
		set mut { width = value.x; height = value.y; }
	}

	public float xMin
	{
		get => x;
		// get => Math.Min(x, width);
	}
	public float yMin
	{
		get => y;
		// get => Math.Min(y, height);
	}
	public float xMax
	{
		get => width;
		// get => Math.Max(x, width);
	}
	public float yMax
	{
		get => height;
		// get => Math.Max(y, height);
	}

	public this()
	{
	}

	public this(float x, float y, float width, float height)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public bool Overlaps(Rectangle other)
	{
		return (
			other.xMax > xMin &&
			other.xMin < xMax &&
			other.yMax > yMin &&
			other.yMin < yMax);
	}

	public static implicit operator RaylibBeef.Rectangle(Rectangle rect)
	{
		return .(rect.x, rect.y, rect.width, rect.height);
	}
}