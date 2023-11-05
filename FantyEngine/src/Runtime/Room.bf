using System.Collections;
using System;
using Bon;

namespace FantyEngine;

public typealias LayerID = Guid;

public class RoomInstance // Maybe an interface could be useful here?
{
	public int Width;
	public int Height;

	public List<InstanceLayer> InstanceLayers = new .() ~ DeleteContainerAndItems!(_);
	public List<BackgroundLayer> BackgroundLayers = new .() ~ DeleteContainerAndItems!(_);

	public bool EnableViewports = false;
	public RoomAsset.Viewport Viewport0 = .(true, .(0, 0, 1024, 768), .(0, 0, 1024, 768));

	public class Layer
	{
		public Guid GUID { get; set; }
		public Vector2 Position = .(0, 0);
	}

	public class InstanceLayer : Layer
	{
		public List<GameObject> GameObjects = new .() ~ DeleteContainerAndItems!(_);
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

	/*
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
	*/

}