using System;
using System.Interop;

namespace RaylibBeef;

/// Camera projection
public enum CameraProjection : c_int
{
	/// Perspective projection
	CAMERA_PERSPECTIVE = 0,
	/// Orthographic projection
	CAMERA_ORTHOGRAPHIC = 1,
}
