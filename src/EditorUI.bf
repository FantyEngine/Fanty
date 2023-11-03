using ImGui;
using System;

namespace FantyEngine;

public static class EditorUI
{
	private static SelectedType selectedType;
	private static Guid selectedID;

	private static RaylibBeef.RenderTexture2D m_RoomEditorTexture;
	private static ImGui.Vec2 m_LastRoomEditorViewportSize;
	private static RaylibBeef.Camera2D m_RoomEditorCamera = .(.(0, 0), .(0, 0), 0, 1);
	private static bool m_RoomEditorPannedInWindow = false;

	private enum SelectedType
	{
		Layer = 0,
		GameObject
	}

	public static void Init()
	{
		m_RoomEditorTexture = RaylibBeef.Raylib.LoadRenderTexture(1280, 720);
	}

	public static void Deinit()
	{
		RaylibBeef.Raylib.UnloadRenderTexture(m_RoomEditorTexture);
	}

	public static void Draw()
	{
		Dockspace();

		if (ImGui.BeginMainMenuBar())
		{
			if (ImGui.BeginMenu("File"))
			{
				ImGui.EndMenu();
			}
			if (ImGui.BeginMenu("Edit"))
			{
				ImGui.EndMenu();
			}
			if (ImGui.BeginMenu("Help"))
			{
				ImGui.EndMenu();
			}
		}
		ImGui.EndMainMenuBar();

		ImGui.SetNextWindowPos(.(0, 18));
		ImGui.SetNextWindowSize(.(RaylibBeef.Raylib.GetScreenWidth(), 61));
		if (ImGui.Begin("Toolbar", null, .NoTitleBar | .NoMove | .NoResize))
		{
			if (ImGui.Button("Run Game", .(32, 32)))
			{
				Application.Instance.IsRunning = !Application.Instance.IsRunning;
			}
		}
		ImGui.End();

		if (ImGui.Begin("Main Texture Page", null, .HorizontalScrollbar))
		{
			ImGui.SetCursorPosX(ImGui.GetScrollX() + 8);
			ImGui.SetCursorPosY(ImGui.GetScrollY() + 26);
			if (ImGui.Button("Reload"))
			{
				AssetsManager.LoadAllAssets();
			}
			ImGui.Separator();
			ImGui.SetCursorPosY(58);
			ImGui.Image((ImGui.TextureID)(int)AssetsManager.MainTexturePage.id, .(AssetsManager.MainTexturePage.width, AssetsManager.MainTexturePage.width));
		}
		ImGui.End();

		if (ImGui.Begin("Game"))
		{
			var windowSize = GetLargestSizeForViewport();
			windowSize.x = Mathf.Round2Nearest(windowSize.x, Application.Instance.ScreenBuffer.texture.width);
			windowSize.y = Mathf.Round2Nearest(windowSize.y, Application.Instance.ScreenBuffer.texture.height);
			if (windowSize.x <= 0)
				windowSize = GetLargestSizeForViewport();
			let windowPos = GetCenteredPositionForViewport(.(windowSize.x, windowSize.y));

			Fanty.[Friend]WindowViewport.x = windowPos.x + ImGui.GetWindowPos().x;
			Fanty.[Friend]WindowViewport.y = windowPos.y + ImGui.GetWindowPos().y;
			Fanty.[Friend]WindowViewport.width = windowSize.x;
			Fanty.[Friend]WindowViewport.height = windowSize.y;

			ImGui.SetCursorPos(.(windowPos.x, windowPos.y));
			ImGui.Image((ImGui.TextureID)(int)Application.Instance.ScreenBuffer.texture.id,
				windowSize,
				.(0, 1),
				.(1, 0));
		}
		ImGui.End();

		if (ImGui.Begin("Room Hierarchy"))
		{
			void DrawNode()
			{

			}

			var currentRoom = Application.Instance.[Friend]m_RoomRuntime.Room;

			for (var instanceLayer in currentRoom.InstanceLayers)
			{
				var opened = ImGui.TreeNodeEx(scope $"{instanceLayer.value.Name} ###{instanceLayer.key}");

				if (opened)
				{
					for (var gameobject in instanceLayer.value.GameObjects)
					{
						var name = gameobject.value.GetType().GetName(.. scope .());
						var flags = ImGui.TreeNodeFlags.Leaf;
						if (gameobject.key == selectedID)
							flags |= .Selected;
						ImGui.TreeNodeEx(name, flags);

						if (ImGui.IsItemClicked())
						{
							selectedID = gameobject.key;
							selectedType = .GameObject;
						}

						ImGui.TreePop();
					}

					ImGui.TreePop();
				}
			}

			for (var backgroundLayer in currentRoom.BackgroundLayers)
			{
				var flags = ImGui.TreeNodeFlags.Leaf;
				if (backgroundLayer.key == selectedID)
					flags |= .Selected;
				ImGui.TreeNodeEx(scope $"{backgroundLayer.value.Name} ###{backgroundLayer.key}", flags);

				if (ImGui.IsItemClicked())
				{
					selectedID = backgroundLayer.key;
					selectedType = .Layer;
				}

				ImGui.TreePop();
			}
		}
		ImGui.End();

		if (ImGui.Begin("Inspector"))
		{
			if (selectedType == .GameObject)
			{
				var gameobject = Application.Instance.[Friend]m_RoomRuntime.Room.GetGameObjectByGuid(selectedID);
				if (gameobject != null)
				{
					ImGui.Text(gameobject.GetType().GetName(.. scope .()));
					ImGui.Separator();

					var xy = float[2](gameobject.x, gameobject.y);
					if (ImGui.DragFloat2("position", ref xy))
					{
						gameobject.x = xy[0];
						gameobject.y = xy[1];
					}

					var scalexy = float[2](gameobject.ImageXScale, gameobject.ImageYScale);
					if (ImGui.DragFloat2("scale", ref scalexy))
					{
						gameobject.ImageXScale = scalexy[0];
						gameobject.ImageYScale = scalexy[1];
					}

					var angle = gameobject.ImageAngle;
					if (ImGui.DragFloat("rotation", &angle))
					{
						gameobject.ImageAngle = angle;
					}
				}
			}
			else if (selectedType == .Layer)
			{
				var bgLayer = (Room.BackgroundLayer)Application.Instance.[Friend]m_RoomRuntime.Room.GetLayerByID(selectedID);

				if (bgLayer != null)
				{
					if (!String.IsNullOrEmpty(bgLayer.Sprite))
					{
						ImGui.Text(bgLayer.Sprite);
					}
					var bgcolor = float[4](bgLayer.Color.r / 255f, bgLayer.Color.g / 255f, bgLayer.Color.b / 255f, bgLayer.Color.a / 255f);
					ImGui.ColorEdit4("Color", ref bgcolor, .AlphaBar);
					bgLayer.Color = .((uint8)(bgcolor[0] * 255), (uint8)(bgcolor[1] * 255), (uint8)(bgcolor[2] * 255), (uint8)(bgcolor[3] * 255));

					var horizTile = bgLayer.HorizontalTile;
					if (ImGui.Checkbox("Horizontal Tile", &horizTile))
						bgLayer.HorizontalTile = horizTile;
					var vertTile = bgLayer.VerticalTile;
					if (ImGui.Checkbox("Vertical Tile", &vertTile))
						bgLayer.VerticalTile = vertTile;

					var stretch = bgLayer.Stretch;
					if (ImGui.Checkbox("Stretch", &stretch))
						bgLayer.Stretch = stretch;

					var xyoffset = float[2](bgLayer.Position.x, bgLayer.Position.y);
					if (ImGui.DragFloat2("Offset", ref xyoffset))
					{
						bgLayer.Position.x = xyoffset[0];
						bgLayer.Position.y = xyoffset[1];
					}
				}
			}
		}
		ImGui.End();

		ImGui.PushStyleVar(.WindowPadding, .(1, 0));
		if (ImGui.Begin("Room Editor", null))
		{
			let contentSize = ImGui.GetContentRegionAvail();
			var currentRoom = Application.Instance.[Friend]m_RoomRuntime.Room;

			let editorWindowScreenPos = ImGui.GetCursorScreenPos();
			let mousePos = RaylibBeef.Vector2(RaylibBeef.Raylib.GetMousePosition().x - editorWindowScreenPos.x, RaylibBeef.Raylib.GetMousePosition().y - editorWindowScreenPos.y); // Weird y offset
			let mouseWorldPos = RaylibBeef.Raylib.GetScreenToWorld2D(
			    mousePos, m_RoomEditorCamera);
			let mouseInWindow = ImGui.IsWindowHovered();

			if (RaylibBeef.Raylib.IsMouseButtonDown(2))
			{
			    if (mouseInWindow)
			    {
			        m_RoomEditorPannedInWindow = true;
			    }
			}
			if (RaylibBeef.Raylib.IsMouseButtonReleased(2))
			    m_RoomEditorPannedInWindow = false;

			
			if (m_RoomEditorPannedInWindow)
			{
			    var delta = RaylibBeef.Raylib.GetMouseDelta();
			    delta = RaylibBeef.Raymath.Vector2Scale(delta, -1.0f / m_RoomEditorCamera.zoom);

			    m_RoomEditorCamera.target = RaylibBeef.Raymath.Vector2Add(m_RoomEditorCamera.target, delta);
			}

			var wheel = RaylibBeef.Raylib.GetMouseWheelMove();

			if (wheel != 0 && mouseInWindow)
			{
			    m_RoomEditorCamera.offset = mousePos;

			    m_RoomEditorCamera.target = mouseWorldPos;

				var goalZoom = m_RoomEditorCamera.zoom;
			    if (wheel > 0)
			    {
			        goalZoom += wheel * (m_RoomEditorCamera.zoom * 0.25f);
			    }
			    else
			    {
			        goalZoom += wheel * (m_RoomEditorCamera.zoom * 0.2f);
			    }

			    if (goalZoom < 0.25f)
			        goalZoom = 0.25f;

				m_RoomEditorCamera.zoom = goalZoom;
			    // camera.zoom = 0;
			}

			if (contentSize != m_LastRoomEditorViewportSize)
			{
				RaylibBeef.Raylib.UnloadRenderTexture(m_RoomEditorTexture);
				m_RoomEditorTexture = RaylibBeef.Raylib.LoadRenderTexture((int32)contentSize.x, (int32)contentSize.y);
			}

			RaylibBeef.Raylib.BeginTextureMode(m_RoomEditorTexture);
			RaylibBeef.Raylib.ClearBackground(Color(51, 51, 51, 255));

			for (var x < ((int)contentSize.x / 32) + 1)
			{
				for (var y < ((int)contentSize.y / 32) + 1)
				{
					if ((x - y) % 2 == 0)
						RaylibBeef.Raylib.DrawRectangleRec(.(x * 32, y * 32, 32, 32), .(58, 58, 58, 255));
				}
			}

			RaylibBeef.Raylib.BeginMode2D(m_RoomEditorCamera);

			var clipPos = RaylibBeef.Raylib.GetWorldToScreen2D(.(0, 0), m_RoomEditorCamera);
			RaylibBeef.Raylib.BeginScissorMode(
				(int32)clipPos.x, (int32)clipPos.y,
				(int32)(currentRoom.Width * m_RoomEditorCamera.zoom), (int32)(currentRoom.Height * m_RoomEditorCamera.zoom));
			for (var layer in currentRoom.BackgroundLayers)
			{
				let backgroundLayer = layer.value;
				if (backgroundLayer.HasSprite())
				{
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
				}
				else
				{
					RaylibBeef.Raylib.DrawRectangle(0, 0, (int32)currentRoom.Width, (int32)currentRoom.Height, layer.value.Color);
				}
			}
			RaylibBeef.Raylib.EndScissorMode();

			for (var instanceLayer in currentRoom.InstanceLayers)
			{
				for (var gameobject in instanceLayer.value.GameObjects)
				{
					if (gameobject.value.HasSprite())
					{
						Fanty.DrawSpriteExt(
							gameobject.value.SpriteIndex,
							0,
							.(gameobject.value.x, gameobject.value.y),
							.(gameobject.value.xOrigin, gameobject.value.yOrigin),
							.(gameobject.value.ImageXScale, gameobject.value.ImageYScale), 0);
					}
					else
					{
						RaylibBeef.Raylib.DrawCircle((int32)gameobject.value.x, (int32)gameobject.value.y, 16, Color.gray);
						RaylibBeef.Raylib.DrawText("?", (int32)gameobject.value.x - 4, (int32)gameobject.value.y - 6, 16, Color.white);
					}
					// RaylibBeef.Raylib.DrawRectangleRec(.(gameobject.value.x, gameobject.value.y, 32, 32), Color.red);
				}
			}

			var gridSize = Vector2Int(32, 32);

			let cameraViewX = Mathf.CeilToInt(m_LastRoomEditorViewportSize.x / m_RoomEditorCamera.zoom) + 1;
			let cameraViewY = Mathf.CeilToInt(m_LastRoomEditorViewportSize.y / m_RoomEditorCamera.zoom) + 1;
			var gridX = cameraViewX;
			var gridY = cameraViewY;

			
			var pixelXOffset = (int)(m_RoomEditorCamera.target.x - (m_RoomEditorCamera.offset.x / m_RoomEditorCamera.zoom));
			pixelXOffset = Mathf.Clamp(pixelXOffset, 0, currentRoom.Width);

			var pixelYOffset = (int)(m_RoomEditorCamera.target.y - (m_RoomEditorCamera.offset.y / m_RoomEditorCamera.zoom));
			pixelYOffset = Mathf.Clamp(pixelYOffset, 0, currentRoom.Height);

			for (var x < gridX + 1)
			{
				let xpos = (int32)((x * gridSize.x));
				if (xpos > currentRoom.Width)
					break;

				RaylibBeef.Raylib.DrawLine(xpos, 0, xpos, (int32)currentRoom.Height, Color(255, 255, 255, 175));

			}
			for (var y < gridY + 1)
			{
				let ypos = (int32)((y * gridSize.y));
				if (ypos > currentRoom.Height)
					break;
				RaylibBeef.Raylib.DrawLine(0, ypos, (int32)currentRoom.Width, ypos, Color(255, 255, 255, 175));
			}

			RaylibBeef.Raylib.EndMode2D();

			var rectScreenPos = RaylibBeef.Raylib.GetWorldToScreen2D(.(0, 0), m_RoomEditorCamera);
			var rectScreenPosMax = RaylibBeef.Raylib.GetWorldToScreen2D(.(currentRoom.Width, currentRoom.Height), m_RoomEditorCamera);
			RaylibBeef.Raylib.DrawLineEx(.(rectScreenPos.x, rectScreenPos.y), .(rectScreenPosMax.x, rectScreenPos.y), 1, Color.white); 		 // top
			RaylibBeef.Raylib.DrawLineEx(.(rectScreenPos.x, rectScreenPos.y), .(rectScreenPos.x, rectScreenPosMax.y), 1, Color.white); 		 // left
			RaylibBeef.Raylib.DrawLineEx(.(rectScreenPos.x, rectScreenPosMax.y), .(rectScreenPosMax.x, rectScreenPosMax.y), 1, Color.white); // bottom
			RaylibBeef.Raylib.DrawLineEx(.(rectScreenPosMax.x, rectScreenPos.y), .(rectScreenPosMax.x, rectScreenPosMax.y), 1, Color.white); // right


			RaylibBeef.Raylib.EndTextureMode();

			ImGui.Image((ImGui.TextureID)(int)m_RoomEditorTexture.texture.id,
				contentSize,
				.(0, 1),
				.(1, 0));

			m_LastRoomEditorViewportSize = contentSize;
		}
		ImGui.End();
		ImGui.PopStyleVar();
	}

	private static ImGui.Vec2 GetLargestSizeForViewport()
	{
	    var windowSize = ImGui.Vec2();
	    windowSize = ImGui.GetContentRegionAvail();
	    windowSize.x -= ImGui.GetScrollX();
	    windowSize.y -= ImGui.GetScrollY();

	    float aspectWidth = windowSize.x;
	    float aspectHeight = (aspectWidth / TargetAspectRatio());
	    if (aspectHeight > windowSize.y)
	    {
	        aspectHeight = windowSize.y;
	        aspectWidth = aspectHeight * TargetAspectRatio();
	    }

	    return .(aspectWidth, aspectHeight);
	}

	private static ImGui.Vec2 GetCenteredPositionForViewport(ImGui.Vec2 aspectSize)
	{
	    var windowSize = ImGui.Vec2();
	    windowSize = ImGui.GetContentRegionAvail();
	    windowSize.x -= ImGui.GetScrollX();
	    windowSize.y -= ImGui.GetScrollY();

	    float viewportX = (windowSize.x / 2.0f) - (aspectSize.x / 2.0f);
	    float viewportY = (windowSize.y / 2.0f) - (aspectSize.y / 2.0f);

	    return .(viewportX + ImGui.GetCursorPosX(), viewportY + ImGui.GetCursorPosY());
	}

	public static float TargetAspectRatio()
	{
	    return (float)Application.Instance.ScreenBuffer.texture.width / (float)Application.Instance.ScreenBuffer.texture.height;
	}

	private static void Dockspace()
	{
	    ImGui.PushStyleColor(ImGui.Col.WindowBg, 0);

	    let viewport = ImGui.GetMainViewport();
	    ImGui.SetNextWindowPos(.(viewport.Pos.x, viewport.Pos.y + 61), ImGui.Cond.Always);
	    ImGui.SetNextWindowSize(.(viewport.Size.x, viewport.Size.y - 61));
	    ImGui.SetNextWindowViewport(viewport.ID);

	    ImGui.PushStyleVar(ImGui.StyleVar.WindowPadding, .(0, 0));
	    ImGui.PushStyleVar(ImGui.StyleVar.WindowRounding, 0.0f);
	    ImGui.PushStyleVar(ImGui.StyleVar.WindowBorderSize, 0.0f);
	    let windowFlags = ImGui.WindowFlags.NoResize | .NoMove | .NoBringToFrontOnFocus | .NoNavFocus | .NoTitleBar | .NoBackground | .MenuBar | .NoDecoration;
	    ImGui.Begin("MainDockspaceWindow", null, windowFlags);
	    ImGui.PopStyleVar(3);

	    var dockspaceId = ImGui.GetID("MainDockspace");
	    ImGui.DockSpace(dockspaceId, .(0, 0), ImGui.DockNodeFlags.PassthruCentralNode);

	    ImGui.End();

	    ImGui.PopStyleColor();
	}
}