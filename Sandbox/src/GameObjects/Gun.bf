using FantyEngine;

namespace Sandbox;

public class Gun : GameObject
{
	private float firingDelay = 0.0f;
	private float recoil = 0.0f;

	public override void CreateEvent()
	{
		SpriteIndex = "sGun";
	}

	public override void BeginStepEvent()
	{
		x = Player.Instance.x;
		y = Player.Instance.y + 10;

		ImageAngle = Fanty.PointDirection(x, y, Fanty.MouseX, Fanty.MouseY);

		firingDelay -= 1;
		recoil = Mathf.Max(0, recoil - 1);

		if (Fanty.IsMouseButtonDown(0) && firingDelay < 0)
		{
			recoil = 4;
			firingDelay = 5;

			var bullet = Application.Instance.AddGameObject<Bullet>(new .());
			bullet.x = x;
			bullet.y = y;
			bullet.speed = 25;
			bullet.direction = ImageAngle;
		}

		x -= Fanty.LengthDirX(recoil, ImageAngle);
		y -= Fanty.LengthDirY(recoil, ImageAngle);

		if (ImageAngle > 90 && ImageAngle < 270)
		{
			ImageYScale = -1;
		}
		else
		{
			ImageYScale = 1;
		}
	}
}