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
		var collisionMask = original.CollisionMask;
		let oBBox = Rectangle(
			(x - original.xOrigin) + collisionMask.x,
			(y - original.yOrigin),
			(x - original.xOrigin) + collisionMask.x + collisionMask.width,
			(y - original.yOrigin) + collisionMask.y + collisionMask.height);

		for (let layer in room.InstanceLayers)
		for (let obj in layer.value.GameObjects)
		{
			if (obj.GetType() == typeof(T))
			{
				// optimize in the future perhaps
				var objSpriteAsset = obj.CollisionMask;
				if (obj.ImageXScale < 0)
				{
					objSpriteAsset.x = obj.SpriteAsset.Size.x - (objSpriteAsset.x + objSpriteAsset.width);
				}
				if (obj.ImageYScale < 0)
				{
					objSpriteAsset.y = obj.SpriteAsset.Size.y - (objSpriteAsset.y + objSpriteAsset.height);
				}
				let objBox = Rectangle(
					(obj.x - obj.xOrigin) + objSpriteAsset.x,
					(obj.y - obj.yOrigin) + objSpriteAsset.y,
					(obj.x - obj.xOrigin) + objSpriteAsset.x + objSpriteAsset.width,
					(obj.y - obj.yOrigin) + objSpriteAsset.y + objSpriteAsset.height);
				if (objBox.Overlaps(oBBox))
				{
					return true;
				}
			}
		}
		
		return false;
	}
}