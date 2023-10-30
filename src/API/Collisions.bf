using System;

namespace FantyEngine;

extension Fanty
{
	public static bool PlaceMeeting<T>(float x, float y) where T : GameObject
	{
		let room = GetCurrentRoom();
		let original = GetCurrentGameObject();

		if (String.IsNullOrEmpty(original.SpriteIndex))
			return false;
		let spriteAsset = original.SpriteAsset;
		// let colMaskRect = Rectangle(spriteAsset.CollisionMask.Left, spriteAsset.CollisionMask.Bottom, spriteAsset.CollisionMask.Right, spriteAsset.CollisionMask.Top);

		let oBBox = Rectangle(
			x + spriteAsset.CollisionMask.Rect.x,
			y + spriteAsset.CollisionMask.Rect.y,
			x + spriteAsset.CollisionMask.Rect.z * original.Scale.x,
			y + spriteAsset.CollisionMask.Rect.w * original.Scale.y);

		for (let obj in room.GameObjects)
		{
			if (obj.GetType() == typeof(T))
			{
				// optimize in the future perhaps
				var objSpriteAsset = obj.SpriteAsset;
				let objBox = Rectangle(
					obj.x + objSpriteAsset.CollisionMask.Rect.x,
					obj.y + objSpriteAsset.CollisionMask.Rect.y,
					obj.x + objSpriteAsset.CollisionMask.Rect.z * obj.Scale.x,
					obj.y + objSpriteAsset.CollisionMask.Rect.w * obj.Scale.y);
				if (objBox.Overlaps(oBBox))
				{
					return true;
				}
			}
		}
		return false;
	}
}