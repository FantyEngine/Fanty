using System;

namespace FantyEngine;

public static class Fanty
{
	private static Room GetCurrentRoom()
	{
		return Application.Instance.[Friend]m_RoomRuntime.Room;
	}

	private static GameObject GetCurrentGameObject()
	{
		return *Application.Instance.[Friend]m_RoomRuntime.CurrentGameObject;
	}
}