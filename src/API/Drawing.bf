using System;

namespace FantyEngine;

extension Fanty
{
	public static void DrawClear(Color color)
	{
		RaylibBeef.Raylib.ClearBackground(color);
	}

	public static void DrawRectangle(float x1, float y1, float x2, float y2, bool filled = true)
	{
		DrawRectangleColor(x1, y1, x2, y2, Color.white, filled);
	}

	public static void DrawRectangleColor(float x1, float y1, float x2, float y2, Color color, bool filled = true)
	{
		if (filled)
			RaylibBeef.Raylib.DrawRectangleRec(.(x1, y1, x2 - x1, y2 - y1), color);
		else
			RaylibBeef.Raylib.DrawRectangleLinesEx(.(x1, y1, x2 - x1, y2 - y1), 1, color);
	}

	public static void DrawSprite(String assetName, int subimg, float x, float y, float xscale, float yscale, float rot, Color color = Color.white)
	{
		var spriteAsset = AssetsManager.Sprites[assetName];

		float sourceX = spriteAsset.Frames[subimg].TexturePageCoordinates.x;
		float sourceY = spriteAsset.Frames[subimg].TexturePageCoordinates.y;
		float sourceSizeX = spriteAsset.Size.x;
		float sourceSizeY = spriteAsset.Size.y;

		if (xscale < 0) { sourceSizeX *= -1; }
		if (yscale < 0) { sourceSizeY *= -1; }

		RaylibBeef.Raylib.DrawTexturePro(AssetsManager.MainTexturePage,
			.(sourceX, sourceY, sourceSizeX, sourceSizeY),
			.(x, y, spriteAsset.Size.x * Math.Abs(xscale), spriteAsset.Size.y * Math.Abs(yscale)),
			.(0, 0),
			rot,
			color);
	}
}