using System;
using Bon;

namespace FantyEngine;

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