#include "Fanty.hpp"

extern "C"
{
	FANTY_API void Fanty_SetupImGui(GLFWwindow* window, const char* defaultFontPath, const char* iconsPath)
	{
		ImGui::CreateContext();

		ImGuiIO& io = ImGui::GetIO();
		io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;   // Enable Keyboard Controls
		io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;	// Enable Gamepad Controls
		io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;       // Enable Docking
		// io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;     // Enable Multi-Viewport / Platform Windows
		// io.ConfigViewportsNoAutoMerge = true;
		// io.ConfigViewportsNoTaskBarIcon = true;

		if (strlen(defaultFontPath) > 0)
		{
			io.Fonts->Clear();
			io.Fonts->AddFontFromFileTTF(defaultFontPath, 14);
		}
		else
			io.Fonts->AddFontDefault();

		if (strlen(iconsPath) > 0)
		{
			static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_16_FA, 0 };
			ImFontConfig icons_config;
			icons_config.MergeMode = true;
			icons_config.PixelSnapH = true;
			icons_config.GlyphMinAdvanceX = 13;
			io.Fonts->AddFontFromFileTTF(iconsPath, 13, &icons_config, icons_ranges);
		}

		// When viewports are enabled we tweak WindowRounding/WindowBg so platform windows can look identical to regular ones.
		ImGuiStyle& style = ImGui::GetStyle();
		if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
		{
			style.WindowRounding = 0.0f;
			style.Colors[ImGuiCol_WindowBg].w = 1.0f;
		}

		ImGui::StyleColorsDark();

		ImGui_ImplGlfw_InitForOpenGL(window, true);
		ImGui_ImplOpenGL3_Init("#version 130");
	}

	FANTY_API void Fanty_ImGuiBegin(GLFWwindow* window, float deltaTime)
	{
		ImGui_ImplOpenGL3_NewFrame();
		ImGui_ImplGlfw_NewFrame();
		ImGui::NewFrame();
	}

	FANTY_API void Fanty_ImGuiEnd(GLFWwindow* window)
	{
		ImGui::Render();
		glfwMakeContextCurrent(window);

		ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

		if (ImGui::GetIO().ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
		{
			GLFWwindow* backup_current_window = glfwGetCurrentContext();
			ImGui::UpdatePlatformWindows();
			ImGui::RenderPlatformWindowsDefault(NULL, NULL);
			glfwMakeContextCurrent(backup_current_window);
		}
	}

	FANTY_API void Fanty_ImGuiPellyTheme(ImGuiStyle* dst)
	{
		ImGuiStyle* style = dst ? dst : &ImGui::GetStyle();
		style->AntiAliasedLinesUseTex = false;

		style->FramePadding.x = 4;
		style->FramePadding.y = 2;
		style->ItemSpacing.x = 10;
		style->ItemSpacing.y = 3;
		style->WindowPadding.x = 8;
		style->WindowRounding = 2;
		style->WindowBorderSize = 1;
		style->FrameBorderSize = 0;
		style->FrameRounding = 2;
		style->ScrollbarRounding = 2;
		style->ChildRounding = 4;
		style->PopupRounding = 4;
		style->GrabRounding = 2.0f;
		style->TabRounding = 2;
		style->ScrollbarSize = 16;

		style->Colors[ImGuiCol_WindowBg]			= ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
		style->Colors[ImGuiCol_Border]				= ImVec4(0.10f, 0.10f, 0.10f, 0.85f);
		style->Colors[ImGuiCol_BorderShadow]		= ImVec4(0.10f, 0.10f, 0.10f, 0.35f);
		style->Colors[ImGuiCol_FrameBg]				= ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
		style->Colors[ImGuiCol_FrameBgHovered]		= ImVec4(0.15f, 0.15f, 0.15f, 0.78f);
		style->Colors[ImGuiCol_FrameBgActive]		= ImVec4(0.15f, 0.15f, 0.15f, 0.67f);
		style->Colors[ImGuiCol_TitleBg]				= ImVec4(0.10f, 0.10f, 0.10f, 1.00f);
		style->Colors[ImGuiCol_TitleBgActive]		= ImVec4(0.13f, 0.13f, 0.13f, 1.00f);
		style->Colors[ImGuiCol_MenuBarBg]			= ImVec4(0.14f, 0.14f, 0.14f, 1.00f);
		style->Colors[ImGuiCol_CheckMark]			= ImVec4(0.69f, 0.69f, 0.69f, 1.00f);
		style->Colors[ImGuiCol_Button]				= ImVec4(0.28f, 0.28f, 0.28f, 1.00f);
		style->Colors[ImGuiCol_ButtonHovered]		= ImVec4(0.35f, 0.35f, 0.35f, 1.00f);
		style->Colors[ImGuiCol_ButtonActive]		= ImVec4(0.16f, 0.44f, 0.75f, 1.00f);
		style->Colors[ImGuiCol_Header]				= ImVec4(0.16f, 0.44f, 0.75f, 1.00f);
		style->Colors[ImGuiCol_HeaderHovered]		= ImVec4(0.20f, 0.48f, 0.88f, 1.00f);
		style->Colors[ImGuiCol_HeaderActive]		= ImVec4(0.16f, 0.44f, 0.75f, 1.00f);
		style->Colors[ImGuiCol_Separator]			= ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
		style->Colors[ImGuiCol_SeparatorActive]		= ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
		style->Colors[ImGuiCol_Tab]					= ImVec4(0.16f, 0.16f, 0.16f, 1.00f);
		style->Colors[ImGuiCol_TabHovered]			= ImVec4(0.19f, 0.48f, 0.88f, 0.80f);
		style->Colors[ImGuiCol_TabActive]			= ImVec4(0.16f, 0.44f, 0.75f, 1.00f);
		style->Colors[ImGuiCol_TabUnfocused]		= ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
		style->Colors[ImGuiCol_TabUnfocusedActive]	= ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
		style->Colors[ImGuiCol_ChildBg]				= ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
		style->Colors[ImGuiCol_PopupBg]				= ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
		style->Colors[ImGuiCol_TitleBg]				= ImVec4(0.13f, 0.13f, 0.13f, 1.00f);
		style->Colors[ImGuiCol_TitleBgCollapsed]	= ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
		style->Colors[ImGuiCol_ScrollbarBg]			= ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
		style->Colors[ImGuiCol_ModalWindowDimBg]	= ImVec4(0.00f, 0.00f, 0.00f, 0.35f);
	}
}