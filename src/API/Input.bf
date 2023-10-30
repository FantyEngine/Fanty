namespace FantyEngine;

public enum KeyCode
{
	/// Key: NULL, used for no key pressed
	Null = 0,
	/// Key: '
	Apostrophe = 39,
	/// Key: ,
	Comma = 44,
	/// Key: -
	Minus = 45,
	/// Key: .
	Period = 46,
	/// Key: /
	Slash = 47,
	/// Key: 0
	Zero = 48,
	/// Key: 1
	One = 49,
	/// Key: 2
	Two = 50,
	/// Key: 3
	Three = 51,
	/// Key: 4
	Four = 52,
	/// Key: 5
	Five = 53,
	/// Key: 6
	Six = 54,
	/// Key: 7
	Seven = 55,
	/// Key: 8
	Eight = 56,
	/// Key: 9
	Nine = 57,
	/// Key: ;
	Semicolon = 59,
	/// Key: =
	Equal = 61,
	/// Key: A | A
	A = 65,
	/// Key: B | B
	B = 66,
	/// Key: C | C
	C = 67,
	/// Key: D | D
	D = 68,
	/// Key: E | E
	E = 69,
	/// Key: F | F
	F = 70,
	/// Key: G | G
	G = 71,
	/// Key: H | H
	H = 72,
	/// Key: I | I
	I = 73,
	/// Key: J | J
	J = 74,
	/// Key: K | K
	K = 75,
	/// Key: L | L
	L = 76,
	/// Key: M | M
	M = 77,
	/// Key: N | N
	N = 78,
	/// Key: O | O
	O = 79,
	/// Key: P | P
	P = 80,
	/// Key: Q | Q
	Q = 81,
	/// Key: R | R
	R = 82,
	/// Key: S | S
	S = 83,
	/// Key: T | T
	T = 84,
	/// Key: U | U
	U = 85,
	/// Key: V | V
	V = 86,
	/// Key: W | W
	W = 87,
	/// Key: X | X
	X = 88,
	/// Key: Y | Y
	Y = 89,
	/// Key: Z | Z
	Z = 90,
	/// Key: [
	LeftBracket = 91,
	/// Key: '\'
	Backslash = 92,
	/// Key: ]
	RightBracket = 93,
	/// Key: `
	Grave = 96,
	/// Key: Space
	Space = 32,
	/// Key: Esc
	Escape = 256,
	/// Key: Enter
	Enter = 257,
	/// Key: Tab
	Tab = 258,
	/// Key: Backspace
	Backspace = 259,
	/// Key: Ins
	Insert = 260,
	/// Key: Del
	Delete = 261,
	/// Key: Cursor Right
	RightArrow = 262,
	/// Key: Cursor Left
	LeftArrow = 263,
	/// Key: Cursor Down
	DownArrow = 264,
	/// Key: Cursor Up
	UpArrow = 265,
	/// Key: Page Up
	PageUp = 266,
	/// Key: Page Down
	PageDown = 267,
	/// Key: Home
	Home = 268,
	/// Key: End
	End = 269,
	/// Key: Caps Lock
	CapsLock = 280,
	/// Key: Scroll Down
	ScrollLock = 281,
	/// Key: Num Lock
	NumLock = 282,
	/// Key: Print Screen
	PrintScreen = 283,
	/// Key: Pause
	Pause = 284,
	/// Key: F1
	F1 = 290,
	/// Key: F2
	F2 = 291,
	/// Key: F3
	F3 = 292,
	/// Key: F4
	F4 = 293,
	/// Key: F5
	F5 = 294,
	/// Key: F6
	F6 = 295,
	/// Key: F7
	F7 = 296,
	/// Key: F8
	F8 = 297,
	/// Key: F9
	F9 = 298,
	/// Key: F10
	F10 = 299,
	/// Key: F11
	F11 = 300,
	/// Key: F12
	F12 = 301,
	/// Key: Shift Left
	LeftShift = 340,
	/// Key: Control Left
	LeftControl = 341,
	/// Key: Alt Left
	LeftAlt = 342,
	/// Key: Super Left
	LeftSuper = 343,
	/// Key: Shift Right
	RightShift = 344,
	/// Key: Control Right
	RightControl = 345,
	/// Key: Alt Right
	RightAlt = 346,
	/// Key: Super Right
	RightSuper = 347,
	/// Key: Kb Menu
	KeypadMenu = 348,
	/// Key: Keypad 0
	Keypad0 = 320,
	/// Key: Keypad 1
	Keypad1 = 321,
	/// Key: Keypad 2
	Keypad2 = 322,
	/// Key: Keypad 3
	Keypad3 = 323,
	/// Key: Keypad 4
	Keypad4 = 324,
	/// Key: Keypad 5
	Keypad5 = 325,
	/// Key: Keypad 6
	Keypad6 = 326,
	/// Key: Keypad 7
	Keypad7 = 327,
	/// Key: Keypad 8
	Keypad8 = 328,
	/// Key: Keypad 9
	Keypad9 = 329,
	/// Key: Keypad .
	KeypadDecimal = 330,
	/// Key: Keypad /
	KeypadDivide = 331,
	/// Key: Keypad *
	KeypadMultiply = 332,
	/// Key: Keypad -
	KeypadSubtract = 333,
	/// Key: Keypad +
	KeypadAdd = 334,
	/// Key: Keypad Enter
	KeypadEnter = 335,
	/// Key: Keypad =
	KeypadEqual = 336,
	/// Key: Android Back Button
	Back = 4,
	/// Key: Android Menu Button
	Menu = 82,
	/// Key: Android Volume Up Button
	VolumeUp = 24,
	/// Key: Android Volume Down Button
	VolumeDown = 25,
}

extension Fanty
{
	public static bool IsKeyDown(KeyCode keycode)
		=> RaylibBeef.Raylib.IsKeyDown((int32)keycode);

	public static bool IsKeyUp(KeyCode keycode)
		=> RaylibBeef.Raylib.IsKeyUp((int32)keycode);

	public static bool IsKeyPressed(KeyCode keycode)
		=> RaylibBeef.Raylib.IsKeyPressed((int32)keycode);

	public static bool IsKeyReleased(KeyCode keycode)
		=> RaylibBeef.Raylib.IsKeyReleased((int32)keycode);

	/// X position of the Mouse Cursor within the current Room.
	public static float MouseX => RaylibBeef.Raylib.GetMouseX();
	/// Y position of the Mouse Cursor within the current Room.
	public static float MouseY => RaylibBeef.Raylib.GetMouseY();

	/// X position of the Mouse Cursor (in pixels) within the Game Window.
	public static float WindowMouseX => RaylibBeef.Raylib.GetMouseX();
	/// Y position of the Mouse Cursor (in pixels) within the Game Window.
	public static float WindowMouseY => RaylibBeef.Raylib.GetMouseY();

	public static bool IsMouseButtonDown(int button)
		=> RaylibBeef.Raylib.IsMouseButtonDown((int32)button);

	public static bool IsMouseButtonUp(int button)
		=> RaylibBeef.Raylib.IsMouseButtonUp((int32)button);

	public static bool IsMouseButtonPressed(int button)
		=> RaylibBeef.Raylib.IsMouseButtonPressed((int32)button);

	public static bool IsMouseButtonReleased(int button)
		=> RaylibBeef.Raylib.IsMouseButtonReleased((int32)button);
}