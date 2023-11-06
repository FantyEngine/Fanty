using System;
using System.IO;
using ImGui;
using RaylibBeef;
using Bon;
using System.Diagnostics;

namespace FantyEditor;

public static class MainEditor
{
	public const String AssetsPath = @"D:/Fanty/Sandbox/project";

	private static Texture2D m_BG_Image;
	private static RenderTexture2D m_BG_Texture;

	public static void Init()
	{
		gBonEnv.serializeFlags |= .Verbose | .IncludeDefault;

		FantyEngine.AssetsManager.LoadAllAssets();

		m_BG_Image = Raylib.LoadTexture(@"C:\Program Files\GameMaker\GUI\Skins\Dark\Images\Background\BG_Image.png");
		m_BG_Texture = Raylib.LoadRenderTexture(Raylib.GetScreenWidth(), Raylib.GetScreenHeight());

		Toolbar.Init();
		AssetBrowser.Init();
		RoomEditor.RoomEditor.Init();
		Inspector.Init();

		RaylibBeef.Raylib.Fanty_ImGuiPellyTheme();

	}

	public static void Deinit()
	{
		Inspector.Deinit();
		RoomEditor.RoomEditor.Deinit();
		AssetBrowser.Deinit();
		Toolbar.Deinit();

		Raylib.UnloadRenderTexture(m_BG_Texture);
		Raylib.UnloadTexture(m_BG_Image);
	}

	public static void Draw()
	{
		Raylib.BeginTextureMode(m_BG_Texture);

		Raylib.DrawTexturePro(
			m_BG_Image,
			.(0, 0, m_BG_Image.width, m_BG_Image.height),
			.(0, 0, Raylib.GetScreenWidth(), Raylib.GetScreenHeight()),
			.(0, 0),
			0,
			.(255, 255, 255, 255));

		Raylib.EndTextureMode();
	}

	public static void Gui()
	{

		// Background();

		Dockspace();
		Toolbar.Gui();
		AssetBrowser.Gui();
		RoomEditor.RoomEditor.Gui();
		Inspector.Gui();
		Output.Gui();

		// ImGui.ShowDemoWindow();
	}

	private static void Dockspace()
	{
	    ImGui.PushStyleColor(ImGui.Col.WindowBg, 0);

	    let viewport = ImGui.GetMainViewport();
	    ImGui.SetNextWindowPos(.(viewport.Pos.x, viewport.Pos.y + 62 + 3), ImGui.Cond.Always);
	    ImGui.SetNextWindowSize(.(viewport.Size.x, viewport.Size.y - 62 - 3));
	    ImGui.SetNextWindowViewport(viewport.ID);

	    ImGui.PushStyleVar(ImGui.StyleVar.WindowPadding, .(0, 0));
	    ImGui.PushStyleVar(ImGui.StyleVar.WindowRounding, 0.0f);
	    ImGui.PushStyleVar(ImGui.StyleVar.WindowBorderSize, 0.0f);
	    let windowFlags = ImGui.WindowFlags.NoResize | .NoMove | .NoBringToFrontOnFocus | .NoNavFocus | .NoTitleBar | .NoBackground | .NoDecoration | .MenuBar;
	    ImGui.Begin("MainDockspaceWindow", null, windowFlags);
		{
			var windowPos = ImGui.GetWindowPos();
			ImGui.GetWindowDrawList().AddImage((ImGui.TextureID)(int)m_BG_Image.id,
				windowPos,
				.(windowPos.x + ImGui.GetWindowWidth(), windowPos.y + ImGui.GetWindowHeight()));
			// ImGui.Text("bruh");
			// ImGui.Image((ImGui.TextureID)(int)m_BG_Texture.texture.id, ImGui.GetWindowSize());
		}
	    ImGui.PopStyleVar(3);

	    var dockspaceId = ImGui.GetID("MainDockspace");
	    ImGui.DockSpace(dockspaceId, .(0, 0), ImGui.DockNodeFlags.PassthruCentralNode);

	    ImGui.End();

	    ImGui.PopStyleColor();
	}

	private static void Background()
	{
		if (Raylib.IsWindowResized())
		{
			Raylib.UnloadRenderTexture(m_BG_Texture);
			m_BG_Texture = Raylib.LoadRenderTexture(Raylib.GetScreenWidth(), Raylib.GetScreenHeight());
		}
	}
}