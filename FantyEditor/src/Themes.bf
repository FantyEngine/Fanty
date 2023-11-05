using ImGui;

namespace FantyEditor;

public class Themes
{
	public static void Default()
	{
		var style = ImGui.GetStyle();
		
		style.AntiAliasedLinesUseTex = false;
		
		style.FramePadding.x = 4;
		style.FramePadding.y = 2;
		style.ItemSpacing.x = 10;
		style.ItemSpacing.y = 3;
		style.WindowPadding.x = 8;
		style.WindowRounding = 2;
		style.WindowBorderSize = 1;
		style.FrameBorderSize = 0;
		style.FrameRounding = 2;
		style.ScrollbarRounding = 2;
		style.ChildRounding = 4;
		style.PopupRounding = 4;
		style.GrabRounding = 2.0f;
		style.TabRounding = 2;
		style.ScrollbarSize = 16;

		style.Colors[(int32)ImGui.Col.WindowBg]				= .(0.20f, 0.20f, 0.20f, 1.00f);
		style.Colors[(int32)ImGui.Col.Border]				= .(0.10f, 0.10f, 0.10f, 0.85f);
		style.Colors[(int32)ImGui.Col.BorderShadow]			= .(0.10f, 0.10f, 0.10f, 0.35f);
		style.Colors[(int32)ImGui.Col.FrameBg]				= .(0.15f, 0.15f, 0.15f, 1.00f);
		style.Colors[(int32)ImGui.Col.FrameBgHovered]		= .(0.15f, 0.15f, 0.15f, 0.78f);
		style.Colors[(int32)ImGui.Col.FrameBgActive]		= .(0.15f, 0.15f, 0.15f, 0.67f);
		style.Colors[(int32)ImGui.Col.TitleBg]				= .(0.10f, 0.10f, 0.10f, 1.00f);
		style.Colors[(int32)ImGui.Col.TitleBgActive]		= .(0.13f, 0.13f, 0.13f, 1.00f);
		style.Colors[(int32)ImGui.Col.MenuBarBg]			= .(0.14f, 0.14f, 0.14f, 1.00f);
		style.Colors[(int32)ImGui.Col.CheckMark]			= .(0.69f, 0.69f, 0.69f, 1.00f);
		style.Colors[(int32)ImGui.Col.Button]				= .(0.28f, 0.28f, 0.28f, 1.00f);
		style.Colors[(int32)ImGui.Col.ButtonHovered]		= .(0.35f, 0.35f, 0.35f, 1.00f);
		style.Colors[(int32)ImGui.Col.ButtonActive]			= .(0.16f, 0.44f, 0.75f, 1.00f);
		style.Colors[(int32)ImGui.Col.Header]				= .(0.16f, 0.44f, 0.75f, 1.00f);
		style.Colors[(int32)ImGui.Col.HeaderHovered]		= .(0.20f, 0.48f, 0.88f, 1.00f);
		style.Colors[(int32)ImGui.Col.HeaderActive]			= .(0.16f, 0.44f, 0.75f, 1.00f);
		style.Colors[(int32)ImGui.Col.Separator]			= .(0.15f, 0.15f, 0.15f, 1.00f);
		style.Colors[(int32)ImGui.Col.SeparatorActive]		= .(0.15f, 0.15f, 0.15f, 1.00f);
		style.Colors[(int32)ImGui.Col.Tab]					= .(0.16f, 0.16f, 0.16f, 1.00f);
		style.Colors[(int32)ImGui.Col.TabHovered]			= .(0.19f, 0.48f, 0.88f, 0.80f);
		style.Colors[(int32)ImGui.Col.TabActive]			= .(0.16f, 0.44f, 0.75f, 1.00f);
		style.Colors[(int32)ImGui.Col.TabUnfocused]			= .(0.20f, 0.20f, 0.20f, 1.00f);
		style.Colors[(int32)ImGui.Col.TabUnfocusedActive]	= .(0.20f, 0.20f, 0.20f, 1.00f);
		style.Colors[(int32)ImGui.Col.ChildBg]				= .(0.20f, 0.20f, 0.20f, 1.00f);
		style.Colors[(int32)ImGui.Col.PopupBg]				= .(0.20f, 0.20f, 0.20f, 1.00f);
		style.Colors[(int32)ImGui.Col.TitleBg]				= .(0.13f, 0.13f, 0.13f, 1.00f);
		style.Colors[(int32)ImGui.Col.TitleBgCollapsed]		= .(0.15f, 0.15f, 0.15f, 1.00f);
		style.Colors[(int32)ImGui.Col.ScrollbarBg]			= .(0.15f, 0.15f, 0.15f, 1.00f);
		style.Colors[(int32)ImGui.Col.ModalWindowDimBg]		= .(0.00f, 0.00f, 0.00f, 0.35f);
	}

	public static void GithubDark()
	{
	    var style = ImGui.GetStyle();

	    style.AntiAliasedLinesUseTex = false;

	    style.PopupRounding = 0;
	    // style.WindowPadding = new Vector2(4, 4);
	    // style.FramePadding = new Vector2(6, 4);
	    // style.ItemSpacing = new Vector2(6, 2);
	    style.ScrollbarSize = 16;
	    style.WindowBorderSize = 1;
	    style.ChildBorderSize = 1;
	    style.PopupBorderSize = 1;
	    style.FrameBorderSize = 1;
	    style.WindowRounding = 4;
	    style.ChildRounding = 0;
	    style.FrameRounding = 4;
	    style.ScrollbarRounding = 2;
	    style.GrabRounding = 3;
	    style.TabBorderSize = 0;
	    style.TabRounding = 0;
	    // style.Colors[(int32)ImGui.Col.WindowBg] = .(0, 0, 0, 0.1f);
	    style.WindowMenuButtonPosition = ImGui.Dir.None;

	    style.Colors[(int32)ImGui.Col.Text]					= .(1.00f, 1.00f, 1.00f, 1.00f);
	    style.Colors[(int32)ImGui.Col.TextDisabled]			= .(0.40f, 0.40f, 0.40f, 1.00f);

	    style.Colors[(int32)ImGui.Col.ChildBg]				= (ImGui.Vec4)FantyEngine.Color("171a20");
	    style.Colors[(int32)ImGui.Col.WindowBg]				= (ImGui.Vec4)FantyEngine.Color("21262e");
	    style.Colors[(int32)ImGui.Col.PopupBg]				= (ImGui.Vec4)FantyEngine.Color("1c2027");

	    // style.Colors[(int32)ImGui.Col.Border]				= Color("353435");
	    // style.Colors[(int32)ImGui.Col.BorderShadow]		= .(1.00f, 1.00f, 1.00f, 0.06f);

	    style.Colors[(int32)ImGui.Col.FrameBg]				= (ImGui.Vec4)FantyEngine.Color("171a20"); // 171a20
	    style.Colors[(int32)ImGui.Col.FrameBgHovered]			= (ImGui.Vec4)FantyEngine.Color("21262e"); // 424c57
	    style.Colors[(int32)ImGui.Col.FrameBgActive]			= (ImGui.Vec4)FantyEngine.Color("424c57");

	    style.Colors[(int32)ImGui.Col.TitleBg]				= (ImGui.Vec4)FantyEngine.Color("1c2027");
	    style.Colors[(int32)ImGui.Col.TitleBgActive]			= (ImGui.Vec4)FantyEngine.Color("1c2027");
	    style.Colors[(int32)ImGui.Col.TitleBgCollapsed]		= (ImGui.Vec4)FantyEngine.Color("1c2027");

	    style.Colors[(int32)ImGui.Col.MenuBarBg]				= (ImGui.Vec4)FantyEngine.Color("1c2027");

	    style.Colors[(int32)ImGui.Col.ScrollbarBg]			= (ImGui.Vec4)FantyEngine.Color("171a20");
	    style.Colors[(int32)ImGui.Col.ScrollbarGrab]			= (ImGui.Vec4)FantyEngine.Color("21262e");
	    style.Colors[(int32)ImGui.Col.ScrollbarGrabHovered]	= (ImGui.Vec4)FantyEngine.Color("424c57");
	    style.Colors[(int32)ImGui.Col.ScrollbarGrabActive]	= (ImGui.Vec4)FantyEngine.Color("424c57");

	    style.Colors[(int32)ImGui.Col.CheckMark]				= .(0.65f, 0.65f, 0.65f, 1.00f);

	    style.Colors[(int32)ImGui.Col.SliderGrab]				= (ImGui.Vec4)FantyEngine.Color("424c57");
	    style.Colors[(int32)ImGui.Col.SliderGrabActive]		= (ImGui.Vec4)FantyEngine.Color("21262e");

	    style.Colors[(int32)ImGui.Col.Button]					= (ImGui.Vec4)FantyEngine.Color("21262e");
	    style.Colors[(int32)ImGui.Col.ButtonHovered]			= (ImGui.Vec4)FantyEngine.Color("424c57"); 
	    style.Colors[(int32)ImGui.Col.ButtonActive]			= (ImGui.Vec4)FantyEngine.Color("636f7b");

	    style.Colors[(int32)ImGui.Col.Header]					= (ImGui.Vec4)FantyEngine.Color("21262e");
	    style.Colors[(int32)ImGui.Col.HeaderHovered]			= (ImGui.Vec4)FantyEngine.Color("424c57");
	    style.Colors[(int32)ImGui.Col.HeaderActive]			= (ImGui.Vec4)FantyEngine.Color("636f7b");

	    style.Colors[(int32)ImGui.Col.Separator]				= (ImGui.Vec4)FantyEngine.Color("636f7b");
	    style.Colors[(int32)ImGui.Col.SeparatorHovered]		= (ImGui.Vec4)FantyEngine.Color("636f7b");
	    style.Colors[(int32)ImGui.Col.SeparatorActive]		= (ImGui.Vec4)FantyEngine.Color("636f7b");

	    style.Colors[(int32)ImGui.Col.ResizeGrip]				= .(0.26f, 0.59f, 0.98f, 0.25f);
	    style.Colors[(int32)ImGui.Col.ResizeGripHovered]		= .(0.26f, 0.59f, 0.98f, 0.67f);
	    style.Colors[(int32)ImGui.Col.ResizeGripActive]		= .(0.26f, 0.59f, 0.98f, 0.95f);

	    style.Colors[(int32)ImGui.Col.PlotLines]				= .(0.61f, 0.61f, 0.61f, 1.00f);
	    style.Colors[(int32)ImGui.Col.PlotLinesHovered]		= .(1.00f, 0.43f, 0.35f, 1.00f);
	    style.Colors[(int32)ImGui.Col.PlotHistogram]			= .(0.90f, 0.70f, 0.00f, 1.00f);
	    style.Colors[(int32)ImGui.Col.PlotHistogramHovered]	= .(1.00f, 0.60f, 0.00f, 1.00f);

	    style.Colors[(int32)ImGui.Col.TextSelectedBg]			= .(0.73f, 0.73f, 0.73f, 0.35f);

	    style.Colors[(int32)ImGui.Col.ModalWindowDimBg]		= .(0.80f, 0.80f, 0.80f, 0.35f);

	    style.Colors[(int32)ImGui.Col.DragDropTarget]			= .(1.00f, 1.00f, 0.00f, 0.90f);

	    style.Colors[(int32)ImGui.Col.NavHighlight]			= .(0.26f, 0.59f, 0.98f, 1.00f);
	    style.Colors[(int32)ImGui.Col.NavWindowingHighlight]	= .(1.00f, 1.00f, 1.00f, 0.70f);
	    style.Colors[(int32)ImGui.Col.NavWindowingDimBg]		= .(0.80f, 0.80f, 0.80f, 0.20f);

	    style.Colors[(int32)ImGui.Col.DockingEmptyBg]			= .(0.38f, 0.38f, 0.38f, 1.00f);

	    style.Colors[(int32)ImGui.Col.Tab]					= (ImGui.Vec4)FantyEngine.Color("1c2027");
	    style.Colors[(int32)ImGui.Col.TabHovered]				= (ImGui.Vec4)FantyEngine.Color("21262e");
	    style.Colors[(int32)ImGui.Col.TabActive]				= (ImGui.Vec4)FantyEngine.Color("424c57");
	    style.Colors[(int32)ImGui.Col.TabUnfocused]			= (ImGui.Vec4)FantyEngine.Color("171a20");
	    style.Colors[(int32)ImGui.Col.TabUnfocusedActive]		= (ImGui.Vec4)FantyEngine.Color("424c57");

	    style.Colors[(int32)ImGui.Col.DockingPreview]			= (ImGui.Vec4)FantyEngine.Color("02b594");
	}
}