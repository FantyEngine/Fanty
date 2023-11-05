using System;

namespace FantyEngine;

public static class Fanty
{
	internal static Random RandomInstance = new .() ~ delete _;


	internal static FantyEngine.RoomInstance GetCurrentRoom()
	{
		return Application.Instance.[Friend]CurrentRoom;
	}

	internal static FantyEngine.GameObject GetCurrentGameObject()
	{
		return *Application.Instance.[Friend]CurrentGameObject;
	}
}