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

	public Vector2 center
	{
		get => Vector2(x + width * 0.5f, y + height * 0.5f);
		set mut
		{
			x = value.x - width * 0.5f;
			y = value.y - height * 0.5f;
		}
	}

	public float left
	{
		get => x;
		set mut
		{
			let prevX = x;
			x = value;
			width = Mathf.Max(width + prevX - x, 0);
		}
	}

	public float right
	{
		get => x + width;
		set mut
		{
			let prevX = x;
			x = value;
			width = Mathf.Max(width + prevX - x, 0);
		}
	}

	public float top
	{
		get => y;
		set mut
		{
			let prevY = y;
			y = value;
			height = Mathf.Max(height + prevY - y, 0);
		}
	}

	public float bottom
	{
		get => y + height;
		set mut
		{
			height = value - y;
			y = Mathf.Min(y, y + height);
		}
	}

	public float area => width * height;

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

	public bool Contains(Rectangle other)
	{
		return (left < other.left && top < other.top && bottom > other.bottom && right > other.right);
	}

	public bool Contains(Vector2 vector)
	{
		return vector.x >= x && vector.x < x + width && vector.y >= y && vector.y < y + height;
	}

	public override void ToString(String strBuffer)
	{
		strBuffer.Append("Rectangle (");
		x.ToString(strBuffer);
		strBuffer.Append(", ");
		y.ToString(strBuffer);
		strBuffer.Append(", ");
		width.ToString(strBuffer);
		strBuffer.Append(", ");
		height.ToString(strBuffer);
		strBuffer.Append(")");
	}

	public static bool operator == (Rectangle a, Rectangle b) => a.x == b.x && a.y == b.y && a.width == b.width && a.height == b.height;
	public static Rectangle operator + (Rectangle a, Rectangle b) => .(a.x + b.x, a.y + b.y, a.width, a.height);
	public static Rectangle operator - (Rectangle a, Rectangle b) => .(a.x - b.x, a.y - b.y, a.width, a.height);

	public static implicit operator RaylibBeef.Rectangle(Rectangle rect)
	{
		return .(rect.x, rect.y, rect.width, rect.height);
	}
}