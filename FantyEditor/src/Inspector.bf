using ImGui;
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
		ImGui.End();
	}
}