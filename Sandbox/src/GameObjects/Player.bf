using FantyEngine;
using System;

namespace Sandbox;

public class Player : GameObject
{
	public static Player Instance { get; private set; }

	public float gunKickX;
	public float gunKickY;

	private float hsp = 0.0f;
	private float vsp = 0.0f;
	private float grv = 0.3f;
	private float walkSpd = 4.0f;

	private bool onGround = false;
	private bool wasOnGround = false;

	private float canJump = 0.0f;

	private bool keyLeft, keyRight, keyJump = false, keyJumpHeld = false;
	private bool enableJump = false;

	private float timeSinceJumpKeyPressed = 0.0f;

	public override void CreateEvent()
	{
		Instance = this;

		SpriteIndex = "sPlayer";
		CollisionMaskSameAsSprite = false;
		CollisionMaskAsset = new $"sPlayer";

		x = 288;
		y = 32;
	}

	public override void StepEvent()
	{
		keyLeft = Fanty.IsKeyDown(.LeftArrow) || Fanty.IsKeyDown(.A);
		keyRight = Fanty.IsKeyDown(.RightArrow) || Fanty.IsKeyDown(.D);
		keyJump = Fanty.IsKeyPressed(.Space);
		keyJumpHeld = Fanty.IsKeyDown(.Space);

		onGround = (Fanty.PlaceMeeting<Wall>(x, y + 1));

		let move = (int)keyRight - (int)keyLeft;

		hsp = (move * walkSpd) + gunKickX;
		gunKickX = 0;
		vsp += grv + gunKickY;
		gunKickY = 0;

		let jumpSpd = -7.0f;
		canJump -= 1;
		if (canJump > 0 && keyJump)
		{
			vsp = -7.0f;
			canJump = 0.0f;
		}
		if (vsp < 0 && !keyJumpHeld)
		{
			vsp = Math.Max(vsp, jumpSpd * 0.5f);
		}

		// Collision
		if (Fanty.PlaceMeeting<Wall>(x + hsp, y))
		{
			while (!Fanty.PlaceMeeting<Wall>(x + Math.Sign(hsp), y))
			{
				x += Math.Sign(hsp);
			}
			hsp = 0;
		}

		if (Fanty.PlaceMeeting<Wall>(x, y + vsp))
		{
			while (!Fanty.PlaceMeeting<Wall>(x, y + Math.Sign(vsp)))
			{
				y += Math.Sign(vsp);
			}
			vsp = 0;
		}

		x += hsp;
		y += vsp;

		wasOnGround = onGround;

		// Animation
		var aimSide = Mathf.Sign(Fanty.MouseX - x);
		if (aimSide != 0) ImageXScale = aimSide;

		if (!Fanty.PlaceMeeting<Wall>(x, y + 1))
		{
			SpriteIndex = "sPlayerA";
			ImageSpeed = 0;
			if (Math.Sign(vsp) > 0) ImageIndex = 1; else ImageIndex = 0;
		}
		else
		{
			canJump = 10.0f;
			ImageSpeed = 1;
			if (hsp == 0)
			{
				SpriteIndex = "sPlayer";
			}
			else
			{
				if (aimSide != Math.Sign(hsp))
					SpriteIndex = "sPlayerRB";
				else
					SpriteIndex = "sPlayerR";
			}
		}
	}

	public override void DrawEvent()
	{
		base.DrawEvent();

	}
}