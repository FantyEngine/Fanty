using System.Collections;
using System;
using Bon;

namespace FantyEngine;

public typealias LayerID = Guid;

[BonTarget]
public class Room
{
	public int Width = 1024;
	public int Height = 768;

	public Dictionary<Guid, InstanceLayer> InstanceLayers = new .() ~ DeleteDictionaryAndValues!(_);
	public Dictionary<Guid, BackgroundLayer> BackgroundLayers = new .() ~ DeleteDictionaryAndValues!(_);

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

	public Layer GetLayerByID(LayerID id)
	{
		for (var layer in InstanceLayers)
			if (layer.key == id)
				return layer.value;
		for (var layer in BackgroundLayers)
			if (layer.key == id)
				return layer.value;

		return null;
	}

	public GameObject GetGameObjectByGuid(Guid guid)
	{
		for (var layer in InstanceLayers)
		{
			for (var gameobject in layer.value.GameObjects)
			{
				if (gameobject.key == guid)
					return gameobject.value;
			}
		}
		return null;
	}

	public class Layer
	{
		public String Name { get; private set; } = new .() ~ if (_ != null) delete _;
		public Vector2 Position = .(0, 0);

		public void SetName(String newName)
		{
			delete this.Name;
			this.Name = new String(newName);
		}
	}

	public class InstanceLayer : Layer
	{
		public Dictionary<Guid, GameObject> GameObjects = new .() ~
			DeleteDictionaryAndValues!(_);
	}

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
}