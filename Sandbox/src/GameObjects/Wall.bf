using FantyEngine;

namespace Sandbox;

public class Wall : GameObject
{
	public override void CreateEvent()
	{
		SpriteIndex = "sSolidWall";
	}
}