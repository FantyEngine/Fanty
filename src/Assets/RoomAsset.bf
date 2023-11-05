using System;
using System.Collections;
using Bon;

namespace FantyEngine;

[BonTarget]
public class RoomAsset
{
	public int Width = 1024;
	public int Height = 768;

	public List<InstanceLayer> InstanceLayers = new .() ~ DeleteContainerAndItems!(_);
	public List<BackgroundLayer> BackgroundLayers = new .() ~ DeleteContainerAndItems!(_);

	public bool EnableViewports = false;
	public Viewport Viewport0 = .(true, .(0, 0, 1024, 768), .(0, 0, 1024, 768));

	[BonTarget]
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

	[BonTarget]
	public class Layer
	{
		public Guid GUID { get; set; }
		public String Name = new .() ~ if (_ != null) delete _;
		public Vector2 Position = .(0, 0);

		public void SetName(String newName)
		{
			delete this.Name;
			this.Name = new String(newName);
		}
	}

	[BonTarget]
	public class InstanceLayer : Layer
	{
		public List<GameObjectInstance> GameObjects = new .() ~ DeleteContainerAndItems!(_);
	}

	[BonTarget]
	public class BackgroundLayer : Layer
	{
		public String Sprite { get; private set; } ~ if (_ != null) delete _;
		public Color Color = .white;
		public bool HorizontalTile = false;
		public bool VerticalTile = false;
		public bool Stretch = false;
		public Vector2 Speed = .zero;

		public void SetSprite(String assetName)
		{
			delete Sprite;
			this.Sprite = new String(assetName);
		}

		public bool HasSprite()
		{
			return !String.IsNullOrEmpty(Sprite);
		}
	}

	public enum LayerType
	{
		Instance,
		Background
	}

	public Layer GetLayerByID(LayerID id)
	{
		for (var layer in InstanceLayers)
			if (layer.GUID == id)
				return layer;
		for (var layer in BackgroundLayers)
			if (layer.GUID == id)
				return layer;

		return null;
	}
}