using System;
using System.IO;
using ImGui;
using FantyEngine;

namespace FantyEditor;

public static class AssetBrowser
{
	public static void Gui()
	{
		ImGui.PushStyleVar(ImGui.StyleVar.WindowPadding, .(0, 0));
		if (ImGui.Begin("Asset Browser", null))
		{
			let directoryNodeFlags = ImGui.TreeNodeFlags.None | .FramePadding | .SpanFullWidth;
			var fileNodeFlags = ImGui.TreeNodeFlags.None | .FramePadding | .SpanFullWidth | .Leaf;

			ImGui.PushStyleVar(ImGui.StyleVar.FramePadding, .(8, 6));
			{
				if (ImGui.TreeNodeEx("Sprites", directoryNodeFlags))
				{
					for (var sprite in AssetsManager.Sprites)
					{
						var coordinates = sprite.value.Frames[0].TexturePageCoordinates;
						var normalizedTextureRegion =
							Rectangle(
							coordinates.x / (float)AssetsManager.MainTexturePage.width, coordinates.y / (float)AssetsManager.MainTexturePage.height,
							sprite.value.Size.x / (float)AssetsManager.MainTexturePage.width, sprite.value.Size.y / (float)AssetsManager.MainTexturePage.height
							);
						ImGui.GetWindowDrawList().AddImage
							((ImGui.TextureID)(int)AssetsManager.MainTexturePage.id,
							.(ImGui.GetCursorScreenPos().x, ImGui.GetCursorScreenPos().y + 1),
							.(ImGui.GetCursorScreenPos().x + 24, ImGui.GetCursorScreenPos().y + 1 + 24),
							.(normalizedTextureRegion.x, normalizedTextureRegion.y),
							.(normalizedTextureRegion.x + normalizedTextureRegion.width, normalizedTextureRegion.y + normalizedTextureRegion.height));

						ImGui.TreeNodeEx(sprite.key, fileNodeFlags);
						ImGui.TreePop();
					}
					ImGui.TreePop();
				}
				if (ImGui.TreeNodeEx("Game Objects", directoryNodeFlags))
				{
					for (var object in AssetsManager.GameObjectAssets)
					{
						if (object.value.HasSprite())
						{
							var sprite = AssetsManager.Sprites[object.value.SpriteAssetName];
							var coordinates = sprite.Frames[0].TexturePageCoordinates;
							var normalizedTextureRegion =
								Rectangle(
								coordinates.x / (float)AssetsManager.MainTexturePage.width, coordinates.y / (float)AssetsManager.MainTexturePage.height,
								sprite.Size.x / (float)AssetsManager.MainTexturePage.width, sprite.Size.y / (float)AssetsManager.MainTexturePage.height
								);
							ImGui.GetWindowDrawList().AddImage
								((ImGui.TextureID)(int)AssetsManager.MainTexturePage.id,
								.(ImGui.GetCursorScreenPos().x, ImGui.GetCursorScreenPos().y + 1),
								.(ImGui.GetCursorScreenPos().x + 24, ImGui.GetCursorScreenPos().y + 1 + 24),
								.(normalizedTextureRegion.x, normalizedTextureRegion.y),
								.(normalizedTextureRegion.x + normalizedTextureRegion.width, normalizedTextureRegion.y + normalizedTextureRegion.height));
						}
						ImGui.TreeNodeEx(object.key, fileNodeFlags);
						ImGui.TreePop();
					}
					ImGui.TreePop();
				}
				if (ImGui.TreeNodeEx("Rooms", directoryNodeFlags))
				{
					for (var room in AssetsManager.Rooms)
					{
						ImGui.TreeNodeEx(room.key, fileNodeFlags);
						ImGui.TreePop();
					}
					ImGui.TreePop();
				}
			}
			ImGui.PopStyleVar();
		}
		ImGui.End();
		ImGui.PopStyleVar();
	}

	private static void OldDrawing()
	{
		// let allFolders = Directory.EnumerateDirectories(MainEditor.AssetsPath);
		let allFiles = Directory.EnumerateFiles(MainEditor.AssetsPath);
		let allDirectories = Directory.EnumerateDirectories(MainEditor.AssetsPath);

		ImGui.PushStyleVar(ImGui.StyleVar.FramePadding, .(8, 6));
		void DrawFile(String path)
		{
			let name = Path.GetFileName(path, .. scope .());
			let isDirectory = Directory.Exists(path);

			var nodeFlags = ImGui.TreeNodeFlags.None | .FramePadding | .SpanFullWidth;
			if (isDirectory)
			{
			}
			else
			{
				nodeFlags |= .Leaf;
			}

			var open = ImGui.TreeNodeEx(name, nodeFlags);

			if (open)
			{
				if (isDirectory)
				{
					for (var directory in Directory.EnumerateDirectories(path))
					{
						DrawFile(directory.GetFilePath(.. scope .()));
					}
					for (var directory in Directory.EnumerateFiles(path))
					{
						DrawFile(directory.GetFilePath(.. scope .()));
					}
				}

				ImGui.TreePop();
			}
		}

		for (var directory in allDirectories)
		{
			let path = directory.GetFilePath(.. scope .());
			DrawFile(path);
		}
		for (var file in allFiles)
		{
			let path = file.GetFilePath(.. scope .());
			DrawFile(path);
		}
		ImGui.PopStyleVar();
	}
}