namespace FantyEngine;

public class GameObject
{
	public float x;
	public float y;

	public virtual void CreateEvent(){}

	public virtual void DestroyEvent(){}

	public virtual void StepEvent(){}

	public virtual void BeginStepEvent(){}

	public virtual void EndStepEvent(){}

	public virtual void FixedStepEvent(){}

	public virtual void DrawEvent()
	{
		/*
		if (!String.IsNullOrEmpty(SpriteIndex))
		{
			if (SpriteAsset.Frames.Count > 1 && ImageSpeed > 0.0f)
			{
				spriteProperties.Clock += 1.0f / GameOptions.TargetFixedStep;
				var currentFrame = spriteProperties.Frame % SpriteAsset.Frames.Count;
				var secondsPerFrame = ((float)SpriteAsset.Frames[currentFrame].Length / SpriteAsset.FPS) * ImageSpeed;
				while (spriteProperties.Clock >= secondsPerFrame)
				{
					spriteProperties.Clock -= secondsPerFrame;
					spriteProperties.Frame++;
					m_ImageIndex = spriteProperties.Frame;
					if (spriteProperties.Frame >= SpriteAsset.Frames.Count)
					{
						spriteProperties.Frame = 0;
						m_ImageIndex = 0;
						AnimationEndEvent();
					}
				}
			}
			// Fanty.DrawSprite(SpriteIndex, m_ImageIndex, x - xOrigin, y - yOrigin, ImageXScale, ImageYScale, ImageAngle);
			// Fanty.DrawSpriteExt(SpriteIndex, m_ImageIndex, .(x, y), .(xOrigin, yOrigin), .(ImageXScale, ImageYScale), ImageAngle);

			/*
			var collisionMask = CollisionMask;

			var oBBox = Rectangle(
				(x - xOrigin) + collisionMask.x,
				(y - yOrigin) + collisionMask.y,
				collisionMask.width,
				collisionMask.height);

			RaylibBeef.Raylib.DrawRectangleRec(.(oBBox.x, oBBox.y, oBBox.width, oBBox.height), Color(255, 0, 0, 150));
			*/
		}
		*/
	}

	public virtual void DrawGUIEvent(){}

	public virtual void DrawBeginEvent(){}

	public virtual void DrawEndEvent(){}

	public virtual void DrawGUIBeginEvent(){}

	public virtual void DrawGUIEndEvent(){}

	public virtual void PreDrawEvent(){}

	public virtual void PostDrawEvent(){}

	public virtual void WindowResizeEvent(){}

	public virtual void OutsideRoomEvent(){}

	public virtual void AnimationEndEvent(){}
}