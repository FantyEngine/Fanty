using System;

namespace RaylibBeef
{
	extension Raylib
	{
		[CLink]
		public static extern void* GetWindowGlfw();
		[CLink]
		public static extern void CallWindowResize();

		[CLink]
		public static extern void Fanty_SetupImGui(void* window, char8* defaultFontPath, char8* inconsPath);

		[CLink]
		public static extern void Fanty_ImGuiBegin(void* window, float deltaTime);

		[CLink]
		public static extern void Fanty_ImGuiEnd(void* window);
	}
}