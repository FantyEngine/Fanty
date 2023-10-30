using FantyEngine;
using System;

namespace Sandbox;

public class TestObject : GameObject
{
	private float hsp = 0.0f;
	private float vsp = 0.0f;
	private float grv = 0.1f;
	private float walkSpd = 4.0f;

	private bool onGround = false;
	private bool wasOnGround = false;

	private float coyoteTime = 0.13f;
	private float coyoteTimeCounter = 0.0f;

	private bool keyLeft, keyRight, keyJump = false, keyJumpHeld = false;
	private bool enableJump = false;

	private float timeSinceJumpKeyPressed = 0.0f;

	public override void Create()
	{
		SpriteIndex = new $"sSolid";

		x = 32;
		y = 96;
	}

	public override void Step()
	{
		keyLeft = Fanty.IsKeyDown(.LeftArrow);
		keyRight = Fanty.IsKeyDown(.RightArrow);
		keyJump = Fanty.IsKeyPressed(.Space);
		keyJumpHeld = Fanty.IsKeyDown(.Space);

		onGround = (Fanty.PlaceMeeting<Wall>(x, y + 1));

		let move = (int)keyRight - (int)keyLeft;

		hsp = move * (onGround ? walkSpd : walkSpd);
		vsp += grv;

		if (!onGround)
		{
			coyoteTimeCounter -= 1.0f / GameOptions.TargetFixedStep;
		}
		else
		{
			coyoteTimeCounter = coyoteTime;
		}

		let jumpSpd = -4.0f;
		if (coyoteTimeCounter > 0.0f && keyJump)
		{
			vsp = jumpSpd;
			coyoteTimeCounter = 0.0f;
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
	}

	public override void FixedStep()
	{
		
	}

	public override void Draw()
	{
		base.Draw();
	}
}