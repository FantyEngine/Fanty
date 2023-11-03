using System;
using RaylibBeef;
using ImGui;
using FantyEngine;

namespace FantyEditor;

class Program
{
	public static int Main(String[] args)
	{
		Raylib.SetConfigFlags((int32)(ConfigFlags.FLAG_WINDOW_RESIZABLE | .FLAG_VSYNC_HINT));
		Raylib.SetTraceLogLevel((int32)(TraceLogLevel.LOG_WARNING | .LOG_ERROR | .LOG_FATAL));
		Raylib.InitWindow(1600, 900, "Fanty Editor");
		Raylib.SetTargetFPS(185);
		Raylib.Fanty_SetupImGui(Raylib.GetWindowGlfw(), @"D:\flimmy\Assets\Resources\Fonts\Questrial-Regular.ttf", "");

		MainEditor.Init();

		while (!Raylib.WindowShouldClose())
		{
			Raylib.BeginDrawing();
			Raylib.ClearBackground(FantyEngine.Color.black);

			MainEditor.Draw();

			Raylib.Fanty_ImGuiBegin(Raylib.GetWindowGlfw(), Raylib.GetFrameTime());
			{
				MainEditor.Gui();
			}
			Raylib.Fanty_ImGuiEnd(Raylib.GetWindowGlfw());

			Raylib.EndDrawing();

		}

		MainEditor.Deinit();

		Raylib.CloseWindow();

		return 0;
	}
}