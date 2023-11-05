using System.Collections;
using System;
using Bon;

namespace FantyEngine;

public typealias LayerID = Guid;

public class RoomInstance : RoomAsset
{
	
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