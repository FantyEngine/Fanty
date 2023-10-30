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

	public static void DrawSprite(String assetName, int subimg, float x, float y)
	{
		var spriteAsset = AssetsManager.Sprites[assetName];
		RaylibBeef.Raylib.DrawTexturePro(AssetsManager.MainTexturePage,
			.(spriteAsset.Frames[subimg].TexturePageCoordinates.x, spriteAsset.Frames[subimg].TexturePageCoordinates.y, spriteAsset.Size.x, spriteAsset.Size.y),
			.(x, y, spriteAsset.Size.x, spriteAsset.Size.y),
			.(0, 0),
			0,
			Color.white);
	}
}