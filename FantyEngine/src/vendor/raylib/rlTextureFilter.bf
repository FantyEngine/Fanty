using System;
using System.Interop;

namespace RaylibBeef;

/// Texture parameters: filter mode
public enum rlTextureFilter : c_int
{
	/// No filter, just pixel approximation
	RL_TEXTURE_FILTER_POINT = 0,
	/// Linear filtering
	RL_TEXTURE_FILTER_BILINEAR = 1,
	/// Trilinear filtering (linear with mipmaps)
	RL_TEXTURE_FILTER_TRILINEAR = 2,
	/// Anisotropic filtering 4x
	RL_TEXTURE_FILTER_ANISOTROPIC_4X = 3,
	/// Anisotropic filtering 8x
	RL_TEXTURE_FILTER_ANISOTROPIC_8X = 4,
	/// Anisotropic filtering 16x
	RL_TEXTURE_FILTER_ANISOTROPIC_16X = 5,
}
