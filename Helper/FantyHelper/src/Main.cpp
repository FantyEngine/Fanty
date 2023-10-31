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

		// ImFontConfig config;
		// auto f = io.Fonts->AddFontFromFileTTF("C:\\Users\\Braedon\\Downloads\\JetBrainsMono-Regular.ttf", 18, &config);

		// return f;
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
}