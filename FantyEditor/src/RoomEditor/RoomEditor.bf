using System;
using ImGui;
using Bon;
using System.IO;
using System.Collections;

namespace FantyEditor.RoomEditor;

public static class RoomEditor
{
	private static FantyEngine.RoomAsset m_CurrentRoom = new .() ~ if (_ != null) delete _;

	private static Guid m_SelectedID;
	private static SelectedType m_SelectedType;

	private static Selection m_Selection = new .() ~ delete _;
	public static List<GameObjectMarker> SelectedGameObjects => m_Selection.SelectedGameObjects;

	private static Dictionary<Guid, GameObjectMarker> GameObjectMarkers = new .() ~ DeleteDictionaryAndValues!(_);

	private static bool m_ResizingGameObjects = false;

	private enum SelectedType
	{
		Layer = 0,
		GameObject
	}

	private static RaylibBeef.RenderTexture2D m_EditorTexture;
	private static ImGui.Vec2 m_LastViewportSize;
	private static RaylibBeef.Camera2D m_EditorCamera = .(.(0, 0), .(0, 0), 0, 1);
	private static bool m_PannedInWindow = false;

	private static FantyEngine.Vector2Int m_GridSize = .(32, 32);
	private static bool m_GridEnabled = true;

	private static void Save()
	{
		Bon.SerializeIntoFile(m_CurrentRoom, scope $"{FantyEngine.AssetsManager.AssetsPath}/rooms/testroom.room");
	}

	public static void Init()
	{
		m_EditorTexture = RaylibBeef.Raylib.LoadRenderTexture(1280, 720);

		Bon.DeserializeFromFile(ref m_CurrentRoom, scope $"{FantyEngine.AssetsManager.AssetsPath}/rooms/testroom.room");

		/*
		var bg = new FantyEngine.RoomAsset.BackgroundLayer() { Color = .("#00a6ff") };
		bg.SetName("Background Layer");
		m_CurrentRoom.BackgroundLayers.Add(bg);

		var instanceLayer = new FantyEngine.RoomAsset.InstanceLayer();
		instanceLayer.SetName("Instances");
		m_CurrentRoom.InstanceLayers.Add(instanceLayer);
		*/
		/*
		var room = scope FantyEngine.RoomAsset();
		room.Width = 1280;
		room.Height = 720;
		room.Viewport0.Visible = true;
		room.Viewport0.CameraProperties.width = 1280;
		room.Viewport0.CameraProperties.height = 720;
		room.Viewport0.ViewportProperties.width = 1280;
		room.Viewport0.ViewportProperties.height = 720;

		

		var instance = new FantyEngine.GameObjectInstance();
		instance.[Friend]m_GameObjectAsset = &FantyEngine.AssetsManager.GameObjectAssets["oWall"];

		instanceLayer.GameObjects.Add(Guid.Create(), instance);
		*/

		for (var layer in m_CurrentRoom.InstanceLayers)
		{
			for (var gameobject in layer.GameObjects)
			{
				let id = Guid.Create();
				var marker = new GameObjectMarker(ref gameobject, id);
				GameObjectMarkers.Add(id, marker);
			}
		}
	}

	public static void Deinit()
	{
		RaylibBeef.Raylib.UnloadRenderTexture(m_EditorTexture);
	}

	public static void Gui()
	{
		ImGui.PushStyleVar(.WindowPadding, .(1, 0));
		if (ImGui.Begin("Room Editor", null))
		{
			if (ImGui.BeginChild("Toolbar", .(0, 25)))
			{
				ImGui.SetCursorPosX(6);
				ImGui.SetCursorPosY(5);
				ImGui.Text("Snap:");

				ImGui.SameLine();

				int32 gridX = (int32)m_GridSize.x;
				int32 gridY = (int32)m_GridSize.y;
				ImGui.SetNextItemWidth(32);
				if (ImGui.DragInt("###ROOMEDITOR_SNAPX", &gridX, 1, 8, 256))
					m_GridSize.x = gridX;
				ImGui.SameLine();
				ImGui.Text("/");
				ImGui.SameLine();
				ImGui.SetNextItemWidth(32);
				if (ImGui.DragInt("###ROOMEDITOR_SNAPY", &gridY, 1, 8, 256))
					m_GridSize.y = gridY;
				ImGui.SameLine();
				ImGui.Checkbox("###ROOMEDITOR_SNAP_ENABLED", &m_GridEnabled);

				ImGui.EndChild();
			}
			if (ImGui.BeginChild("Graphic"))
			{
				let contentSize = ImGui.GetContentRegionAvail();
				var currentRoom = m_CurrentRoom;

				let editorWindowScreenPos = ImGui.Vec2(ImGui.GetCursorScreenPos().x, ImGui.GetCursorScreenPos().y);
				let mousePos = RaylibBeef.Vector2(RaylibBeef.Raylib.GetMousePosition().x - editorWindowScreenPos.x, RaylibBeef.Raylib.GetMousePosition().y - editorWindowScreenPos.y); // Weird y offset
				let mouseWorldPos = RaylibBeef.Raylib.GetScreenToWorld2D(
				    mousePos, m_EditorCamera);
				let mouseInWindow = ImGui.IsWindowHovered();

				if (RaylibBeef.Raylib.IsMouseButtonDown(2))
				{
				    if (mouseInWindow)
				    {
				        m_PannedInWindow = true;
				    }
				}
				if (RaylibBeef.Raylib.IsMouseButtonReleased(2))
				    m_PannedInWindow = false;


				if (m_PannedInWindow)
				{
				    var delta = RaylibBeef.Raylib.GetMouseDelta();
				    delta = RaylibBeef.Raymath.Vector2Scale(delta, -1.0f / m_EditorCamera.zoom);

				    m_EditorCamera.target = RaylibBeef.Raymath.Vector2Add(m_EditorCamera.target, delta);
				}

				var wheel = RaylibBeef.Raylib.GetMouseWheelMove();

				if (wheel != 0 && mouseInWindow)
				{
				    m_EditorCamera.offset = mousePos;

				    m_EditorCamera.target = mouseWorldPos;

					var goalZoom = m_EditorCamera.zoom;
				    if (wheel > 0)
				    {
				        goalZoom += wheel * (m_EditorCamera.zoom * 0.25f);
				    }
				    else
				    {
				        goalZoom += wheel * (m_EditorCamera.zoom * 0.2f);
				    }

				    if (goalZoom < 0.25f)
				        goalZoom = 0.25f;

					m_EditorCamera.zoom = goalZoom;
				    // camera.zoom = 0;
				}

				if (contentSize != m_LastViewportSize)
				{
					RaylibBeef.Raylib.UnloadRenderTexture(m_EditorTexture);
					m_EditorTexture = RaylibBeef.Raylib.LoadRenderTexture((int32)contentSize.x, (int32)contentSize.y);
				}

				RaylibBeef.Raylib.BeginTextureMode(m_EditorTexture);
				RaylibBeef.Raylib.ClearBackground(.(51, 51, 51, 255));

				for (var x < ((int)contentSize.x / 32) + 1)
				{
					for (var y < ((int)contentSize.y / 32) + 1)
					{
						if ((x - y) % 2 == 0)
							RaylibBeef.Raylib.DrawRectangleRec(.(x * 32, y * 32, 32, 32), .(58, 58, 58, 255));
					}
				}

				RaylibBeef.Raylib.BeginMode2D(m_EditorCamera);

				var clipPos = RaylibBeef.Raylib.GetWorldToScreen2D(.(0, 0), m_EditorCamera);
				RaylibBeef.Raylib.BeginScissorMode(
					(int32)clipPos.x, (int32)clipPos.y,
					(int32)(currentRoom.Width * m_EditorCamera.zoom), (int32)(currentRoom.Height * m_EditorCamera.zoom));
				for (var layer in currentRoom.BackgroundLayers)
				{
					let backgroundLayer = layer;

					if (backgroundLayer.HasSprite())
					{
						/*
						var countX = 1;
						var countY = 1;
						var asset = AssetsManager.Sprites[backgroundLayer.Sprite];

						if (backgroundLayer.HorizontalTile)
							countX = (currentRoom.Width / asset.Size.x) + 1;
						if (backgroundLayer.VerticalTile)
							countY = (currentRoom.Height / asset.Size.y) + 1;

						for (var x < countX)
							for (var y < countY)
								Fanty.DrawSpriteExt(
									backgroundLayer.Sprite,
									0,
									.(
									((x * asset.Size.x) + backgroundLayer.Position.x) - (Mathf.Round2Nearest(backgroundLayer.Position.x, asset.Size.x)),
									backgroundLayer.Position.y
									),
									.zero,
									.one,
									0
									);
						*/
					}
					else
					{
						RaylibBeef.Raylib.DrawRectangle(0, 0, (int32)currentRoom.Width, (int32)currentRoom.Height, layer.Color);
					}
				}
				RaylibBeef.Raylib.EndScissorMode();

				for (let marker in GameObjectMarkers.Values)
				{
					marker.Update(.(mousePos.x, mousePos.y), .(mouseWorldPos.x, mouseWorldPos.y), mouseInWindow, m_GridEnabled);
					marker.Draw(m_EditorCamera);
				}

				let cameraViewX = FantyEngine.Mathf.CeilToInt(m_LastViewportSize.x / m_EditorCamera.zoom) + 1;
				let cameraViewY = FantyEngine.Mathf.CeilToInt(m_LastViewportSize.y / m_EditorCamera.zoom) + 1;
				var gridX = cameraViewX;
				var gridY = cameraViewY;

				var pixelXOffset = (int)(m_EditorCamera.target.x - (m_EditorCamera.offset.x / m_EditorCamera.zoom));
				pixelXOffset = FantyEngine.Mathf.Clamp(pixelXOffset, 0, currentRoom.Width);

				var pixelYOffset = (int)(m_EditorCamera.target.y - (m_EditorCamera.offset.y / m_EditorCamera.zoom));
				pixelYOffset = FantyEngine.Mathf.Clamp(pixelYOffset, 0, currentRoom.Height);

				if (m_GridEnabled)
				{
					for (var x < gridX + 1)
					{
						let xpos = (int32)((x * m_GridSize.x));
						if (xpos > currentRoom.Width)
							break;

						RaylibBeef.Raylib.DrawLine(xpos, 0, xpos, (int32)currentRoom.Height, .(255, 255, 255, 175));

					}
					for (var y < gridY + 1)
					{
						let ypos = (int32)((y * m_GridSize.y));
						if (ypos > currentRoom.Height)
							break;
						RaylibBeef.Raylib.DrawLine(0, ypos, (int32)currentRoom.Width, ypos, .(255, 255, 255, 175));
					}
				}
				
				// Cursor stuff
				{
					let cursorWorldPos = RaylibBeef.Raylib.GetScreenToWorld2D(
						.(RaylibBeef.Raylib.GetMousePosition().x - ImGui.GetWindowPos().x,
						RaylibBeef.Raylib.GetMousePosition().y - ImGui.GetWindowPos().y), m_EditorCamera);
					let cursorGridPos = FantyEngine.Vector2(
						FantyEngine.Mathf.Round2Nearest(cursorWorldPos.x - ((cursorWorldPos.x < 0) ? m_GridSize.x : 0), m_GridSize.x),
						FantyEngine.Mathf.Round2Nearest(cursorWorldPos.y - ((cursorWorldPos.y < 0) ? m_GridSize.y : 0), m_GridSize.y));

					var instanceLayer = (FantyEngine.RoomAsset.InstanceLayer)m_CurrentRoom.GetLayerByID(m_SelectedID);
					let mouseInViewport = ImGui.IsMouseHoveringRect(ImGui.GetWindowPos(), .(ImGui.GetWindowPos().x + ImGui.GetWindowWidth(), ImGui.GetWindowPos().y + ImGui.GetWindowHeight()));

					if (mouseInViewport)
					{
						if (RaylibBeef.Raylib.IsKeyDown((int32)RaylibBeef.KeyboardKey.KEY_LEFT_ALT))
						{
							if (AssetBrowser.GetSelectedGameObject() != null)
							{
								if (AssetBrowser.GetSelectedGameObject().HasSprite())
								{
									FantyEngine.Fanty.DrawSpriteExt(
										AssetBrowser.GetSelectedGameObject().SpriteAssetName,
										0,
										.(cursorGridPos.x, cursorGridPos.y),
										.(AssetBrowser.GetSelectedGameObject().GetSpriteAsset().Origin.x, AssetBrowser.GetSelectedGameObject().GetSpriteAsset().Origin.y),
										.(1, 1), 0);
								}


								if (RaylibBeef.Raylib.IsMouseButtonPressed((int32)RaylibBeef.MouseButton.MOUSE_BUTTON_LEFT))
								{
									if (instanceLayer != null)
									{
										var goinstance = new FantyEngine.GameObjectInstance();
										goinstance.SetAssetName(AssetBrowser.GetSelectedGameObject().Name);
										goinstance.x = cursorGridPos.x;
										goinstance.y = cursorGridPos.y;

										instanceLayer.GameObjects.Add(goinstance);
										let id = Guid.Create();
										var marker = new GameObjectMarker(ref goinstance, id);
										GameObjectMarkers.Add(id, marker);
										m_Selection.ClickSelect(marker);
									}
								}
							}
						}
						else
						{
						}
					}
				}

				RaylibBeef.Raylib.EndMode2D();

				let rectScreenPos = RaylibBeef.Raylib.GetWorldToScreen2D(.(0, 0), m_EditorCamera);
				let rectScreenPosMax = RaylibBeef.Raylib.GetWorldToScreen2D(.(currentRoom.Width, currentRoom.Height), m_EditorCamera);
				DrawRectangle(.(rectScreenPos.x, rectScreenPos.y, rectScreenPosMax.x - rectScreenPos.x, rectScreenPosMax.y - rectScreenPos.y), FantyEngine.Color.white, 2);

				for (let marker in GameObjectMarkers.Values)
				{
					marker.DrawGui(m_EditorCamera, .(mousePos.x, mousePos.y), .(mouseWorldPos.x, mouseWorldPos.y));
				}

				for (let marker in GameObjectMarkers.Values)
				{
					marker.LateUpdate();
				}

				RaylibBeef.Raylib.EndTextureMode();

				ImGui.Image((ImGui.TextureID)(int)m_EditorTexture.texture.id,
					contentSize,
					.(0, 1),
					.(1, 0));

				m_LastViewportSize = contentSize;
			}
			ImGui.EndChild();
			
			if (ImGui.Begin("Hierarchy", null))
			{
				if (ImGui.Button("Save"))
					Save();

				ImGui.PushStyleVar(ImGui.StyleVar.FramePadding, .(8, 6));
				for (var instanceLayer in m_CurrentRoom.InstanceLayers)
				{
					var layerflags = ImGui.TreeNodeFlags.FramePadding | .SpanFullWidth;
					if (instanceLayer.GUID == m_SelectedID)
						layerflags |= .Selected;
					var opened = ImGui.TreeNodeEx(scope $"{instanceLayer.Name} ###{instanceLayer.GUID}", layerflags);

					if (ImGui.IsItemClicked())
					{
						m_SelectedID = instanceLayer.GUID;
						m_SelectedType = .Layer;
					}

					if (opened)
					{
						for (var gameobject in instanceLayer.GameObjects)
						{
							var name = gameobject.GameObjectAsset.Name;
							var flags = ImGui.TreeNodeFlags.Leaf | .SpanFullWidth;
							// if (gameobject.GameObjectID == m_SelectedID)
								// flags |= .Selected;
							ImGui.TreeNodeEx(name, flags);

							if (ImGui.IsItemClicked())
							{
								// m_SelectedLayer = gameobject.key;
								// selectedType = .GameObject;
							}

							ImGui.TreePop();
						}

						ImGui.TreePop();
					}
				}

				for (var backgroundLayer in m_CurrentRoom.BackgroundLayers)
				{
					var flags = ImGui.TreeNodeFlags.Leaf | .FramePadding | .SpanFullWidth;
					// if (backgroundLayer.key == selectedID)
						// flags |= .Selected;
					ImGui.TreeNodeEx(scope $"{backgroundLayer.Name} ###{backgroundLayer.GUID}", flags);

					if (ImGui.IsItemClicked())
					{
						// selectedID = backgroundLayer.key;
						// selectedType = .Layer;
					}

					ImGui.TreePop();
				}
				ImGui.PopStyleVar();
			}
			ImGui.End();
		}
		ImGui.End();
		ImGui.PopStyleVar();
	}

	public static void DrawRectangle(FantyEngine.Rectangle rec, FantyEngine.Color color, float lineWidth = 1f)
	{
		let rectScreenPos = FantyEngine.Vector2(rec.x, rec.y);
		let rectScreenPosMax = FantyEngine.Vector2(rec.x + rec.width, rec.y + rec.height);

		if (lineWidth == 1)
		{
			RaylibBeef.Raylib.DrawLine((int32)rectScreenPos.x, (int32)rectScreenPos.y, (int32)rectScreenPosMax.x, (int32)rectScreenPos.y, color); 		 // top
			RaylibBeef.Raylib.DrawLine((int32)rectScreenPos.x, (int32)rectScreenPos.y, (int32)rectScreenPos.x, (int32)rectScreenPosMax.y, color); 		 // left
			RaylibBeef.Raylib.DrawLine((int32)rectScreenPos.x, (int32)rectScreenPosMax.y, (int32)rectScreenPosMax.x, (int32)rectScreenPosMax.y, color); // bottom
			RaylibBeef.Raylib.DrawLine((int32)rectScreenPosMax.x, (int32)rectScreenPos.y, (int32)rectScreenPosMax.x, (int32)rectScreenPosMax.y, color); // right

			return;
		}
		RaylibBeef.Raylib.DrawLineEx(.(rectScreenPos.x, rectScreenPos.y), .(rectScreenPosMax.x, rectScreenPos.y), lineWidth, color); 		 // top
		RaylibBeef.Raylib.DrawLineEx(.(rectScreenPos.x, rectScreenPos.y), .(rectScreenPos.x, rectScreenPosMax.y), lineWidth, color); 		 // left
		RaylibBeef.Raylib.DrawLineEx(.(rectScreenPos.x, rectScreenPosMax.y), .(rectScreenPosMax.x, rectScreenPosMax.y), lineWidth, color); // bottom
		RaylibBeef.Raylib.DrawLineEx(.(rectScreenPosMax.x, rectScreenPos.y), .(rectScreenPosMax.x, rectScreenPosMax.y), lineWidth, color); // right
	}

	public static void RemoveGameObject(GameObjectMarker marker)
	{
		for (var layer in m_CurrentRoom.InstanceLayers)
		{
			for (var gameobject in layer.GameObjects)
			{
				if (gameobject.GameObjectID == marker.GameObject.GameObjectID)
				{
					delete marker.GameObject;
					layer.GameObjects.Remove(gameobject);
					m_Selection.Deselect(marker);
					GameObjectMarkers.Remove(marker.EditorID);
					delete marker;
					return;
				}
			}
		}
	}
}