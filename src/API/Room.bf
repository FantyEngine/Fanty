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
		=> GetCurrentRoom().Width;
}