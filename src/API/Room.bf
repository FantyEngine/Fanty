using System;
namespace FantyEngine;

public typealias Camera = int;

extension Fanty
{
	public static Camera ViewCamera(int index)
	{
		return index;
	}

	public static float CameraGetViewWidth(Camera cam)
	{
		return GetCurrentRoom().Viewport0.CameraProperties.width;
	}

	public static float CameraGetViewHeight(Camera cam)
	{
		return GetCurrentRoom().Viewport0.CameraProperties.height;
	}

	public static void CameraSetViewPos(Camera cam, float x, float y)
	{
		var viewport = GetCurrentRoom().Viewport0;
		if (viewport.Visible)
		{
			Application.Instance.[System.Friend]m_RoomRuntime.Room.Viewport0.CameraProperties = .(x, y, viewport.CameraProperties.width, viewport.CameraProperties.height);
		}
	}

	/// The width of the current room in pixels.
	public static float RoomWidth
		=> GetCurrentRoom().Width;

	/// The width of the current room in pixels.
	public static float RoomHeight
		=> GetCurrentRoom().Height;

	public static LayerID LayerBackgroundCreate(int depth, String name, String spriteAsset)
	{
		let id = Guid.Create();
		var layer = new Room.BackgroundLayer() { Color = .white };

		layer.SetName(name);
		layer.SetSprite(spriteAsset);

		Application.Instance.[System.Friend]m_RoomRuntime.Room.BackgroundLayers.Add(id, layer);
		return id;
	}

	public static void LayerBackgroundSetHTiled(LayerID layer, bool tiled)
		=> ((Room.BackgroundLayer)(GetCurrentRoom().GetLayerByID(layer))).HorizontalTile = tiled;

	public static void LayerBackgroundSetVTiled(LayerID layer, bool tiled)
		=> ((Room.BackgroundLayer)(GetCurrentRoom().GetLayerByID(layer))).VerticalTile = tiled;

	public static bool LayerBackgroundGetHTiled(LayerID layer)
		=> ((Room.BackgroundLayer)GetCurrentRoom().GetLayerByID(layer)).HorizontalTile;

	public static bool LayerBackgroundGetVTiled(LayerID layer)
		=> ((Room.BackgroundLayer)GetCurrentRoom().GetLayerByID(layer)).VerticalTile;

	public static void LayerSetX(LayerID layer, float newX)
	{
		GetCurrentRoom().GetLayerByID(layer).Position.x = newX;
	}

	public static void LayerSetY(LayerID layer, float newY)
	{
		GetCurrentRoom().GetLayerByID(layer).Position.y = newY;
	}
}