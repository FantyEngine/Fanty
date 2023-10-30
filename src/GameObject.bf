using System;
namespace FantyEngine;

public class GameObject
{
	public float x;
	public float y;

	private String m_SpriteIndex ~ if (_ != null) delete _;
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
	public Sprite SpriteAsset { get { return *m_SpriteAsset; } }

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

	public virtual void Create(){}

	public virtual void Destroy(){}

	public virtual void Step(){}

	public virtual void BeginStep(){}

	public virtual void EndStep(){}

	public virtual void FixedStep(){}

	public virtual void Draw()
	{
		if (SpriteAsset.Frames.Count > 1 && ImageSpeed > 0.0f)
		{
			spriteProperties.Clock += Fanty.DeltaTime;
			var currentFrame = spriteProperties.Frame % SpriteAsset.Frames.Count;
			var secondsPerFrame = ((float)SpriteAsset.Frames[currentFrame].Length / SpriteAsset.FPS) * ImageSpeed;
			while (spriteProperties.Clock >= secondsPerFrame)
			{
				spriteProperties.Clock -= secondsPerFrame;
				spriteProperties.Frame++;
				if (spriteProperties.Frame >= SpriteAsset.Frames.Count)
					spriteProperties.Frame = 0;
				m_ImageIndex = spriteProperties.Frame;
			}
		}

		var collisionMask = CollisionMask;

		var oBBox = Rectangle(
			x + collisionMask.x,
			y + collisionMask.y,
			collisionMask.width,
			collisionMask.height);
		Fanty.DrawSprite(SpriteIndex, m_ImageIndex, x, y, ImageXScale, ImageYScale, 0);

		// let minY = Math.Min(oBBox.y, oBBox.height);
		// let maxY = Math.Max(oBBox.y, oBBox.height);
		RaylibBeef.Raylib.DrawRectangleRec(.(oBBox.x, oBBox.y, oBBox.width, oBBox.height), Color(255, 0, 0, 150));
		// Fanty.DrawRectangleColor(oBBox.x, oBBox.y, oBBox.width, oBBox.height, Color(255, 0, 0, 150));
	}

	public virtual void DrawGUI(){}

	public virtual void DrawBegin(){}

	public virtual void DrawEnd(){}

	public virtual void DrawGUIBegin(){}

	public virtual void DrawGUIEnd(){}

	public virtual void PreDraw(){}

	public virtual void PostDraw(){}

	public virtual void WindowResize(){}
}