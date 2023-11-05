namespace FantyEngine;

extension Fanty
{
	/// Time in seconds since the last frame.
	public static float DeltaTime => RaylibBeef.Raylib.GetFrameTime();

	public static float CurrentTime { get; private set; }
}