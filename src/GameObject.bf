using System;
namespace FantyEngine;

public class GameObject
{
	private Guid m_InstanceLayerID;

	private float m_internalX;
	private float m_InternalY;

	/// Horizontal position in the current room.
	public float x
	{
		get => m_internalX;
		set
		{
			m_internalX = value;
		}
	}
	/// Vertical position in the current room.
	public float y
	{
		get => m_InternalY;
		set
		{
			m_InternalY = value;
		}
	}

	public float xOrigin => (SpriteAsset == null ? 0 : SpriteAsset.Origin.x);
	public float yOrigin => (SpriteAsset == null ? 0 : SpriteAsset.Origin.y);

	/// Angle (rotation) of the Sprite.
	public float ImageAngle = 0.0f;

	private String m_SpriteIndex ~ if (_ != null) delete _;
	/// The name of the Sprite Asset.
	public String SpriteIndex
	{
		get { return m_SpriteIndex; }
		set
		{
			if (m_SpriteIndex != value)
			{
				if (m_SpriteIndex != null) delete m_SpriteIndex;
				m_SpriteIndex = new String(value);
				m_SpriteAsset = &AssetsManager.Sprites[m_SpriteIndex];
				m_ImageIndex = 0;
			}
		}
	}

	private Sprite* m_SpriteAsset;
	/// The actual SpriteAsset attached to the GameObject.
	public Sprite SpriteAsset { get { if (m_SpriteAsset == null) return null; return *m_SpriteAsset; } }

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

	private bool m_ExitedRoom = false;

	private CurrentSpriteProperties spriteProperties;

	public struct CurrentSpriteProperties
	{
		public float Clock;
		public int Frame = 0;
	}

	public void Destroy(GameObject gameObject)
	{
		var layer = Application.Instance.GetInstanceLayer(gameObject.m_InstanceLayerID);
		layer.GameObjects.Remove(gameObject);
		delete gameObject;
	}

	public virtual void CreateEvent(){}

	public virtual void DestroyEvent(){}

	public virtual void StepEvent(){}

	public virtual void BeginStepEvent(){}

	public virtual void EndStepEvent(){}

	public virtual void FixedStepEvent(){}

	public virtual void DrawEvent()
	{
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
			Fanty.DrawSpriteExt(SpriteIndex, m_ImageIndex, .(x, y), .(xOrigin, yOrigin), .(ImageXScale, ImageYScale), ImageAngle);

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