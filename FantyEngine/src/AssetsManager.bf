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

	// Replace Strings with Guids in the future.
	public static Dictionary<String, GameObjectAsset> GameObjectAssets = new .() ~ DeleteDictionaryAndKeysAndValues!(_);
	public static Dictionary<String, SpriteAsset> Sprites = new .() ~ DeleteDictionaryAndKeysAndValues!(_);
	public static Dictionary<String, RoomAsset> Rooms = new .() ~ DeleteDictionaryAndKeysAndValues!(_);

	public static RaylibBeef.Texture2D MainTexturePage { get; private set; } ~ if (_.id > 0) RaylibBeef.Raylib.UnloadTexture(_);

	public static void LoadAllAssets()
	{
		LoadAllSprites();
		LoadAllGameObjects();
	}

	private static void LoadAllGameObjects()
	{
		let objectsFolder = AssetsPath + "/objects";
		let allFiles = Directory.EnumerateFiles(objectsFolder);
		for (var file in allFiles)
		{
			var exten = scope String();
			var path = file.GetFilePath(.. scope .());
			Path.GetExtension(path, exten);
			if (exten == ".object")
			{
				var object = new FantyEngine.GameObjectAsset();
				var dataFile = scope String();

				var name = Path.GetFileNameWithoutExtension(path, .. new .());

				if (File.ReadAllText(path, dataFile) == .Ok)
				{
					Result<GameObjectAsset> Load()
					{
						Bon.Deserialize(ref object, dataFile);
						return object;
					}

					if (Load() != .Err)
					{
						object.SetSpriteAssetName(object.SpriteAssetName);
						GameObjectAssets.Add(name, object);
					}
				}
			}
		}
	}

	private static void LoadAllSprites()
	{
		if (MainTexturePage.id > 0)
		{
			RaylibBeef.Raylib.UnloadTexture(MainTexturePage);

			DeleteDictionaryAndKeysAndValues!(Sprites);
			Sprites = new .();
		}

		let spritesFolder = AssetsPath + "/sprites";
		let allFolders = Directory.EnumerateDirectories(spritesFolder);
		var texturePage = RaylibBeef.Raylib.GenImageColor(1024 * 2, 1024 * 2, Color(255, 0, 255, 0));

		var spriteIndex = 0;
		var currentPixel = Vector2Int();

		for (var folder in allFolders)
		{
			if (folder.IsDirectory)
			{
				let directoryPath = folder.GetFilePath(.. scope .());
				var dataFile = scope String();

				if (File.ReadAllText(scope $"{directoryPath}/data.bon", dataFile) == .Ok)
				{
					var sprite = new SpriteAsset();

					Result<SpriteAsset> LoadSprite()
					{
						Try!(Bon.Deserialize(ref sprite, dataFile));
						return sprite;
					}
					if (LoadSprite() != .Err)
					{
						for (var i < sprite.Frames.Count)
						{
							let spritePath = scope $"{directoryPath}/{i}.png";
							var src = RaylibBeef.Raylib.LoadImage(spritePath);

							if (currentPixel.x + src.width > texturePage.width)
							{
								currentPixel.x = 0;
								currentPixel.y += src.height;
							}

							RaylibBeef.Raylib.ImageDraw(&texturePage, src, .(0, 0, src.width, src.height), .(currentPixel.x, currentPixel.y, src.width, src.height), Color.white);

							sprite.Size = .(src.width, src.height);
							sprite.Frames[i].TexturePageCoordinates = .(currentPixel.x, currentPixel.y);

							currentPixel.x += src.width;

							RaylibBeef.Raylib.UnloadImage(src);
						}

						Sprites.Add(folder.GetFileName(.. new .()), sprite);
					}
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