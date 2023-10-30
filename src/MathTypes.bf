using Bon;
namespace FantyEngine;

[BonTarget]
public struct Vector2
{
	public float x = 0;
	public float y = 0;

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

[BonTarget]
public struct Vector3
{
	public float x = 0;
	public float y = 0;
	public float z = 0;

	public this()
	{
	}

	public this(float x, float y)
	{
		this.x = x; this.y = y; this.z = 0;
	}

	public this(float x, float y, float z)
	{
		this.x = x; this.y = y; this.z = z;
	}

	public this(float xyz)
	{
		this.x = xyz; this.y = xyz; this.z = xyz;
	}
}

[BonTarget]
public struct Vector4
{
	public float x = 0;
	public float y = 0;
	public float z = 0;
	public float w = 0;

	public this()
	{
	}

	public this(float x, float y, float z, float w)
	{
		this.x = x; this.y = y; this.z = z; this.w = w;
	}

	public this(float xyzw)
	{
		this.x = xyzw; this.y = xyzw; this.z = xyzw; this.w = xyzw;
	}
}

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
			other.width > x &&
			other.x < width &&
			other.height > y &&
			other.y < height);
	}

	public static implicit operator RaylibBeef.Rectangle(Rectangle rect)
	{
		return .(rect.x, rect.y, rect.width, rect.height);
	}
}