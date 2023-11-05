using System;

namespace FantyEngine;

public static class Fanty
{
	internal static Random RandomInstance = new .() ~ delete _;


	internal static FantyEngine.RoomInstance GetCurrentRoom()
	{
		return null;
		// return Application.Instance.[Friend]m_RoomRuntime.Room;
	}

	internal static FantyEngine.GameObjectInstance GetCurrentGameObject()
	{
		return null;
		// return *Application.Instance.[Friend]m_RoomRuntime.CurrentGameObject;
	}
}