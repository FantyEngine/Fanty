using System;
using Bon;

namespace FantyEngine;

[BonTarget]
public class GameObjectAsset
{
	public String Name = new .() ~ if (_ != null) delete _;

	public String SpriteAssetName = new .() ~ if (_ != null) delete _;
	private SpriteAsset* SpriteAsset;

	public String CollisionMaskAsset ~ if (_ != null) delete _;
	public bool CollisionMaskSameAsSprite = true;

	public bool Visible;
	public bool Persistent;
	public bool Solid;

	public void SetName(String name)
	{
		delete Name;
		this.Name = new String(name);
	}

	public void SetSpriteAssetName(String name)
	{
		var newName = new String(name);
		delete SpriteAssetName;
		this.SpriteAssetName = newName;

		if (AssetsManager.Sprites.ContainsKey(SpriteAssetName))
			this.SpriteAsset = &AssetsManager.Sprites[SpriteAssetName];
	}

	public bool HasSprite()
	{
		return SpriteAsset != null;
	}

	public SpriteAsset GetSpriteAsset()
	{
		if (HasSprite())
		{
			return *SpriteAsset;
		}
		return null;
	}
}