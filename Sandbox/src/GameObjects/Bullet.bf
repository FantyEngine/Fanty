using FantyEngine;
using static FantyEngine.Fanty;

namespace Sandbox;

[RegisterGameObject("oBullet")]
public class Bullet : GameObject
{
	public static float Tesss;

	public float speed = 10.0f;
	public float direction;
	public float asdsasdasdsd = 12.0f;

	public override void CreateEvent()
	{
		SpriteIndex = "sBullet";
	}

	public override void StepEvent()
	{
		x += LengthDirX(speed, direction);
		y += LengthDirY(speed, direction);

		ImageAngle = direction;
	}

	public override void PostDrawEvent()
	{
		if (PlaceMeeting<Wall>(x, y))
			Destroy(this);
	}

	public override void OutsideRoomEvent()
	{
		Destroy(this);
	}

	public override void AnimationEndEvent()
	{
		ImageSpeed = 0;
		ImageIndex = 1;
	}
}