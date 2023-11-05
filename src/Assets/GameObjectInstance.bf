using System;
using Bon;

namespace FantyEngine;

[BonTarget]
public class GameObjectInstance
{
	public String AssetName = new .() ~ if (_ != null) delete _;

	public void SetAssetName(String value)
	{
		delete AssetName;
		AssetName = new .(value);
	}

	public GameObjectAsset GameObjectAsset { get { if (String.IsNullOrEmpty(AssetName)) return null; return AssetsManager.GameObjectAssets[AssetName]; } }
	public SpriteAsset SpriteAsset { get { if (GameObjectAsset != null) return AssetsManager.Sprites[GameObjectAsset.SpriteAssetName]; else return null; } }

	public Guid InstanceLayerID { get; private set; }
	public Guid GameObjectID { get; private set; }

	public float x;
	public float y;

	public float xOrigin => (SpriteAsset == null ? 0 : SpriteAsset.Origin.x);
	public float yOrigin => (SpriteAsset == null ? 0 : SpriteAsset.Origin.y);

	/// Angle (rotation) of the Sprite.
	public float ImageAngle = 0.0f;

	public bool HasSprite()
	{
		return SpriteAsset != null;
	}

	private int m_ImageIndex = 0;
	public int ImageIndex { get => m_ImageIndex; set { m_ImageIndex = value; } }

	public float ImageSpeed = 1.0f;

	public String CollisionMaskAsset ~ if (_ != null) delete _;
	public bool CollisionMaskSameAsSprite = true;
	public Rectangle CollisionMask
	{
		get
		{
			Rectangle mask = .();
			if (CollisionMaskSameAsSprite)
			{
				mask = SpriteAsset.CollisionMask.Rect;
			}
			else
			{
				mask = AssetsManager.Sprites[CollisionMaskAsset].CollisionMask.Rect;
			}

			if (ImageXScale < 0)
			{
				mask.x = SpriteAsset.Size.x - (mask.x + mask.width);
			}
			if (ImageYScale < 0)
			{
				mask.y = SpriteAsset.Size.y - (mask.y + mask.height);
			}

			mask.x = mask.x * Math.Abs(ImageXScale);
			mask.y = mask.y * Math.Abs(ImageYScale);
			mask.width = mask.width * Math.Abs(ImageXScale);
			mask.height = mask.height * Math.Abs(ImageYScale);
			return mask;
		}
	}

	public float ImageXScale = 1.0f;
	public float ImageYScale = 1.0f;

	public bool Visible;
	public bool Solid;
	public bool Persistent;

	private CurrentSpriteProperties spriteProperties;

	public struct CurrentSpriteProperties
	{
		public float Clock;
		public int Frame = 0;
	}

	/*
	public void Destroy(GameObject gameObject)
	{
		var layer = Application.Instance.GetInstanceLayer(gameObject.InstanceLayerID);
		layer.GameObjects.Remove(gameObject.GameObjectID);
		delete gameObject;
	}
	*/
}