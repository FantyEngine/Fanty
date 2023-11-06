using ImGui;
using System.Collections;
using System;
using System.Diagnostics;
using System.IO;

namespace FantyEditor;

public static class Toolbar
{
	private static Dictionary<String, RaylibBeef.Texture2D> m_Buttons = new .() ~ DeleteDictionaryAndKeys!(_);

	public static void Init()
	{
		void LoadButton(String name)
		{
			m_Buttons.Add(new .(name), RaylibBeef.Raylib.LoadTexture(scope $"D:/Fanty/FantyEditor/assets/{name}.png"));
		}

		LoadButton("playgame");
		LoadButton("playscene");
		LoadButton("build");
		LoadButton("export");
		LoadButton("info");
	}

	public static void Deinit()
	{
		for (var button in m_Buttons)
		{
			RaylibBeef.Raylib.UnloadTexture(button.value);
		}
	}

	public static void Gui()
	{
		ImGui.PushStyleVar(ImGui.StyleVar.FramePadding, .(0, 4));
		ImGui.PushStyleVar(ImGui.StyleVar.WindowBorderSize, 0);
		ImGui.PushStyleVar(ImGui.StyleVar.PopupRounding, 0);
		if (ImGui.BeginMainMenuBar())
		{
			ImGui.SetCursorPosY(0);
			ImGui.SetCursorPosX(ImGui.GetCursorPosX() - 5);
			ImGui.PushStyleVar(ImGui.StyleVar.ItemSpacing, .(9, 8));
			if (ImGui.BeginMenu("File"))
			{
				ImGui.EndMenu();
			}
			if (ImGui.BeginMenu("Edit"))
			{
				ImGui.EndMenu();
			}
			if (ImGui.BeginMenu("View"))
			{
				ImGui.EndMenu();
			}
			if (ImGui.BeginMenu("Tools"))
			{
				ImGui.EndMenu();
			}
			if (ImGui.BeginMenu("Help"))
			{
				ImGui.EndMenu();
			}
			ImGui.PopStyleVar();
		}
		ImGui.EndMainMenuBar();
		ImGui.PopStyleVar(3);

		ImGui.SetNextWindowPos(.(ImGui.GetMainViewport().Pos.x - 1, ImGui.GetMainViewport().Pos.y + 22 - 1));
		ImGui.SetNextWindowSize(.(RaylibBeef.Raylib.GetScreenWidth() + 2, 62));
		ImGui.PushStyleVar(.WindowPadding, .(6, 6));
		ImGui.PushStyleVar(.WindowRounding, 0);
		ImGui.PushStyleColor(.Button, FantyEngine.Color.transparent);
		if (ImGui.Begin("Toolbar", null, .NoResize | .NoMove | .NoTitleBar | .NoScrollbar | .NoDecoration))
		{
			bool DrawButton(String key, String caption)
			{
				ImGui.PushStyleVar(.FrameRounding, 4);

				let captionWidth = ImGui.CalcTextSize(caption).x;
				let buttonContentPadding = 12.0f;
				
				let cursorPos = ImGui.GetCursorScreenPos();

				let buttonWidth = FantyEngine.Mathf.Max(buttonContentPadding + captionWidth, 32 + buttonContentPadding);
				let halfButtonWidth = buttonWidth * 0.5f;

				var ret = ImGui.ButtonEx(scope $"###{key}{caption}", .(buttonWidth, ImGui.GetContentRegionAvail().y));

				ImGui.SameLine();

				ImGui.GetWindowDrawList().AddText(
					.(cursorPos.x + halfButtonWidth - (captionWidth * 0.5f), cursorPos.y + 32),
					FantyEngine.Color.white,
					caption);

				ImGui.GetWindowDrawList().AddImage(
					(ImGui.TextureID)(int)m_Buttons[key].id,
					.(cursorPos.x + halfButtonWidth - 16, cursorPos.y),
					.(cursorPos.x + halfButtonWidth + 16, cursorPos.y + 32));

				ImGui.SameLine();
				ImGui.PopStyleVar();

				return ret;
			}

			void VerticalSeparator()
			{
				var x = ImGui.GetCursorPosX();
				ImGui.PushStyleVar(ImGui.StyleVar.ItemSpacing, .(9, 0));

				ImGui.PushStyleColor(ImGui.Col.Separator, FantyEngine.Color.transparent);
				ImGui.Separator();
				ImGui.SameLine();
				ImGui.PopStyleColor();

				var drawList = ImGui.GetWindowDrawList();
				var col = *ImGui.GetStyleColorVec4(.Border);
				drawList.AddLine(.(x, ImGui.GetCursorScreenPos().y), .(x, ImGui.GetCursorScreenPos().y + ImGui.GetContentRegionAvail().y - 2), ImGui.GetColorU32(col), 1);

				ImGui.PopStyleVar();
			}

			if (DrawButton("playgame", "Game"))
			{
				/*
				var startinfo = scope ProcessStartInfo();
				startinfo.SetFileName(@"C:\Users\Braedon\AppData\Local\BeefLang\bin\BeefBuild_d.exe");
				startinfo.SetWorkingDirectory(@"D:\Fanty");
				startinfo.SetArguments("");

				var process = scope SpawnedProcess();
				process.Start(startinfo);

				if (process.WaitFor() && (process.ExitCode == 0))
				{
					Console.WriteLine("Project built");
				}

				process.Close();
				*/

				var startinfo = scope ProcessStartInfo();
				startinfo.SetFileName(@"D:\Fanty\build\Debug_Win64\FantyRuntime\FantyRuntime.exe");
				// startinfo.SetWorkingDirectory(@"D:\Fanty\build\Debug_Win64\FantyRuntime");
				startinfo.SetArguments("");
				startinfo.CreateNoWindow = true;
				startinfo.RedirectStandardOutput = true;

				var process = scope SpawnedProcess();
				process.Start(startinfo);

				if (process.WaitFor() && (process.ExitCode == 0))
				{
					Output.AddOutputText("Played successfully!");
				}

				process.Close();
			}
			DrawButton("playscene", "Room");
			VerticalSeparator();
			DrawButton("build", "Build");
			DrawButton("export", "Export");
		}
		ImGui.PopStyleColor();
		ImGui.PopStyleVar(2);
		ImGui.End();
	}
}