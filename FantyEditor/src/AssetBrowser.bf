using System;
using System.IO;
using ImGui;

namespace FantyEditor;

public static class AssetBrowser
{
	public static void Gui()
	{
		ImGui.PushStyleVar(ImGui.StyleVar.WindowPadding, .(0, 0));
		if (ImGui.Begin("Asset Browser", null))
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
		ImGui.End();
		ImGui.PopStyleVar();
	}
}