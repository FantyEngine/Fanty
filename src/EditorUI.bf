using ImGui;
using System;

namespace FantyEngine;

public static class EditorUI
{
	private static GameObject selectedGameObject;

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

		if (ImGui.Begin("Main Texture Page"))
		{
			ImGui.Image((ImGui.TextureID)(int)AssetsManager.MainTexturePage.id, .(AssetsManager.MainTexturePage.width, AssetsManager.MainTexturePage.width));
		}
		ImGui.End();

		if (ImGui.Begin("Game"))
		{
			var windowSize = GetLargestSizeForViewport();
			windowSize.x = Mathf.Round2Nearest(windowSize.x, Application.Instance.ScreenBuffer.texture.width / 2);
			windowSize.y = Mathf.Round2Nearest(windowSize.y, Application.Instance.ScreenBuffer.texture.height / 2);
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

		if (ImGui.Begin("Scene Hierarchy Tester"))
		{
			void DrawNode()
			{

			}

			var currentRoom = Application.Instance.[Friend]m_RoomRuntime.Room;

			for (var instanceLayer in currentRoom.InstanceLayers)
			{
				var opened = ImGui.TreeNodeEx("Instance Layer");

				if (opened)
				{
					for (var gameobject in instanceLayer.value.GameObjects)
					{
						var name = gameobject.GetType().GetName(.. scope .());
						var flags = ImGui.TreeNodeFlags.Leaf;
						if (gameobject == selectedGameObject)
							flags |= .Selected;
						ImGui.TreeNodeEx(name, flags);

						if (ImGui.IsItemClicked())
						{
							selectedGameObject = gameobject;
						}

						ImGui.TreePop();
					}

					ImGui.TreePop();
				}
			}
		}
		ImGui.End();

		if (ImGui.Begin("Inspector Tester"))
		{
			if (selectedGameObject != null)
			{
				var gameobject = selectedGameObject;

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
		ImGui.End();
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
	    ImGui.SetNextWindowPos(.(viewport.Pos.x, viewport.Pos.y), ImGui.Cond.Always);
	    ImGui.SetNextWindowSize(.(viewport.Size.x, viewport.Size.y));
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