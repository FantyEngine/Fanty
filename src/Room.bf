using System.Collections;

namespace FantyEngine;

public class Room
{
	/// !! NOTE: Make it harder to modify without proper functions.
	public List<GameObject> GameObjects = new .() ~ DeleteContainerAndItems!(_);

	public int Width = 1024;
	public int Height = 768;

	public Color BackgroundColor = Color(84, 84, 84, 255);

	public bool EnableViewports = false;
	public Viewport Viewport0 = .(true, .(0, 0, 1024, 768), .(0, 0, 1024, 768));

	public struct Viewport
	{
		public bool Visible = false;
		public Rectangle CameraProperties;
		public Rectangle ViewportProperties;

		public this(bool visible, Rectangle cameraProperties, Rectangle viewportProperties)
		{
			this.Visible = visible;
			this.CameraProperties = cameraProperties;
			this.ViewportProperties = viewportProperties;
		}
	}
}