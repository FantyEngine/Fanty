using System;

namespace FantyEngine;

public class GameObject
{
	public float x;
	public float y;

	public float xOrigin => (m_SpriteAsset == null ? 0 : m_SpriteAsset.Origin.x);
	public float yOrigin => (m_SpriteAsset == null ? 0 : m_SpriteAsset.Origin.y);

	private float m_ImageXScale = 1.0f;
	private float m_ImageYScale = 1.0f;
	public float ImageXScale { get => m_ImageXScale; set { m_ImageXScale = value; } }
	public float ImageYScale { get => m_ImageYScale; set { m_ImageYScale = value; } }

	private String m_SpriteIndex ~ if (_ != null) delete _;
	private SpriteAsset m_SpriteAsset => (String.IsNullOrEmpty(m_SpriteIndex) ? null : AssetsManager.Sprites[m_SpriteIndex]);

	private int m_ImageIndex = 0;
	public int ImageIndex { get => m_ImageIndex; set { m_ImageIndex = value; } }

	private float m_ImageSpeed = 1.0f;

	private float m_ImageAngle = 0.0f;
	public float ImageAngle { get => m_ImageAngle; set { m_ImageAngle = value; } }

	private CurrentSpriteProperties m_SpriteProperties;

	private struct CurrentSpriteProperties
	{
		public float Clock;
		public int Frame = 0;
	}

	public virtual void CreateEvent(){}

	public virtual void DestroyEvent(){}

	public virtual void StepEvent(){}

	public virtual void BeginStepEvent(){}

	public virtual void EndStepEvent(){}

	public virtual void FixedStepEvent(){}

	public virtual void DrawEvent()
	{

		if (m_SpriteAsset != null)
		{
			if (m_SpriteAsset.Frames.Count > 1 && m_ImageSpeed > 0.0f)
			{
				m_SpriteProperties.Clock += 1.0f / GameOptions.TargetFixedStep;
				var currentFrame = m_SpriteProperties.Frame % m_SpriteAsset.Frames.Count;
				var secondsPerFrame = ((float)m_SpriteAsset.Frames[currentFrame].Length / m_SpriteAsset.FPS) * m_ImageSpeed;
				while (m_SpriteProperties.Clock >= secondsPerFrame)
				{
					m_SpriteProperties.Clock -= secondsPerFrame;
					m_SpriteProperties.Frame++;
					m_ImageIndex = m_SpriteProperties.Frame;
					if (m_SpriteProperties.Frame >= m_SpriteAsset.Frames.Count)
					{
						m_SpriteProperties.Frame = 0;
						m_ImageIndex = 0;
						AnimationEndEvent();
					}
				}
			}
			// Fanty.DrawSprite(m_SpriteIndex, m_ImageIndex, x - xOrigin, y - yOrigin, ImageXScale, ImageYScale, ImageAngle);
			Fanty.DrawSpriteExt(m_SpriteIndex, m_ImageIndex, .(x, y), .(xOrigin, yOrigin), .(ImageXScale, ImageYScale), ImageAngle);

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