using ImGui;
using System;
using FantyEngine;

using FantyEditor.RoomEditor;
namespace FantyEditor;

public static class Inspector : IPanel
{
	public static void Init()
	{

	}

	public static void Deinit()
	{

	}

	public static void Gui()
	{
		if (ImGui.Begin("Inspector", null))
		{
			// Use a state machine in the future
			if (RoomEditor.SelectedGameObjects.Count > 0)
			{
				for (var marker in RoomEditor.RoomEditor.SelectedGameObjects)
				{
					var go = marker.GameObject;
					ImGui.Text(go.AssetName);
					var pos = float[2](go.x, go.y);
					if (ImGui.DragFloat2("Position", ref pos))
					{
						go.x = pos[0];
						go.y = pos[1];
					}
					var scale = float[2](go.ImageXScale, go.ImageYScale);
					if (ImGui.DragFloat2("Scale", ref scale))
					{
						go.ImageXScale = scale[0];
						go.ImageYScale = scale[1];
					}
					var angle = go.ImageAngle;
					if (ImGui.DragFloat("Rotation", &angle))
					{
						go.ImageAngle = angle;
					}
					if (ImGui.Button("Flip X"))
					{
						go.ImageXScale *= -1;
					}
					if (ImGui.Button("Flip Y"))
					{
						go.ImageYScale *= -1;
					}
				}
			}
			else
			{
				if (RoomEditor.[Friend]m_SelectedType == .BackgroundLayer)
				{
					if (RoomEditor.[Friend]m_CurrentRoom.GetLayerByID(RoomEditor.[Friend]m_SelectedID) case .Ok(let layer))
					{
						var bg = (RoomAsset.BackgroundLayer)layer;

						ImGui.Text(layer.Name);
						ImGui.Separator();

						var color = float[4](bg.Color.r / 255f, bg.Color.g / 255f, bg.Color.b / 255f, bg.Color.a / 255f);
						if (ImGui.ColorEdit4("Color", ref color, .AlphaBar))
						{
							bg.Color = .((uint8)(color[0] * 255f), (uint8)(color[1] * 255f), (uint8)(color[2] * 255f), (uint8)(color[3] * 255f));
						}

						WidgetBool("Horizontal Tile", ref bg.HorizontalTile);
						WidgetBool("Vertical Tile", ref bg.VerticalTile);
						WidgetBool("Stretch", ref bg.Stretch);

						WidgetVec2("Offset", ref bg.Position);
						WidgetVec2("Speed", ref bg.Speed);
					}
				}
				else if (RoomEditor.[Friend]m_SelectedType == .Room)
				{
					var room = RoomEditor.[Friend]m_CurrentRoom;
					var size = Vector2Int(room.Width, room.Height);
					WidgetVec2I("Size", ref size);
					room.Width = size.x;
					room.Height = size.y;

					WidgetBool("Enable Viewports", ref room.EnableViewports);
				}
			}
		}
		ImGui.End();
	}

	private static void WidgetVec2(String label, ref Vector2 vector)
	{
		var pos = float[2](vector.x, vector.y);
		if (ImGui.DragFloat2(label, ref pos))
		{
			vector.x = pos[0];
			vector.y = pos[1];
		}
	}

	private static void WidgetVec2I(String label, ref Vector2Int vector)
	{
		var pos = int32[2]((int32)vector.x, (int32)vector.y);
		if (ImGui.DragInt2(label, ref pos))
		{
			vector.x = pos[0];
			vector.y = pos[1];
		}
	}

	private static void WidgetBool(String label, ref bool a)
	{
		ImGui.Checkbox(label, &a);
	}
}