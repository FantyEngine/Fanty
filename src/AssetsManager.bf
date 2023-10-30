using System.Collections;
using System;
using System.IO;
using System.Diagnostics;
using Bon;

namespace FantyEngine;

public class AssetsManager
{
	// Temp
	public const String AssetsPath = @"D:/Fanty/Sandbox/project";

	public static Dictionary<String, Sprite> Sprites = new .() ~ DeleteDictionaryAndKeysAndValues!(_);
	public static RaylibBeef.Texture2D MainTexturePage { get; private set; } ~ if (_.id > 0) RaylibBeef.Raylib.UnloadTexture(_);

	internal static void LoadAllAssets()
	{
		gBonEnv.serializeFlags |= .Verbose;


		let spritesFolder = AssetsPath + "/sprites";
		let allFolders = Directory.EnumerateDirectories(spritesFolder);
		var texturePage = RaylibBeef.Raylib.GenImageColor(1024, 1024, Color(255, 0, 255, 0));

		var spriteIndex = 0;
		var occupiedSize = Vector2Int();
		for (var folder in allFolders)
		{
			if (folder.IsDirectory)
			{
				let directoryPath = folder.GetFilePath(.. scope .());
				var dataFile = scope String();

				if (File.ReadAllText(scope $"{directoryPath}/data.bon", dataFile) == .Ok)
				{
					Console.WriteLine(dataFile);

					var sprite = new Sprite();
					Bon.Deserialize(ref sprite, dataFile);

					for (var i < sprite.Frames.Count)
					{
						let spritePath = scope $"{directoryPath}/{i}.png";
						var src = RaylibBeef.Raylib.LoadImage(spritePath);
						RaylibBeef.Raylib.ImageDraw(&texturePage, src, .(0, 0, src.width, src.height), .(occupiedSize.x, occupiedSize.y, src.width, src.height), Color.white);

						sprite.Size = .(src.width, src.height);
						sprite.Frames[i].TexturePageCoordinates = .(occupiedSize.x, occupiedSize.y);
						occupiedSize = .(occupiedSize.x + src.width, 0);

						RaylibBeef.Raylib.UnloadImage(src);
					}

					Sprites.Add(folder.GetFileName(.. new .()), sprite);

					// Console.WriteLine(Bon.Serialize(sprite, .. scope .()));
				}
				spriteIndex++;
			}
			else
			{
				Debug.WriteLine(scope $"No files should be here! Directory: {folder.GetFileName(.. scope .())}");
			}
		}

		MainTexturePage = RaylibBeef.Raylib.LoadTextureFromImage(texturePage);
		RaylibBeef.Raylib.UnloadImage(texturePage);
	}
}