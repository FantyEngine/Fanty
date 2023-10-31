using System.Collections;
using System;

namespace FantyEngine;

public class Room
{
	public int Width = 1024;
	public int Height = 768;

	public Dictionary<Guid, InstanceLayer> InstanceLayers = new .() ~ DeleteDictionaryAndValues!(_);
	public Dictionary<Guid, BackgroundLayer> BackgroundLayers = new .() ~ DeleteDictionaryAndValues!(_);

	public Color BackgroundColor = Color(84, 84, 84, 255);

	public bool EnableViewports = false;
	public Viewport Viewport0 = .(true, .(0, 0, 1024, 768), .(0, 0, 1024, 768));

	public struct Viewport
	{
		public bool Visible = false;
		public Rectangle CameraProperties;
		public Rectangle ViewportProperties;

		public this(bool visible, Rectangle cameraProperties, Rectangle viewportProperties)
		{
			this.Visible = visible;
			this.CameraProperties = cameraProperties;
			this.ViewportProperties = viewportProperties;
		}
	}

	public class Layer
	{
		public String Name = new .() ~ if (Name != null) delete _;
	}

	public class InstanceLayer : Layer
	{
		public List<GameObject> GameObjects = new .() ~
			DeleteContainerAndItems!(_);
	}

	public class BackgroundLayer : Layer
	{
		public Color Color = .white;
		public bool HorizontalTile = false;
		public bool VerticalTile = false;
		public bool Stretch = false;
		public Vector2 Offset = .zero;
		public Vector2 Speed = .zero;
	}

	public enum LayerType
	{
		Instance,
		Background
	}
}