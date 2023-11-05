using System.Collections;
using Bon;

namespace FantyEngine;

[BonTarget]
public class SpriteAsset
{
	public int FPS;

	public List<SpriteFrame> Frames = new .() ~ if (_ != null) DeleteContainerAndItems!(_);

	public CollisionMask CollisionMask;

	public Vector2Int Origin = .(0, 0);

	[BonIgnore]
	public Vector2Int Size = .(64, 64);
}

[BonTarget]
public struct CollisionMask
{
	public Rectangle Rect;
}

[BonTarget]
public class SpriteFrame
{
	public int Length = 1;

	[BonIgnore]
	public Vector2Int TexturePageCoordinates = .();
}