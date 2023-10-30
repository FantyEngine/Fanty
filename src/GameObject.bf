using System;
namespace FantyEngine;

public class GameObject
{
	public float x;
	public float y;

	public Vector2 Scale = .(1, 1);

	private String m_SpriteIndex ~ if (_ != null) delete _;
	public String SpriteIndex
	{
		get { return m_SpriteIndex; }
		set
		{
			m_SpriteIndex = value;
			m_SpriteAsset = &AssetsManager.Sprites[m_SpriteIndex];
		}
	}

	private Sprite* m_SpriteAsset;
	public Sprite SpriteAsset { get { return *m_SpriteAsset; } }

	private int m_ImageIndex = 0;
	public int ImageIndex { get => m_ImageIndex; set { m_ImageIndex = value; } }

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
		spriteProperties.Clock += Fanty.DeltaTime;
		var currentFrame = spriteProperties.Frame % SpriteAsset.Frames.Count;
		var secondsPerFrame = (float)SpriteAsset.Frames[currentFrame].Length / SpriteAsset.FPS;
		while (spriteProperties.Clock >= secondsPerFrame)
		{
			spriteProperties.Clock -= secondsPerFrame;
			spriteProperties.Frame++;
			if (spriteProperties.Frame >= SpriteAsset.Frames.Count)
				spriteProperties.Frame = 0;
			m_ImageIndex = spriteProperties.Frame;
		}

		Fanty.DrawSprite(SpriteIndex, m_ImageIndex, x, y);
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