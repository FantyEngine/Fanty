using System;
using System.IO;
using System.Collections;
using ImGui;
using FantyEngine;

namespace FantyEditor;

public static class AssetBrowser
{
	private static String m_SelectedGameObject ~ if (_ != null) delete _;

	private static Dictionary<String, RaylibBeef.Texture2D> m_Textures = new .() ~ DeleteDictionaryAndKeys!(_);

	private static String m_NodeToRename = null ~ if (_ != null) delete _;
	private static String m_NewNodeName = null ~ if (_ != null) delete _;

	public static void Init()
	{
		void LoadTexture(String name)
		{
			m_Textures.Add(new .(name), RaylibBeef.Raylib.LoadTexture(scope $"assets/{name}.png"));
		}

		LoadTexture("folder");
		LoadTexture("folderopen");
	}

	public static void Deinit()
	{
		for (var texture in m_Textures)
		{
			RaylibBeef.Raylib.UnloadTexture(texture.value);
		}
	}

	// Replace with asset in the future?
	public static GameObjectAsset GetSelectedGameObject()
	{
		if (!String.IsNullOrEmpty(m_SelectedGameObject))
		{
			return AssetsManager.GameObjectAssets[m_SelectedGameObject];
		}
		return null;
	}

	public static void Gui()
	{
		ImGui.PushStyleVar(ImGui.StyleVar.WindowPadding, .(0, 0));
		if (ImGui.Begin("Asset Browser", null))
		{
			let directoryNodeFlags = ImGui.TreeNodeFlags.None | .FramePadding;
			var fileNodeFlags = ImGui.TreeNodeFlags.None | .FramePadding | .Leaf;

			bool BeginAssetGroup(String name)
			{
				let xref = ImGui.GetCursorPosX();
				var v = ImGui.TreeNodeEx(scope $"        {name}", directoryNodeFlags);

				ImGui.SameLine();
				ImGui.SetCursorPosX(xref + 29);
				ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 7);
				ImGui.Image((ImGui.TextureID)(int)m_Textures["folder"].id, .(16, 12));

				return v;
			}

			ImGui.PushStyleVar(ImGui.StyleVar.FramePadding, .(8, 6));
			{
				if (BeginAssetGroup("Sprites"))
				{
					for (var sprite in AssetsManager.Sprites)
					{
						ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 12);

						var coordinates = sprite.value.Frames[0].TexturePageCoordinates;
						var normalizedTextureRegion =
							Rectangle(
							coordinates.x / (float)AssetsManager.MainTexturePage.width, coordinates.y / (float)AssetsManager.MainTexturePage.height,
							sprite.value.Size.x / (float)AssetsManager.MainTexturePage.width, sprite.value.Size.y / (float)AssetsManager.MainTexturePage.height
							);

						let xref = ImGui.GetCursorPosX();
						ImGui.TreeNodeEx(scope $"{sprite.key}", .Leaf | .FramePadding | .SpanFullWidth);
						{
							if (ImGui.IsItemClicked() && m_NodeToRename != sprite.key)
							{
								delete m_NodeToRename;
								delete m_NewNodeName;
								m_NodeToRename = new .(sprite.key);
								m_NewNodeName = new .(sprite.key);
							}

							ImGui.SameLine();
							ImGui.SetCursorPosX(xref);
							ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 1);
							/*ImGui.Image
								((ImGui.TextureID)(int)AssetsManager.MainTexturePage.id, .(24, 24),
								.(normalizedTextureRegion.x, normalizedTextureRegion.y),
								.(normalizedTextureRegion.x + normalizedTextureRegion.width, normalizedTextureRegion.y + normalizedTextureRegion.height));*/
							ImGui.Dummy(.(24, 24));

							if (m_NodeToRename != null)
							{
								if ( m_NodeToRename == sprite.key)
								{
									ImGui.SameLine();
									ImGui.SetCursorPosX(xref + 22);

									if (ImGui.IsWindowFocused(ImGui.FocusedFlags.RootAndChildWindows) && !ImGui.IsAnyItemActive() && !ImGui.IsMouseClicked(0))
										ImGui.SetKeyboardFocusHere(0);

									if (ImGui.InputText("###rename", m_NewNodeName, sizeof(uint64), .EnterReturnsTrue | .AlwaysOverwrite))
									{
										let newName = m_NewNodeName;
										AssetsManager.RenameSpriteAsset(m_NodeToRename, newName);

										let folders = Directory.EnumerateDirectories(scope $"{AssetsManager.AssetsPath}/sprites");
										for (var folder in folders)
										{
											let directoryPath = folder.GetFilePath(.. scope .());
											let name = folder.GetFileName(.. scope .());

											if (name == m_NodeToRename)
											{
												let newPath = scope $"{AssetsManager.AssetsPath}/sprites/{newName}";
												Directory.Move(directoryPath, newPath);
												break;
											}
										}

										DeleteAndNullify!(m_NodeToRename);
										DeleteAndNullify!(m_NewNodeName);
									}
								}

							}
						}
						ImGui.TreePop();
					}
					ImGui.TreePop();

				}
				if (BeginAssetGroup("Game Objects"))
				{
					for (var object in AssetsManager.GameObjectAssets)
					{
						var flags = fileNodeFlags;
						if (m_SelectedGameObject == object.key)
							flags |= .Selected;
						ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 12);

						let xref = ImGui.GetCursorPosX();
						ImGui.TreeNodeEx(object.key, flags);
						{
							if (ImGui.IsItemClicked())
							{
								if (m_SelectedGameObject != null)
									delete m_SelectedGameObject;
								m_SelectedGameObject = new .(object.key);
							}

							if (object.value.HasSprite())
							{
								var sprite = object.value.SpriteAsset;
								var coordinates = sprite.Frames[0].TexturePageCoordinates;
								var normalizedTextureRegion =
									Rectangle(
									coordinates.x / (float)AssetsManager.MainTexturePage.width, coordinates.y / (float)AssetsManager.MainTexturePage.height,
									sprite.Size.x / (float)AssetsManager.MainTexturePage.width, sprite.Size.y / (float)AssetsManager.MainTexturePage.height
									);

								ImGui.SameLine();
								ImGui.SetCursorPosX(xref);
								ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 1);
								ImGui.Image
									((ImGui.TextureID)(int)AssetsManager.MainTexturePage.id, .(24, 24),
									.(normalizedTextureRegion.x, normalizedTextureRegion.y),
									.(normalizedTextureRegion.x + normalizedTextureRegion.width, normalizedTextureRegion.y + normalizedTextureRegion.height));
							}
						}
						ImGui.TreePop();
					}
					ImGui.TreePop();
				}
				if (BeginAssetGroup("Fonts"))
				{
					// for (var room in AssetsManager.Rooms)
					// {
						// ImGui.TreeNodeEx(room.key, fileNodeFlags);
						// ImGui.TreePop();
					// }
					ImGui.TreePop();
				}
				if (BeginAssetGroup("Sounds"))
				{
					// for (var room in AssetsManager.Rooms)
					// {
						// ImGui.TreeNodeEx(room.key, fileNodeFlags);
						// ImGui.TreePop();
					// }
					ImGui.TreePop();
				}
				if (BeginAssetGroup("Rooms"))
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

			ImGui.PushStyleVar(ImGui.StyleVar.WindowPadding, .(6, 6));
			if (ImGui.BeginPopupContextWindow())
			{
				if (ImGui.Selectable("Add Sprite"))
				{
				}
				ImGui.Separator();
				ImGui.Selectable("Collapse");
				ImGui.Selectable("Rename", false, .Disabled);
				ImGui.Selectable("Delete", false, .Disabled);
				ImGui.Selectable("Open in File Explorer");
				ImGui.EndPopup();
			}
			ImGui.PopStyleVar();
		}
		ImGui.End();
		ImGui.PopStyleVar();
	}

	private static void OldDrawing()
	{
		// let allFolders = Directory.EnumerateDirectories(MainEditor.AssetsPath);
		let allFiles = Directory.EnumerateFiles(AssetsManager.AssetsPath);
		let allDirectories = Directory.EnumerateDirectories(AssetsManager.AssetsPath);

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