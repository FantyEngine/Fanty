using System;

namespace FantyEngine;

public static class Fanty
{
	internal static Random RandomInstance = new .() ~ delete _;

	internal static Room GetCurrentRoom()
	{
		return Application.Instance.[Friend]m_RoomRuntime.Room;
	}

	internal static GameObject GetCurrentGameObject()
	{
		return *Application.Instance.[Friend]m_RoomRuntime.CurrentGameObject;
	}
}