using System;
using Bon;

namespace FantyEngine;

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