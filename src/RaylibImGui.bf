using RaylibBeef;
using ImGui;
using System.Collections;
using System;

class RaylibImGui
{
	static ImGui.Context* context;
	static RaylibBeef.Texture fontTexture;

	static double g_Time = 0.0;

	static ImGui.MouseCursor currentMouseCursor = ImGui.MouseCursor.COUNT;
	static Dictionary<ImGui.MouseCursor, MouseCursor> mouseCursorMap;

	public static void Setup()
	{
		mouseCursorMap = new Dictionary<ImGui.MouseCursor, MouseCursor>();

		context = ImGui.CreateContext();

		ImGui.StyleColorsDark();

		ImGui_ImplRaylib_Init();

		var io = ImGui.GetIO();
		io.ConfigFlags |= .NavEnableKeyboard;
		io.ConfigFlags |= .ViewportsEnable;
		io.ConfigFlags |= .DockingEnable;

		ImGui.GetStyle().AntiAliasedLinesUseTex = false; // Weird thing regarding raylib.
		ImGui.GetStyle().FrameRounding = 4;
		ImGui.GetStyle().GrabRounding = 2;
	}

	public static void Shutdown()
	{
		Raylib.UnloadTexture(fontTexture);

		delete mouseCursorMap;
	}

	public static void ReloadFonts()
	{
		ImGui.SetCurrentContext(context);
		var io = ImGui.GetIO();
		
		int32 width, height, bytesPerPixel;
		uint8* pixels;
		io.Fonts.GetTexDataAsRGBA32(out pixels, out width, out height, &bytesPerPixel);

		Image image = Image
		{
		    data = pixels,
		    width = width,
		    height = height,
		    mipmaps = 1,
		    format = (int32)PixelFormat.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,
		};

		fontTexture = Raylib.LoadTextureFromImage(image);

		io.Fonts.SetTexID(&fontTexture);
	}

	private static void SetupMouseCursors()
	{
	    mouseCursorMap.Clear();
	    mouseCursorMap[ImGui.MouseCursor.Arrow] = MouseCursor.MOUSE_CURSOR_ARROW;
	    mouseCursorMap[ImGui.MouseCursor.TextInput] = MouseCursor.MOUSE_CURSOR_IBEAM;
	    mouseCursorMap[ImGui.MouseCursor.Hand] = MouseCursor.MOUSE_CURSOR_POINTING_HAND;
	    mouseCursorMap[ImGui.MouseCursor.ResizeAll] = MouseCursor.MOUSE_CURSOR_RESIZE_ALL;
	    mouseCursorMap[ImGui.MouseCursor.ResizeEW] = MouseCursor.MOUSE_CURSOR_RESIZE_EW;
	    mouseCursorMap[ImGui.MouseCursor.ResizeNESW] = MouseCursor.MOUSE_CURSOR_RESIZE_NESW;
	    mouseCursorMap[ImGui.MouseCursor.ResizeNS] = MouseCursor.MOUSE_CURSOR_RESIZE_NS;
	    mouseCursorMap[ImGui.MouseCursor.ResizeNWSE] = MouseCursor.MOUSE_CURSOR_RESIZE_NWSE;
	    mouseCursorMap[ImGui.MouseCursor.NotAllowed] = MouseCursor.MOUSE_CURSOR_NOT_ALLOWED;
	}

	public static bool ImGui_ImplRaylib_Init()
	{
		SetupMouseCursors();

		Rlgl.rlEnableScissorTest();
		ImGui.IO* io = ImGui.GetIO();

		ImGui.SetCurrentContext(context);
		io.Fonts.AddFontDefault();
		
		io.KeyMap[(int)ImGui.Key.Tab] = (int)KeyboardKey.KEY_TAB;
		io.KeyMap[(int)ImGui.Key.LeftArrow] = (int)KeyboardKey.KEY_LEFT;
		io.KeyMap[(int)ImGui.Key.RightArrow] = (int)KeyboardKey.KEY_RIGHT;
		io.KeyMap[(int)ImGui.Key.UpArrow] = (int)KeyboardKey.KEY_UP;
		io.KeyMap[(int)ImGui.Key.DownArrow] = (int)KeyboardKey.KEY_DOWN;
		io.KeyMap[(int)ImGui.Key.PageUp] = (int)KeyboardKey.KEY_PAGE_DOWN;
		io.KeyMap[(int)ImGui.Key.PageDown] = (int)KeyboardKey.KEY_PAGE_UP;
		io.KeyMap[(int)ImGui.Key.Home] = (int)KeyboardKey.KEY_HOME;
		io.KeyMap[(int)ImGui.Key.End] = (int)KeyboardKey.KEY_END;
		io.KeyMap[(int)ImGui.Key.Insert] = (int)KeyboardKey.KEY_INSERT;
		io.KeyMap[(int)ImGui.Key.Delete] = (int)KeyboardKey.KEY_DELETE;
		io.KeyMap[(int)ImGui.Key.Backspace] = (int)KeyboardKey.KEY_BACKSPACE;
		io.KeyMap[(int)ImGui.Key.Space] = (int)KeyboardKey.KEY_SPACE;
		io.KeyMap[(int)ImGui.Key.Enter] = (int)KeyboardKey.KEY_ENTER;
		io.KeyMap[(int)ImGui.Key.Escape] = (int)KeyboardKey.KEY_ESCAPE;
		io.KeyMap[(int)ImGui.Key.KeypadEnter] = (int)KeyboardKey.KEY_KP_ENTER;
		io.KeyMap[(int)ImGui.Key.A] = (int)KeyboardKey.KEY_A;
		io.KeyMap[(int)ImGui.Key.C] = (int)KeyboardKey.KEY_C;
		io.KeyMap[(int)ImGui.Key.V] = (int)KeyboardKey.KEY_V;
		io.KeyMap[(int)ImGui.Key.X] = (int)KeyboardKey.KEY_X;
		io.KeyMap[(int)ImGui.Key.Y] = (int)KeyboardKey.KEY_Y;
		io.KeyMap[(int)ImGui.Key.Z] = (int)KeyboardKey.KEY_Z;

		io.MousePos = ImGui.Vec2(-float.MinValue, -float.MaxValue);

		ReloadFonts();

		return true;
	}

	public static void ImGui_ImplRaylib_UpdateMouseCursor()
	{
	    ImGui.IO* io = ImGui.GetIO();
	    if ((io.ConfigFlags & ImGui.ConfigFlags.NoMouseCursorChange) == 0)
	        return;

	    var imgui_cursor = ImGui.GetMouseCursor();
	    if (io.MouseDrawCursor || imgui_cursor == ImGui.MouseCursor.None)
	    {
	        Raylib.HideCursor();
	    }
	    else
	    {
	        Raylib.ShowCursor();
	    }
	}

	public static void ImGui_ImplRaylib_UpdateMousePosAndButtons()
	{
		ImGui.IO* io = ImGui.GetIO();

		if (io.WantSetMousePos)
		    Raylib.SetMousePosition((int32)io.MousePos.x, (int32)io.MousePos.y);
		else
		    io.MousePos = ImGui.Vec2(-float.MinValue, -float.MaxValue);

		io.MouseDown[0] = Raylib.IsMouseButtonDown((int32)MouseButton.MOUSE_BUTTON_LEFT);
		io.MouseDown[1] = Raylib.IsMouseButtonDown((int32)MouseButton.MOUSE_BUTTON_RIGHT);
		io.MouseDown[2] = Raylib.IsMouseButtonDown((int32)MouseButton.MOUSE_BUTTON_MIDDLE);

		if (!Raylib.IsWindowMinimized()){
		    io.MousePos = ImGui.Vec2(Raylib.GetTouchX(), Raylib.GetTouchY());
		}
	}

	public static void ImGui_ImplRaylib_NewFrame()
	{
		ImGui.IO* io = ImGui.GetIO();

	    io.DisplaySize = ImGui.Vec2((float)Raylib.GetScreenWidth(), (float)Raylib.GetScreenHeight());

	    double current_time = Raylib.GetTime();
	    io.DeltaTime = g_Time > 0.0 ? (float)(current_time - g_Time) : (float)(1.0f/60.0f);
	    g_Time = current_time;

	    io.KeyCtrl 	= Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_CONTROL) 	|| Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_CONTROL);
	    io.KeyShift = Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_SHIFT) 		|| Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_SHIFT);
	    io.KeyAlt 	= Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_ALT) 		|| Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_ALT);
	    io.KeySuper = Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_SUPER) 		|| Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_SUPER);

	    ImGui_ImplRaylib_UpdateMousePosAndButtons();
	    ImGui_ImplRaylib_UpdateMouseCursor();

	    if (Raylib.GetMouseWheelMove() > 0)
	        io.MouseWheel += 1;
	    else if (Raylib.GetMouseWheelMove() < 0)
	        io.MouseWheel -= 1;

		if ((io.ConfigFlags & ImGui.ConfigFlags.NoMouseCursorChange) == 0)
		{
		    var imgui_cursor = ImGui.GetMouseCursor();
		    if (imgui_cursor != currentMouseCursor || io.MouseDrawCursor)
		    {
		        currentMouseCursor = imgui_cursor;
		        if (io.MouseDrawCursor || imgui_cursor == ImGui.MouseCursor.None)
		        {
		            Raylib.HideCursor();
		        }
		        else
		        {
		            Raylib.ShowCursor();

		            if ((io.ConfigFlags & ImGui.ConfigFlags.NoMouseCursorChange) == 0)
		            {

		                if (!mouseCursorMap.ContainsKey(imgui_cursor))
		                    Raylib.SetMouseCursor((int32)MouseCursor.MOUSE_CURSOR_DEFAULT);
		                else
		                    Raylib.SetMouseCursor((int32)mouseCursorMap[imgui_cursor]);
		            }
		        }
		    }
		}

		FrameEvents();
	}

	private static void FrameEvents()
	{
	    var io = ImGui.GetIO();

	    // for (KeyboardKey key in keyEnumMap)
		for (var key = typeof(KeyboardKey).MinValue; key <= typeof(KeyboardKey).MaxValue; key++)
	    {
	        io.KeysDown[(int)key] = Raylib.IsKeyDown((int32)key);
	    }

	    var pressed = (uint32)Raylib.GetCharPressed();
	    while (pressed != 0)
	    {
	        io.AddInputCharacter((uint32)pressed);
	        pressed = (uint32)Raylib.GetCharPressed();
	    }
	}

	public static void draw_triangle_vertex(ImGui.DrawVert idx_vert)
	{
	    RaylibBeef.Color *c;
	    c = (RaylibBeef.Color *)&idx_vert.col;
	    Rlgl.rlColor4ub(c.r, c.g, c.b, c.a);
	    Rlgl.rlTexCoord2f(idx_vert.uv.x, idx_vert.uv.y);
	    Rlgl.rlVertex2f(idx_vert.pos.x, idx_vert.pos.y);
	}

	public static void raylib_render_draw_triangles(uint count, ImGui.DrawIdx *idx_buffer, ImGui.DrawVert *idx_vert, uint texture_id)
	{
	    // Draw the imgui triangle data
	    for (uint i = 0; i <= (count - 3); i += 3)
	    {
	        Rlgl.rlPushMatrix();
	        Rlgl.rlBegin(Rlgl.RL_TRIANGLES);
	        Rlgl.rlSetTexture((int32)texture_id);

	        ImGui.DrawIdx index;
	        ImGui.DrawVert vertex;

	        index = idx_buffer[i];
	        vertex = idx_vert[index];
	        draw_triangle_vertex(vertex);

	        index = idx_buffer[i + 2];
	        vertex = idx_vert[index];
	        draw_triangle_vertex(vertex);

	        index = idx_buffer[i + 1];
	        vertex = idx_vert[index];
	        draw_triangle_vertex(vertex);
	        Rlgl.rlSetTexture(0);
	        Rlgl.rlEnd();
	        Rlgl.rlPopMatrix();
	    }
	}

	
	public static void raylib_render_cimgui(ImGui.DrawData *draw_data)
	{
		// Rlgl.rlDrawRenderBatchActive();
	    Rlgl.rlDisableBackfaceCulling();
	    for (int n = 0; n < draw_data.CmdListsCount; n++)
	    {
	        ImGui.DrawList *cmd_list = draw_data.CmdLists[n];
	        ImGui.DrawVert *vtx_buffer = cmd_list.VtxBuffer.Data; // vertex buffer generated by Dear ImGui
	        ImGui.DrawIdx *idx_buffer = cmd_list.IdxBuffer.Data;  // index buffer generated by Dear ImGui
	        for (int cmd_i = 0; cmd_i < cmd_list.CmdBuffer.Size; cmd_i++)
	        {
	            ImGui.DrawCmd *pcmd = &(cmd_list.CmdBuffer.Data)[cmd_i]; // cmd_list->CmdBuffer->data[cmd_i];
	            if (pcmd.UserCallback != 0)
	            {
	                pcmd.UserCallback(cmd_list, pcmd);
	            }
	            else
	            {
	                ImGui.Vec2 pos = draw_data.DisplayPos;
	                int rectX = (int)(pcmd.ClipRect.x - pos.x);
	                int rectY = (int)(pcmd.ClipRect.y - pos.y);
	                int rectW = (int)(pcmd.ClipRect.z - rectX);
	                int rectH = (int)(pcmd.ClipRect.w - rectY);
	                Raylib.BeginScissorMode((int32)rectX, (int32)rectY, (int32)rectW, (int32)rectH);
	                {
	                    uint *ti = (uint*)pcmd.TextureId;
						var ta = &ti;
	                    raylib_render_draw_triangles(pcmd.ElemCount, idx_buffer, vtx_buffer, *ti);

						// Rlgl.rlDrawRenderBatchActive();
	                }
	            }
	            idx_buffer += pcmd.ElemCount;
	        }
	    }
	    Raylib.EndScissorMode();
	    Rlgl.rlEnableBackfaceCulling();
		// Rlgl.rlDisableScissorTest();
	}
}