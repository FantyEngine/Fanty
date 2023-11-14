using System;
using Bon;

namespace FantyEngine;

[BonTarget]
public class GameObjectAsset : Asset
{
	public String Name = new .() ~ if (_ != null) delete _;

	public String SpriteAssetID ~ if (_ != null) delete _;
	private SpriteAsset* m_SpriteAsset;
	public SpriteAsset SpriteAsset
	{
		get
		{
			return *m_SpriteAsset;
		}
	}

	public String CollisionMaskAsset ~ if (_ != null) delete _;
	public bool CollisionMaskSameAsSprite = true;

	public bool Visible;
	public bool Persistent;
	public bool Solid;

	public void SetName(String name)
	{
		this.Name.Set(name);
	}

	public void SetSpriteAsset(ref String id)
	{
		SpriteAssetID = id;

		if (AssetsManager.Sprites.ContainsKey(id))
			this.m_SpriteAsset = &AssetsManager.Sprites[id];
	}

	public void SetSpriteAsset(ref SpriteAsset asset)
	{
		this.m_SpriteAsset = &asset;
	}

	public bool HasSprite()
	{
		return m_SpriteAsset != null;
	}

	public SpriteAsset GetSpriteAsset()
	{
		if (HasSprite())
		{
			return *m_SpriteAsset;
		}
		return null;
	}
}