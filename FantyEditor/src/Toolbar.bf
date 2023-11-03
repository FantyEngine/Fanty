using ImGui;

namespace FantyEditor;

public static class Toolbar
{
	public static void Gui()
	{
		ImGui.SetNextWindowPos(ImGui.GetMainViewport().Pos);
		ImGui.SetNextWindowSize(.(RaylibBeef.Raylib.GetScreenWidth(), 62));
		if (ImGui.Begin("Toolbar", null, .NoResize | .NoMove | .NoTitleBar))
		{
		}
		ImGui.End();
	}
}