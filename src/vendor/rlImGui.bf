using ImGui;
using System.Collections;
using RaylibBeef;
using System;

namespace ImGui
{
	public extension ImGui
	{
		public extension Vector<T>
		{
			public T this[int index]
			{
				get
				{
					var a = sizeof(T);
					var b = Data + index * sizeof(T);
					return *b;
				}
			}
		}
	}
}

namespace FantyEngine;

public static class rlImGui
{
    internal static ImGui.Context* ImGuiContext;

    private static ImGui.MouseCursor CurrentMouseCursor = ImGui.MouseCursor.COUNT;
    private static Dictionary<ImGui.MouseCursor, MouseCursor> MouseCursorMap ~ if (_ != null) delete _;
    private static Texture2D FontTexture;

    static Dictionary<KeyboardKey, ImGui.Key> RaylibKeyMap = new .() ~ if (_ != null) delete _;

    internal static bool LastFrameFocused = false;

    internal static bool LastControlPressed = false;
    internal static bool LastShiftPressed = false;
    internal static bool LastAltPressed = false;
    internal static bool LastSuperPressed = false;

    internal static bool rlImGuiIsControlDown() { return Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_CONTROL) || Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_CONTROL); }
    internal static bool rlImGuiIsShiftDown() { return Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_SHIFT) || Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_SHIFT); }
    internal static bool rlImGuiIsAltDown() { return Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_ALT) || Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_ALT); }
    internal static bool rlImGuiIsSuperDown() { return Raylib.IsKeyDown((int32)KeyboardKey.KEY_RIGHT_SUPER) || Raylib.IsKeyDown((int32)KeyboardKey.KEY_LEFT_SUPER); }

    public delegate void SetupUserFontsCallback(ImGui.IO* imGuiIo);

    /// <summary>
    /// Callback for cases where the user wants to install additional fonts.
    /// </summary>
    public static SetupUserFontsCallback SetupUserFonts = null;

    /// <summary>
    /// Sets up ImGui, loads fonts and themes
    /// </summary>
    /// <param name="darkTheme">when true(default) the dark theme is used, when false the light theme is used</param>
    /// <param name="enableDocking">when true(not default) docking support will be enabled/param>
    public static void Setup(bool darkTheme = true, bool enableDocking = false)
    {
        MouseCursorMap = new Dictionary<ImGui.MouseCursor, MouseCursor>();

        LastFrameFocused = Raylib.IsWindowFocused();
        LastControlPressed = false;
        LastShiftPressed = false;
        LastAltPressed = false;
        LastSuperPressed = false;

        FontTexture.id = 0;

        BeginInitImGui();

        if (darkTheme)
            ImGui.StyleColorsDark();
        else
            ImGui.StyleColorsLight();

        if (enableDocking)
            ImGui.GetIO().ConfigFlags |= ImGui.ConfigFlags.DockingEnable;

        EndInitImGui();
    }

    /// <summary>
    /// Custom initialization. Not needed if you call Setup. Only needed if you want to add custom setup code.
    /// must be followed by EndInitImGui
    /// </summary>
    public static void BeginInitImGui()
    {
        SetupKeymap();

        ImGuiContext = ImGui.CreateContext();
    }

    internal static void SetupKeymap()
    {
        if (RaylibKeyMap.Count > 0)
            return;

        // build up a map of raylib keys to ImGui.Keys
        RaylibKeyMap[KeyboardKey.KEY_APOSTROPHE] = ImGui.Key.Apostrophe;
        RaylibKeyMap[KeyboardKey.KEY_COMMA] = ImGui.Key.Comma;
        RaylibKeyMap[KeyboardKey.KEY_MINUS] = ImGui.Key.Minus;
        RaylibKeyMap[KeyboardKey.KEY_PERIOD] = ImGui.Key.Period;
        RaylibKeyMap[KeyboardKey.KEY_SLASH] = ImGui.Key.Slash;
        RaylibKeyMap[KeyboardKey.KEY_ZERO] = ImGui.Key.N0;
        RaylibKeyMap[KeyboardKey.KEY_ONE] = ImGui.Key.N1;
        RaylibKeyMap[KeyboardKey.KEY_TWO] = ImGui.Key.N2;
        RaylibKeyMap[KeyboardKey.KEY_THREE] = ImGui.Key.N3;
        RaylibKeyMap[KeyboardKey.KEY_FOUR] = ImGui.Key.N4;
        RaylibKeyMap[KeyboardKey.KEY_FIVE] = ImGui.Key.N5;
        RaylibKeyMap[KeyboardKey.KEY_SIX] = ImGui.Key.N6;
        RaylibKeyMap[KeyboardKey.KEY_SEVEN] = ImGui.Key.N7;
        RaylibKeyMap[KeyboardKey.KEY_EIGHT] = ImGui.Key.N8;
        RaylibKeyMap[KeyboardKey.KEY_NINE] = ImGui.Key.N9;
        RaylibKeyMap[KeyboardKey.KEY_SEMICOLON] = ImGui.Key.Semicolon;
        RaylibKeyMap[KeyboardKey.KEY_EQUAL] = ImGui.Key.Equal;
        RaylibKeyMap[KeyboardKey.KEY_A] = ImGui.Key.A;
        RaylibKeyMap[KeyboardKey.KEY_B] = ImGui.Key.B;
        RaylibKeyMap[KeyboardKey.KEY_C] = ImGui.Key.C;
        RaylibKeyMap[KeyboardKey.KEY_D] = ImGui.Key.D;
        RaylibKeyMap[KeyboardKey.KEY_E] = ImGui.Key.E;
        RaylibKeyMap[KeyboardKey.KEY_F] = ImGui.Key.F;
        RaylibKeyMap[KeyboardKey.KEY_G] = ImGui.Key.G;
        RaylibKeyMap[KeyboardKey.KEY_H] = ImGui.Key.H;
        RaylibKeyMap[KeyboardKey.KEY_I] = ImGui.Key.I;
        RaylibKeyMap[KeyboardKey.KEY_J] = ImGui.Key.J;
        RaylibKeyMap[KeyboardKey.KEY_K] = ImGui.Key.K;
        RaylibKeyMap[KeyboardKey.KEY_L] = ImGui.Key.L;
        RaylibKeyMap[KeyboardKey.KEY_M] = ImGui.Key.M;
        RaylibKeyMap[KeyboardKey.KEY_N] = ImGui.Key.N;
        RaylibKeyMap[KeyboardKey.KEY_O] = ImGui.Key.O;
        RaylibKeyMap[KeyboardKey.KEY_P] = ImGui.Key.P;
        RaylibKeyMap[KeyboardKey.KEY_Q] = ImGui.Key.Q;
        RaylibKeyMap[KeyboardKey.KEY_R] = ImGui.Key.R;
        RaylibKeyMap[KeyboardKey.KEY_S] = ImGui.Key.S;
        RaylibKeyMap[KeyboardKey.KEY_T] = ImGui.Key.T;
        RaylibKeyMap[KeyboardKey.KEY_U] = ImGui.Key.U;
        RaylibKeyMap[KeyboardKey.KEY_V] = ImGui.Key.V;
        RaylibKeyMap[KeyboardKey.KEY_W] = ImGui.Key.W;
        RaylibKeyMap[KeyboardKey.KEY_X] = ImGui.Key.X;
        RaylibKeyMap[KeyboardKey.KEY_Y] = ImGui.Key.Y;
        RaylibKeyMap[KeyboardKey.KEY_Z] = ImGui.Key.Z;
        RaylibKeyMap[KeyboardKey.KEY_SPACE] = ImGui.Key.Space;
        RaylibKeyMap[KeyboardKey.KEY_ESCAPE] = ImGui.Key.Escape;
        RaylibKeyMap[KeyboardKey.KEY_ENTER] = ImGui.Key.Enter;
        RaylibKeyMap[KeyboardKey.KEY_TAB] = ImGui.Key.Tab;
        RaylibKeyMap[KeyboardKey.KEY_BACKSPACE] = ImGui.Key.Backspace;
        RaylibKeyMap[KeyboardKey.KEY_INSERT] = ImGui.Key.Insert;
        RaylibKeyMap[KeyboardKey.KEY_DELETE] = ImGui.Key.Delete;
        RaylibKeyMap[KeyboardKey.KEY_RIGHT] = ImGui.Key.RightArrow;
        RaylibKeyMap[KeyboardKey.KEY_LEFT] = ImGui.Key.LeftArrow;
        RaylibKeyMap[KeyboardKey.KEY_DOWN] = ImGui.Key.DownArrow;
        RaylibKeyMap[KeyboardKey.KEY_UP] = ImGui.Key.UpArrow;
        RaylibKeyMap[KeyboardKey.KEY_PAGE_UP] = ImGui.Key.PageUp;
        RaylibKeyMap[KeyboardKey.KEY_PAGE_DOWN] = ImGui.Key.PageDown;
        RaylibKeyMap[KeyboardKey.KEY_HOME] = ImGui.Key.Home;
        RaylibKeyMap[KeyboardKey.KEY_END] = ImGui.Key.End;
        RaylibKeyMap[KeyboardKey.KEY_CAPS_LOCK] = ImGui.Key.CapsLock;
        RaylibKeyMap[KeyboardKey.KEY_SCROLL_LOCK] = ImGui.Key.ScrollLock;
        RaylibKeyMap[KeyboardKey.KEY_NUM_LOCK] = ImGui.Key.NumLock;
        RaylibKeyMap[KeyboardKey.KEY_PRINT_SCREEN] = ImGui.Key.PrintScreen;
        RaylibKeyMap[KeyboardKey.KEY_PAUSE] = ImGui.Key.Pause;
        RaylibKeyMap[KeyboardKey.KEY_F1] = ImGui.Key.F1;
        RaylibKeyMap[KeyboardKey.KEY_F2] = ImGui.Key.F2;
        RaylibKeyMap[KeyboardKey.KEY_F3] = ImGui.Key.F3;
        RaylibKeyMap[KeyboardKey.KEY_F4] = ImGui.Key.F4;
        RaylibKeyMap[KeyboardKey.KEY_F5] = ImGui.Key.F5;
        RaylibKeyMap[KeyboardKey.KEY_F6] = ImGui.Key.F6;
        RaylibKeyMap[KeyboardKey.KEY_F7] = ImGui.Key.F7;
        RaylibKeyMap[KeyboardKey.KEY_F8] = ImGui.Key.F8;
        RaylibKeyMap[KeyboardKey.KEY_F9] = ImGui.Key.F9;
        RaylibKeyMap[KeyboardKey.KEY_F10] = ImGui.Key.F10;
        RaylibKeyMap[KeyboardKey.KEY_F11] = ImGui.Key.F11;
        RaylibKeyMap[KeyboardKey.KEY_F12] = ImGui.Key.F12;
        RaylibKeyMap[KeyboardKey.KEY_LEFT_SHIFT] = ImGui.Key.LeftShift;
        RaylibKeyMap[KeyboardKey.KEY_LEFT_CONTROL] = ImGui.Key.LeftCtrl;
        RaylibKeyMap[KeyboardKey.KEY_LEFT_ALT] = ImGui.Key.LeftAlt;
        RaylibKeyMap[KeyboardKey.KEY_LEFT_SUPER] = ImGui.Key.LeftSuper;
        RaylibKeyMap[KeyboardKey.KEY_RIGHT_SHIFT] = ImGui.Key.RightShift;
        RaylibKeyMap[KeyboardKey.KEY_RIGHT_CONTROL] = ImGui.Key.RightCtrl;
        RaylibKeyMap[KeyboardKey.KEY_RIGHT_ALT] = ImGui.Key.RightAlt;
        RaylibKeyMap[KeyboardKey.KEY_RIGHT_SUPER] = ImGui.Key.RightSuper;
        RaylibKeyMap[KeyboardKey.KEY_KB_MENU] = ImGui.Key.Menu;
        RaylibKeyMap[KeyboardKey.KEY_LEFT_BRACKET] = ImGui.Key.LeftBracket;
        RaylibKeyMap[KeyboardKey.KEY_BACKSLASH] = ImGui.Key.Backslash;
        RaylibKeyMap[KeyboardKey.KEY_RIGHT_BRACKET] = ImGui.Key.RightBracket;
        RaylibKeyMap[KeyboardKey.KEY_GRAVE] = ImGui.Key.GraveAccent;
        RaylibKeyMap[KeyboardKey.KEY_KP_0] = ImGui.Key.Keypad0;
        RaylibKeyMap[KeyboardKey.KEY_KP_1] = ImGui.Key.Keypad1;
        RaylibKeyMap[KeyboardKey.KEY_KP_2] = ImGui.Key.Keypad2;
        RaylibKeyMap[KeyboardKey.KEY_KP_3] = ImGui.Key.Keypad3;
        RaylibKeyMap[KeyboardKey.KEY_KP_4] = ImGui.Key.Keypad4;
        RaylibKeyMap[KeyboardKey.KEY_KP_5] = ImGui.Key.Keypad5;
        RaylibKeyMap[KeyboardKey.KEY_KP_6] = ImGui.Key.Keypad6;
        RaylibKeyMap[KeyboardKey.KEY_KP_7] = ImGui.Key.Keypad7;
        RaylibKeyMap[KeyboardKey.KEY_KP_8] = ImGui.Key.Keypad8;
        RaylibKeyMap[KeyboardKey.KEY_KP_9] = ImGui.Key.Keypad9;
        RaylibKeyMap[KeyboardKey.KEY_KP_DECIMAL] = ImGui.Key.KeypadDecimal;
        RaylibKeyMap[KeyboardKey.KEY_KP_DIVIDE] = ImGui.Key.KeypadDivide;
        RaylibKeyMap[KeyboardKey.KEY_KP_MULTIPLY] = ImGui.Key.KeypadMultiply;
        RaylibKeyMap[KeyboardKey.KEY_KP_SUBTRACT] = ImGui.Key.KeypadSubtract;
        RaylibKeyMap[KeyboardKey.KEY_KP_ADD] = ImGui.Key.KeypadAdd;
        RaylibKeyMap[KeyboardKey.KEY_KP_ENTER] = ImGui.Key.KeypadEnter;
        RaylibKeyMap[KeyboardKey.KEY_KP_EQUAL] = ImGui.Key.KeypadEqual;
    }

    private static void SetupMouseCursors()
    {
        MouseCursorMap.Clear();
        MouseCursorMap[ImGui.MouseCursor.Arrow] = MouseCursor.MOUSE_CURSOR_ARROW;
        MouseCursorMap[ImGui.MouseCursor.TextInput] = MouseCursor.MOUSE_CURSOR_IBEAM;
        MouseCursorMap[ImGui.MouseCursor.Hand] = MouseCursor.MOUSE_CURSOR_POINTING_HAND;
        MouseCursorMap[ImGui.MouseCursor.ResizeAll] = MouseCursor.MOUSE_CURSOR_RESIZE_ALL;
        MouseCursorMap[ImGui.MouseCursor.ResizeEW] = MouseCursor.MOUSE_CURSOR_RESIZE_EW;
        MouseCursorMap[ImGui.MouseCursor.ResizeNESW] = MouseCursor.MOUSE_CURSOR_RESIZE_NESW;
        MouseCursorMap[ImGui.MouseCursor.ResizeNS] = MouseCursor.MOUSE_CURSOR_RESIZE_NS;
        MouseCursorMap[ImGui.MouseCursor.ResizeNWSE] = MouseCursor.MOUSE_CURSOR_RESIZE_NWSE;
        MouseCursorMap[ImGui.MouseCursor.NotAllowed] = MouseCursor.MOUSE_CURSOR_NOT_ALLOWED;
    }

    /// <summary>
    /// Forces the font texture atlas to be recomputed and re-cached
    /// </summary>
    public static void ReloadFonts()
    {
        ImGui.SetCurrentContext(ImGuiContext);
        var io = ImGui.GetIO();

        int32 width, height, bytesPerPixel;
		uint8* pixels;
        io.Fonts.GetTexDataAsRGBA32(out pixels, out width, out height, &bytesPerPixel);

        let image = Image
        {
            data = pixels,
            width = width,
            height = height,
            mipmaps = 1,
            format = (int32)PixelFormat.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,
        };

        if (Raylib.IsTextureReady(FontTexture))
            Raylib.UnloadTexture(FontTexture);

        FontTexture = Raylib.LoadTextureFromImage(image);

        io.Fonts.SetTexID(Internal.UnsafeCastToPtr(FontTexture.id));
    }

    internal static char8* rImGuiGetClipText(void* userData)
    {
        return Raylib.GetClipboardText();
    }

    internal static void rlImGuiSetClipText(void* userData, char8* text)
    {
        Raylib.SetClipboardText(text);
    }

    private delegate char8* GetClipTextCallback(void* userData);
    private delegate void SetClipTextCallback(void* userData, char8* text);

    /// <summary>
    /// End Custom initialization. Not needed if you call Setup. Only needed if you want to add custom setup code.
    /// must be proceeded by BeginInitImGui
    /// </summary>
    public static void EndInitImGui()
    {
        SetupMouseCursors();

        ImGui.SetCurrentContext(ImGuiContext);

        var fonts = ImGui.GetIO().Fonts;
        ImGui.GetIO().Fonts.AddFontDefault();

        // remove this part if you don't want font awesome
        /*unsafe
        {
            ImFontConfig icons_config = new ImFontConfig();
            icons_config.MergeMode = 1;                      // merge the glyph ranges into the default font
            icons_config.PixelSnapH = 1;                     // don't try to render on partial pixels
            icons_config.FontDataOwnedByAtlas = 0;           // the font atlas does not own this font data

            icons_config.GlyphMaxAdvanceX = float.MaxValue;
            icons_config.RasterizerMultiply = 1.0f;
            icons_config.OversampleH = 2;
            icons_config.OversampleV = 1;

            ushort[] IconRanges = new ushort[3];
            IconRanges[0] = IconFonts.FontAwesome6.IconMin;
            IconRanges[1] = IconFonts.FontAwesome6.IconMax;
            IconRanges[2] = 0;

            fixed (ushort* range = &IconRanges[0])
            {
                // this unmanaged memory must remain allocated for the entire run of rlImgui
                IconFonts.FontAwesome6.IconFontRanges = Marshal.AllocHGlobal(6);
                Buffer.MemoryCopy(range, IconFonts.FontAwesome6.IconFontRanges.ToPointer(), 6, 6);
                icons_config.GlyphRanges = (ushort*)IconFonts.FontAwesome6.IconFontRanges.ToPointer();

                byte[] fontDataBuffer = Convert.FromBase64String(IconFonts.FontAwesome6.IconFontData);

                fixed (byte* buffer = fontDataBuffer)
                {
                    ImGui.GetIO().Fonts.AddFontFromMemoryTTF(new IntPtr(buffer), fontDataBuffer.Length, 11, &icons_config);
                }
            }
        }
		*/

        let io = ImGui.GetIO();

        if (SetupUserFonts != null)
            SetupUserFonts(io);

        io.BackendFlags |= ImGui.BackendFlags.HasMouseCursors;

        io.MousePos.x = 0;
        io.MousePos.y = 0;

        // copy/paste callbacks
        {
			/*
            var getClip = new GetClipTextCallback(rImGuiGetClipText);
            var setClip = new SetClipTextCallback(rlImGuiSetClipText);

            io.SetClipboardTextFn = Marshal.GetFunctionPointerForDelegate(setClip);
            io.GetClipboardTextFn = Marshal.GetFunctionPointerForDelegate(getClip);
			*/
        }

        io.ClipboardUserData = null;
        ReloadFonts();
    }

    private static void NewFrame(float dt = -1)
    {
        let io = ImGui.GetIO();

        if (Raylib.IsWindowFullscreen())
        {
            let monitor = Raylib.GetCurrentMonitor();
            io.DisplaySize = .(Raylib.GetMonitorWidth(monitor), Raylib.GetMonitorHeight(monitor));
        }
        else
        {
            io.DisplaySize = .(Raylib.GetScreenWidth(), Raylib.GetScreenHeight());
        }

        int width = Rlgl.rlGetFramebufferWidth();
        int height = Rlgl.rlGetFramebufferHeight();
        if (width > 0 && height > 0)
        {
            io.DisplayFramebufferScale = .(width / io.DisplaySize.y, height / io.DisplaySize.y);
        }
        else
        {
            io.DisplayFramebufferScale = .(1.0f, 1.0f);
        }

        io.DeltaTime = dt >= 0 ? dt : Raylib.GetFrameTime();

        if (io.WantSetMousePos)
        {
            Raylib.SetMousePosition((int32)io.MousePos.x, (int32)io.MousePos.y);
        }
        else
        {
            io.MousePos = .(Raylib.GetMousePosition().x, Raylib.GetMousePosition().y);
        }

        io.MouseDown[0] = Raylib.IsMouseButtonDown((int32)MouseButton.MOUSE_BUTTON_LEFT);
        io.MouseDown[1] = Raylib.IsMouseButtonDown((int32)MouseButton.MOUSE_BUTTON_RIGHT);
        io.MouseDown[2] = Raylib.IsMouseButtonDown((int32)MouseButton.MOUSE_BUTTON_MIDDLE);

        if (Raylib.GetMouseWheelMove() > 0)
            io.MouseWheel += 1;
        else if (Raylib.GetMouseWheelMove() < 0)
            io.MouseWheel -= 1;

        if ((io.ConfigFlags & ImGui.ConfigFlags.NoMouseCursorChange) == 0)
        {
            ImGui.MouseCursor imgui_cursor = ImGui.GetMouseCursor();
            if (imgui_cursor != CurrentMouseCursor || io.MouseDrawCursor)
            {
                CurrentMouseCursor = imgui_cursor;
                if (io.MouseDrawCursor || imgui_cursor == ImGui.MouseCursor.None)
                {
                    Raylib.HideCursor();
                }
                else
                {
                    Raylib.ShowCursor();

                    if ((io.ConfigFlags & ImGui.ConfigFlags.NoMouseCursorChange) == 0)
                    {

                        if (!MouseCursorMap.ContainsKey(imgui_cursor))
                            Raylib.SetMouseCursor((int32)MouseCursor.MOUSE_CURSOR_DEFAULT);
                        else
                            Raylib.SetMouseCursor((int32)MouseCursorMap[imgui_cursor]);
                    }
                }
            }
        }
    }

    private static void FrameEvents()
    {
        let io = ImGui.GetIO();

        bool focused = Raylib.IsWindowFocused();
        if (focused != LastFrameFocused)
            io.AddFocusEvent(focused);
        LastFrameFocused = focused;


        // handle the modifyer key events so that shortcuts work
        bool ctrlDown = rlImGuiIsControlDown();
        if (ctrlDown != LastControlPressed)
            io.AddKeyEvent(ImGui.Key.Mod_Ctrl, ctrlDown);
        LastControlPressed = ctrlDown;

        bool shiftDown = rlImGuiIsShiftDown();
        if (shiftDown != LastShiftPressed)
            io.AddKeyEvent(ImGui.Key.Mod_Shift, shiftDown);
        LastShiftPressed = shiftDown;

        bool altDown = rlImGuiIsAltDown();
        if (altDown != LastAltPressed)
            io.AddKeyEvent(ImGui.Key.Mod_Alt, altDown);
        LastAltPressed = altDown;

        bool superDown = rlImGuiIsSuperDown();
        if (superDown != LastSuperPressed)
            io.AddKeyEvent(ImGui.Key.Mod_Super, superDown);
        LastSuperPressed = superDown;

        // get the pressed keys, they are in event order
        int keyId = Raylib.GetKeyPressed();
        while (keyId != 0)
        {
            KeyboardKey key = (KeyboardKey)keyId;
            if (RaylibKeyMap.ContainsKey(key))
                io.AddKeyEvent(RaylibKeyMap[key], true);
            keyId = Raylib.GetKeyPressed();
        }

        for (var keyItr in RaylibKeyMap)
            io.KeysData[(int)keyItr.value].Down = (Raylib.IsKeyDown((int32)keyItr.key) ? true : false);

        // look for any keys that were down last frame and see if they were down and are released
        for (var keyItr in RaylibKeyMap)
        {
            if (Raylib.IsKeyReleased((int32)keyItr.key))
                io.AddKeyEvent(keyItr.value, false);
        }

        // add the text input in order
        var pressed = Raylib.GetCharPressed();
        while (pressed != 0)
        {
            io.AddInputCharacter((uint32)pressed);
            pressed = Raylib.GetCharPressed();
        }
    }
    /// <summary>
    /// Starts a new ImGui Frame
    /// </summary>
    /// <param name="dt">optional delta time, any value < 0 will use raylib GetFrameTime</param>
    public static void Begin(float dt = -1)
    {
        ImGui.SetCurrentContext(ImGuiContext);

        NewFrame(dt);
        FrameEvents();
        ImGui.NewFrame();
    }

    private static void EnableScissor(float x, float y, float width, float height)
    {
        Rlgl.rlEnableScissorTest();
        Rlgl.rlScissor((int32)x, Raylib.GetScreenHeight() - (int32)(y + height), (int32)width, (int32)height);
    }

    private static void TriangleVert(ImGui.DrawVert* idx_vert)
    {
        let color = ImGui.ColorConvertU32ToFloat4(idx_vert.col);

        Rlgl.rlColor4f(color.x, color.y, color.z, color.w);
        Rlgl.rlTexCoord2f(idx_vert.uv.x, idx_vert.uv.y);
        Rlgl.rlVertex2f(idx_vert.pos.x, idx_vert.pos.y);
    }

    private static void RenderTriangles(uint32 count, uint32 indexStart, ImGui.Vector<ImGui.DrawIdx> indexBuffer, ImGui.Vector<ImGui.DrawVert> vertBuffer, void* texturePtr)
    {
        if (count < 3)
            return;

        int32 textureId = 0;
        if (texturePtr != null)
		{

            // textureId = (int32)Internal.UnsafeCastToObject(texturePtr);
		}
        Rlgl.rlBegin(Rlgl.RL_TRIANGLES);
        Rlgl.rlSetTexture(textureId);

        for (int i = 0; i <= (count - 3); i += 3)
        {
            if (Rlgl.rlCheckRenderBatchLimit(3))
            {
                Rlgl.rlBegin(Rlgl.RL_TRIANGLES);
                Rlgl.rlSetTexture(textureId);
            }

            let indexA = indexBuffer[(int)indexStart + i];
            let indexB = indexBuffer[(int)indexStart + i + 1];
            let indexC = indexBuffer[(int)indexStart + i + 2];

            var vertexA = vertBuffer[indexA];
            var vertexB = vertBuffer[indexB];
            var vertexC = vertBuffer[indexC];

            TriangleVert(&vertexA);
            TriangleVert(&vertexB);
            TriangleVert(&vertexC);
        }
        Rlgl.rlEnd();
    }

    private delegate void Callback(ImGui.DrawList* list, ImGui.DrawCmd* cmd);

    private static void RenderData()
    {
        Rlgl.rlDrawRenderBatchActive();
        Rlgl.rlDisableBackfaceCulling();

        var data = ImGui.GetDrawData();

        for (int l = 0; l < data.CmdListsCount; l++)
        {
            var commandList = data.CmdLists[l];

            for (int cmdIndex = 0; cmdIndex < commandList.CmdBuffer.Size; cmdIndex++)
            {
				let cmd = commandList.CmdBuffer[l];

                EnableScissor(cmd.ClipRect.x - data.DisplayPos.x, cmd.ClipRect.y - data.DisplayPos.y, cmd.ClipRect.z - (cmd.ClipRect.x - data.DisplayPos.x), cmd.ClipRect.w - (cmd.ClipRect.y - data.DisplayPos.y));
                if (cmd.UserCallback != null)
                {
                    // Callback cb = Marshal.GetDelegateForFunctionPointer<Callback>(cmd.UserCallback);
                    // cb(commandList, cmd);
                    continue;
                }

                RenderTriangles(cmd.ElemCount, cmd.IdxOffset, commandList.IdxBuffer, commandList.VtxBuffer, cmd.TextureId);

                Rlgl.rlDrawRenderBatchActive();
            }
        }
        Rlgl.rlSetTexture(0);
        Rlgl.rlDisableScissorTest();
        Rlgl.rlEnableBackfaceCulling();
    }

    /// <summary>
    /// Ends an ImGui frame and submits all ImGui drawing to raylib for processing.
    /// </summary>
    public static void End()
    {
        ImGui.SetCurrentContext(ImGuiContext);
        ImGui.Render();
        RenderData();
    }

    /// <summary>
    /// Cleanup ImGui and unload font atlas
    /// </summary>
    public static void Shutdown()
    {
        Raylib.UnloadTexture(FontTexture);
        ImGui.DestroyContext();

        // remove this if you don't want font awesome support
        /*{
            if (IconFonts.FontAwesome6.IconFontRanges != IntPtr.Zero)
                Marshal.FreeHGlobal(IconFonts.FontAwesome6.IconFontRanges);

            IconFonts.FontAwesome6.IconFontRanges = IntPtr.Zero;
        }*/
    }

    /// <summary>
    /// Draw a texture as an image in an ImGui Context
    /// Uses the current ImGui Cursor position and the full texture size.
    /// </summary>
    /// <param name="image">The raylib texture to draw</param>
    public static void Image(Texture2D image)
    {
        ImGui.Image(Internal.UnsafeCastToPtr(image.id), .(image.width, image.height));
    }

    /// <summary>
    /// Draw a texture as an image in an ImGui Context at a specific size
    /// Uses the current ImGui Cursor position and the specified width and height
    /// The image will be scaled up or down to fit as needed
    /// </summary>
    /// <param name="image">The raylib texture to draw</param>
    /// <param name="width">The width of the drawn image</param>
    /// <param name="height">The height of the drawn image</param>
    public static void ImageSize(Texture2D image, int width, int height)
    {
        ImGui.Image(Internal.UnsafeCastToPtr(image.id), .(width, height));
    }

    /// <summary>
    /// Draw a texture as an image in an ImGui Context at a specific size
    /// Uses the current ImGui Cursor position and the specified size
    /// The image will be scaled up or down to fit as needed
    /// </summary>
    /// <param name="image">The raylib texture to draw</param>
    /// <param name="size">The size of drawn image</param>
    public static void ImageSize(Texture2D image, RaylibBeef.Vector2 size)
    {
        ImGui.Image(Internal.UnsafeCastToPtr(image.id), .(size.x, size.y));
    }

    /// <summary>
    /// Draw a portion texture as an image in an ImGui Context at a defined size
    /// Uses the current ImGui Cursor position and the specified size
    /// The image will be scaled up or down to fit as needed
    /// </summary>
    /// <param name="image">The raylib texture to draw</param>
    /// <param name="destWidth">The width of the drawn image</param>
    /// <param name="destHeight">The height of the drawn image</param>
    /// <param name="sourceRect">The portion of the texture to draw as an image. Negative values for the width and height will flip the image</param>
    public static void ImageRect(Texture2D image, int destWidth, int destHeight, RaylibBeef.Rectangle sourceRect)
    {
        var uv0 = Vector2();
        var uv1 = Vector2();

        if (sourceRect.width < 0)
        {
            uv0.x = -((float)sourceRect.x / image.width);
            uv1.x = (uv0.x - (float)(Math.Abs(sourceRect.width) / image.width));
        }
        else
        {
            uv0.x = (float)sourceRect.x / image.width;
            uv1.x = uv0.x + (float)(sourceRect.width / image.width);
        }

        if (sourceRect.height < 0)
        {
            uv0.y = -((float)sourceRect.y / image.height);
            uv1.y = (uv0.y - (float)(Math.Abs(sourceRect.height) / image.height));
        }
        else
        {
            uv0.y = (float)sourceRect.y / image.height;
            uv1.y = uv0.y + (float)(sourceRect.height / image.height);
        }

        ImGui.Image(Internal.UnsafeCastToPtr(image.id), .(destWidth, destHeight), .(uv0.x, uv0.y), .(uv1.x, uv1.y));
    }

    /// <summary>
    /// Draws a render texture as an image an ImGui Context, automatically flipping the Y axis so it will show correctly on screen
    /// </summary>
    /// <param name="image">The render texture to draw</param>
    public static void ImageRenderTexture(RenderTexture2D image)
    {
        ImageRect(image.texture, image.texture.width, image.texture.height, .(0, 0, image.texture.width, -image.texture.height));
    }

    /// <summary>
    /// Draws a render texture as an image to the current ImGui Context, flipping the Y axis so it will show correctly on the screen
    /// The texture will be scaled to fit the content are available, centered if desired
    /// </summary>
    /// <param name="image">The render texture to draw</param>
    /// <param name="center">When true the texture will be centered in the content area. When false the image will be left and top justified</param>
    public static void ImageRenderTextureFit(RenderTexture2D image, bool center = true)
    {
        let area = ImGui.GetContentRegionAvail();

        float scale = area.x / image.texture.width;

        float y = image.texture.height * scale;
        if (y > area.y)
        {
            scale = area.y / image.texture.height;
        }

        int sizeX = (int)(image.texture.width * scale);
        int sizeY = (int)(image.texture.height * scale);

        if (center)
        {
            ImGui.SetCursorPosX(0);
            ImGui.SetCursorPosX(area.x / 2 - sizeX / 2);
            ImGui.SetCursorPosY(ImGui.GetCursorPosY() + (area.y / 2 - sizeY / 2));
        }

        ImageRect(image.texture, sizeX, sizeY, .(0,0, (image.texture.width), -(image.texture.height) ));
    }

    /// <summary>
    /// Draws a texture as an image button in an ImGui context. Uses the current ImGui cursor position and the full size of the texture
    /// </summary>
    /// <param name="name">The display name and ImGui ID for the button</param>
    /// <param name="image">The texture to draw</param>
    /// <returns>True if the button was clicked</returns>
    public static bool ImageButton(System.String name, Texture2D image)
    {
        return ImageButtonSize(name, image, .(image.width, image.height));
    }

    /// <summary>
    /// Draws a texture as an image button in an ImGui context. Uses the current ImGui cursor position and the specified size.
    /// </summary>
    /// <param name="name">The display name and ImGui ID for the button</param>
    /// <param name="image">The texture to draw</param>
    /// <param name="size">The size of the button/param>
    /// <returns>True if the button was clicked</returns>
    public static bool ImageButtonSize(System.String name, Texture2D image, RaylibBeef.Vector2 size)
    {
        return ImGui.ImageButton(name, Internal.UnsafeCastToPtr(image.id), .(size.x, size.y));
    }

}