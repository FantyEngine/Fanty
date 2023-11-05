using System;
using ImGui;

namespace FantyEditor;

public static class Output
{
	private static String m_OutputText = new .() ~ delete _;

	public static void Gui()
	{
		if (ImGui.Begin("Output", null))
		{
			if (ImGui.BeginChild("###OUTPUT_TEXT", .(), true))
			{
				ImGui.Text(m_OutputText);
			}
			ImGui.EndChild();
		}
		ImGui.End();
	}

	public static void AddOutputText(String text)
	{
		m_OutputText.Append(scope $"{text}\n");
	}
}