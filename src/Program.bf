using System;
using RaylibBeef;

namespace FantyEngine;

public class Program
{
	public static int Main(String[] args)
	{
		Raylib.InitWindow(1280, 720, "Title");
		Raylib.InitAudioDevice();

		while (!Raylib.WindowShouldClose())
		{
			Raylib.BeginDrawing();

			Raylib.EndDrawing();
		}

		Raylib.CloseAudioDevice();
		Raylib.CloseWindow();

		return 0;
	}
}