using FantyEngine;

namespace Sandbox;

public class oCamera : GameObject
{
	public static oCamera Instance { get; private set; }

	private Camera cam;
 	private GameObject follow;
	private float viewWHalf;
	private float viewHHalf;
	private float xTo;
	private float yTo;

	private float shakeLength = 0.0f;
	private float shakeMagnitude = 6.0f;
	private float shakeRemain = 6.0f;
	private float buff = 32.0f;

	public override void CreateEvent()
	{
		Instance = this;

		cam = Fanty.ViewCamera(0);
		follow = Player.Instance;
		viewWHalf = Fanty.CameraGetViewWidth(cam) * 0.5f;
		viewHHalf = Fanty.CameraGetViewHeight(cam) * 0.5f;
		xTo = x;
		yTo = y;
	}

	public override void StepEvent()
	{
		if (follow != null)
		{
			xTo = follow.x;
			yTo = follow.y;
		}

		x += (xTo - x) / 25;
		y += (yTo - y) / 25;

		x = Mathf.Clamp(x, viewWHalf + buff, Fanty.RoomWidth - viewWHalf - buff);
		y = Mathf.Clamp(y, viewHHalf + buff, Fanty.RoomHeight - viewHHalf - buff);

		// Screen shake
		x += Fanty.RandomRange(-shakeRemain, shakeRemain);
		// y += Fanty.RandomRange(-shakeRemain, shakeRemain);
		shakeRemain = Mathf.Max(0, shakeRemain - ((1 / shakeLength) * shakeMagnitude));

		Fanty.CameraSetViewPos(cam, x - viewWHalf, 0);

		Fanty.LayerSetX(Program.mountainsLayer, (x / 2) - (viewWHalf));
		Fanty.LayerSetY(Program.mountainsLayer, 49);
		Fanty.LayerSetX(Program.treesLayer, (x / 4) - (viewWHalf));
		Fanty.LayerSetY(Program.treesLayer, 148);
	}

	public static void ScreenShake(float magnitude, int frames)
	{
		var cam = oCamera.Instance;

		if (magnitude > cam.shakeRemain)
		{
			cam.shakeMagnitude = magnitude;
			cam.shakeRemain = magnitude;
			cam.shakeLength = frames;
		}
	}
}