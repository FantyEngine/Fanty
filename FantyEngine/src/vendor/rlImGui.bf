using System;

namespace RaylibBeef
{
	extension Raylib
	{
		[CLink]
		public static extern void* GetWindowGlfw();
		[CLink]
		public static extern void CallWindowResize(void* window, int32 width, int32 height);

		[CLink]
		public static extern void Fanty_SetupImGui(void* window, char8* defaultFontPath, char8* inconsPath);

		[CLink]
		public static extern void Fanty_ImGuiBegin(void* window, float deltaTime);

		[CLink]
		public static extern void Fanty_ImGuiEnd(void* window);

		[CLink]
		public static extern void Fanty_ImGuiPellyTheme(void* dst = null);
	}
}