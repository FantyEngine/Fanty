using System;
using RaylibBeef;

namespace FantyEngine;

public abstract class Application
{
	public static Application Instance { get; private set; }
	public RenderTexture2D ScreenBuffer { get; private set; }

	private String m_WindowTitle ~ delete _;
	private RoomRuntime m_RoomRuntime = null;
	private float m_NextFixedUpdate = 0.0f;

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
			Fanty.[Friend]CurrentTime += Fanty.DeltaTime;

			var updateFixedUpdate = false;
			if (Fanty.CurrentTime > m_NextFixedUpdate)
			{
				updateFixedUpdate = true;
				m_NextFixedUpdate += (1.0f / GameOptions.TargetFixedStep);
				Console.WriteLine(Fanty.CurrentTime);
			}

			if (updateFixedUpdate)
			{
				UpdateCurrentRoom();
				FixedUpdateCurrentRoom();
			}
			for (var layer in m_RoomRuntime.Room.InstanceLayers)
			for (var object in layer.value.GameObjects)
			{
				m_RoomRuntime.CurrentGameObject = &object;
				// Use bounding box in the future.
				if (object.x < 0 || object.x > m_RoomRuntime.Room.Width
					|| object.y < 0 || object.y > m_RoomRuntime.Room.Height)
				{
					if (!object.[Friend]m_ExitedRoom)
					{
						object.[Friend]m_ExitedRoom = true;
						object.OutsideRoomEvent();
					}
				}
			}

			if (m_RoomRuntime.Room.EnableViewports)
			{
				m_RoomRuntime.camera.target = .(m_RoomRuntime.Room.Viewport0.CameraProperties.x, m_RoomRuntime.Room.Viewport0.CameraProperties.y);
				m_RoomRuntime.camera.zoom = 1;
			}

			Raylib.BeginDrawing();
			{
				Raylib.ClearBackground(FantyEngine.Color.darkGray);

				if (updateFixedUpdate)
				{
					Raylib.BeginTextureMode(ScreenBuffer);

					if (m_RoomRuntime.Room.EnableViewports)
						Raylib.BeginMode2D(m_RoomRuntime.camera);

					PreDrawCurrentRoom();
					DrawCurrentRoom();
					PostDrawCurrentRoom();

					if (m_RoomRuntime.Room.EnableViewports)
						Raylib.EndMode2D();

					Raylib.EndTextureMode();
				}

				/*
				Raylib.DrawTexturePro(m_ScreenTexture.texture,
					RaylibBeef.Rectangle(0, 0, m_ScreenTexture.texture.width, -m_ScreenTexture.texture.height),
					RaylibBeef.Rectangle(0, 0, Raylib.GetScreenWidth(), Raylib.GetScreenHeight()),
					RaylibBeef.Vector2(0, 0),
					0.0f,
					FantyEngine.Color.white);
				*/

				Raylib.Fanty_ImGuiBegin(Raylib.GetWindowGlfw(), Raylib.GetFrameTime());
				EditorUI.Draw();
				Raylib.Fanty_ImGuiEnd(Raylib.GetWindowGlfw());

				Raylib.DrawFPS(20, 20);
			}
			Raylib.EndDrawing();

		}

		// rlImGui.rlImGuiShutdown();
		Exit();
	}

	private void Init()
	{
		Raylib.SetConfigFlags((int32)ConfigFlags.FLAG_WINDOW_RESIZABLE);
		Raylib.InitWindow(1600, 900, m_WindowTitle);
		Raylib.InitAudioDevice();
		Raylib.SetTargetFPS((int32)GameOptions.TargetFixedStep);

		ScreenBuffer = Raylib.LoadRenderTexture(1024, 768);

		// rlImGui.rlImGuiSetup();
		Raylib.Fanty_SetupImGui(Raylib.GetWindowGlfw(), "", "");

		AssetsManager.[Friend]LoadAllAssets();

		m_RoomRuntime = new .();
		m_RoomRuntime.Room = new Room();
		m_RoomRuntime.Room.EnableViewports = true;
		m_RoomRuntime.Room.BackgroundColor = Color("#00a6ff");
		m_RoomRuntime.Room.Width *= 4;
	}

	private void Exit()
	{
		Raylib.UnloadRenderTexture(ScreenBuffer);

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
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.BeginStepEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.StepEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.EndStepEvent();
		}
	}

	private void FixedUpdateCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.FixedStepEvent();
		}
	}
	
	private void PreDrawCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.PreDrawEvent();
		}
	}

	private void DrawCurrentRoom()
	{
		Fanty.DrawClear(m_RoomRuntime.Room.BackgroundColor);

		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawBeginEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawEndEvent();
		}
	}

	private void PostDrawCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.PostDrawEvent();
		}
	}

	private void UnloadCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DestroyEvent();
		}
	}

	public T AddGameObject<T>(T item) where T : GameObject
	{
		var instanceLayerKey = Guid.Empty;

		var i = 0;
		for (var key in m_RoomRuntime.Room.InstanceLayers.Keys)
		{
			instanceLayerKey = key;
			break;
		}

		let instanceLayer = m_RoomRuntime.Room.InstanceLayers[instanceLayerKey];
		instanceLayer.GameObjects.Add(item);
		item.[Friend]m_InstanceLayerID = instanceLayerKey;
		item.CreateEvent();

		return item;
	}

	public Room.InstanceLayer AddInstanceLayer()
	{
		var il = new Room.InstanceLayer();
		m_RoomRuntime.Room.InstanceLayers.Add(Guid.Create(), il);
		return il;
	}

	public Room.InstanceLayer GetInstanceLayer(Guid guid)
	{
		return m_RoomRuntime.Room.InstanceLayers[guid];
	}
}