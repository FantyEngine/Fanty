using FantyEngine;

namespace Sandbox;

public class Bullet : GameObject
{
	public float speed;
	public float direction;

	public override void CreateEvent()
	{
		SpriteIndex = "sBullet";
	}

	public override void StepEvent()
	{
		x += Fanty.LengthDirX(speed, direction);
		y += Fanty.LengthDirY(speed, direction);

		ImageAngle = direction;
	}

	public override void PostDrawEvent()
	{
		if (Fanty.PlaceMeeting<Wall>(x, y))
			Destroy(this);
	}

	public override void AnimationEndEvent()
	{
		ImageSpeed = 0;
		ImageIndex = 1;
	}
}