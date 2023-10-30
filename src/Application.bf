using System;
using RaylibBeef;

namespace FantyEngine;

public abstract class Application
{
	public static Application Instance { get; private set; }

	private String m_WindowTitle ~ delete _;

	private RoomRuntime m_RoomRuntime = null;

	private float nextFixedUpdate = 0.0f;

	private class RoomRuntime
	{
		public Room Room ~ delete _;
		public GameObject* CurrentGameObject = null;
		public Camera2D camera;
	}

	public virtual this(StringView title)
	{
		Instance = this;

		m_WindowTitle = new String(title);
		Init();
	}

	public void Run()
	{
		while (!Raylib.WindowShouldClose())
		{
			if (m_RoomRuntime.Room.EnableViewports)
			{
				m_RoomRuntime.camera.target = .(m_RoomRuntime.Room.Viewport0.CameraProperties.x, m_RoomRuntime.Room.Viewport0.CameraProperties.y);
				m_RoomRuntime.camera.zoom = 1;
			}

			Fanty.[Friend]CurrentTime += Fanty.DeltaTime;
			UpdateCurrentRoom();

			if (Fanty.CurrentTime > nextFixedUpdate)
			{
				nextFixedUpdate += (1.0f / GameOptions.TargetFixedStep);
			}
			FixedUpdateCurrentRoom();

			Raylib.BeginDrawing();
			{

				if (m_RoomRuntime.Room.EnableViewports)
					Raylib.BeginMode2D(m_RoomRuntime.camera);

				DrawCurrentRoom();

				if (m_RoomRuntime.Room.EnableViewports)
					Raylib.EndMode2D();

				/*
				Raylib.DrawTexturePro(m_ScreenTexture.texture,
					RaylibBeef.Rectangle(0, 0, m_ScreenTexture.texture.width, -m_ScreenTexture.texture.height),
					RaylibBeef.Rectangle(0, 0, Raylib.GetScreenWidth(), Raylib.GetScreenHeight()),
					RaylibBeef.Vector2(0, 0),
					0.0f,
					FantyEngine.Color.white);
				*/

				Raylib.DrawTexture(AssetsManager.MainTexturePage, 360, 0, FantyEngine.Color.white);

				Raylib.DrawFPS(20, 20);
			}
			Raylib.EndDrawing();
		}

		Exit();
	}

	private void Init()
	{
		Raylib.InitWindow(1024, 768, m_WindowTitle);
		Raylib.InitAudioDevice();
		Raylib.SetTargetFPS((int32)GameOptions.TargetFixedStep);

		AssetsManager.[Friend]LoadAllAssets();

		m_RoomRuntime = new .();
		m_RoomRuntime.Room = new Room();
		m_RoomRuntime.Room.EnableViewports = true;
		m_RoomRuntime.Room.BackgroundColor = Color("#00a7ff");
	}

	private void Exit()
	{
		if (m_RoomRuntime != null)
		{
			UnloadCurrentRoom();
			delete m_RoomRuntime;
		}

		Raylib.CloseAudioDevice();
		Raylib.CloseWindow();
	}

	private void UpdateCurrentRoom()
	{
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.BeginStep();
		}
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.Step();
		}
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.EndStep();
		}
	}

	private void FixedUpdateCurrentRoom()
	{
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.FixedStep();
		}
	}

	private void DrawCurrentRoom()
	{
		Fanty.DrawClear(m_RoomRuntime.Room.BackgroundColor);

		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawBegin();
		}
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.Draw();
		}
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawEnd();
		}
	}

	private void UnloadCurrentRoom()
	{
		for (var object in m_RoomRuntime.Room.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.Destroy();
		}
	}

	public T AddGameObject<T>(T item) where T : GameObject
	{
		m_RoomRuntime.Room.GameObjects.Add(item);
		item.Create();

		return item;
	}
}