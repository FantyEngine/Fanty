using System;
using RaylibBeef;

namespace FantyEngine;

public abstract class Application
{
	public static Application Instance { get; private set; }
	public RenderTexture2D ScreenBuffer { get; private set; }
	public bool IsRunning = false;

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
			var updateFixedUpdate = false;

			if (IsRunning)
			{
				Fanty.[Friend]CurrentTime += Fanty.DeltaTime;

				if (Fanty.CurrentTime > m_NextFixedUpdate)
				{
					updateFixedUpdate = true;
					m_NextFixedUpdate += (1.0f / GameOptions.TargetFixedStep);
				}

				if (updateFixedUpdate)
				{
					UpdateCurrentRoom();
					FixedUpdateCurrentRoom();
				}
				for (var layer in m_RoomRuntime.Room.InstanceLayers)
				for (var object in layer.value.GameObjects.Values)
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
			}

			Raylib.BeginDrawing();
			{
				Raylib.ClearBackground(FantyEngine.Color.darkGray);

				if (IsRunning)
				{
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
				}

				/*
				Raylib.DrawTexturePro(m_ScreenTexture.texture,
					RaylibBeef.Rectangle(0, 0, m_ScreenTexture.texture.width, -m_ScreenTexture.texture.height),
					RaylibBeef.Rectangle(0, 0, Raylib.GetScreenWidth(), Raylib.GetScreenHeight()),
					RaylibBeef.Vector2(0, 0),
					0.0f,
					FantyEngine.Color.white);
				*/
			}
			Raylib.EndDrawing();

		}

		Exit();
	}

	private void Init()
	{
		Raylib.SetConfigFlags((int32)ConfigFlags.FLAG_WINDOW_RESIZABLE);
		Raylib.InitWindow(1600, 900, m_WindowTitle);
		Raylib.InitAudioDevice();
		Raylib.SetTargetFPS(185);
		// (int32)GameOptions.TargetFixedStep

		ScreenBuffer = Raylib.LoadRenderTexture(1280, 720);

		// rlImGui.rlImGuiSetup();
		// ImGui.ImGui.GetIO().Fonts.AddFontFromFileTTF(@"D:\flimmy\Assets\Resources\Fonts\Questrial-Regular.ttf", 13);

		AssetsManager.[Friend]LoadAllAssets();

		m_RoomRuntime = new .();
		m_RoomRuntime.Room = new Room();
		m_RoomRuntime.Room.EnableViewports = true;
		m_RoomRuntime.Room.Width *= 4;

		m_RoomRuntime.Room.BackgroundLayers.Add(Guid.Create(), new .() { Color = .("#00a6ff") });
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
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.BeginStepEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.StepEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.EndStepEvent();
		}
	}

	private void FixedUpdateCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.FixedStepEvent();
		}
	}
	
	private void PreDrawCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.PreDrawEvent();
		}
	}

	private void DrawCurrentRoom()
	{
		// Fanty.DrawClear(m_RoomRuntime.Room.BackgroundColor);

		for (let layer in m_RoomRuntime.Room.BackgroundLayers.Values)
		{
			if (String.IsNullOrEmpty(layer.Sprite))
				Fanty.DrawClear(layer.Color);
			else
			{
				var countX = 1;
				var countY = 1;
				var asset = AssetsManager.Sprites[layer.Sprite];

				if (layer.HorizontalTile)
					countX = (m_RoomRuntime.Room.Width / asset.Size.x) + 1;
				if (layer.VerticalTile)
					countY = (m_RoomRuntime.Room.Height / asset.Size.y) + 1;

				for (var x < countX)
				{
					for (var y < countY)
					{
						Fanty.DrawSprite(layer.Sprite, 0,
							((x * asset.Size.x) + layer.Position.x) - (Mathf.Round2Nearest(layer.Position.x, asset.Size.x)),
							((y * asset.Size.y) + layer.Position.y) - Mathf.Round2Nearest(layer.Position.y, asset.Size.y),
							1, 1, 0, layer.Color);
					}
				}
			}
		}

		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawBeginEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawEvent();
		}
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.DrawEndEvent();
		}
	}

	private void PostDrawCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
		{
			m_RoomRuntime.CurrentGameObject = &object;
			object.PostDrawEvent();
		}
	}

	private void UnloadCurrentRoom()
	{
		for (let layer in m_RoomRuntime.Room.InstanceLayers)
		for (var object in layer.value.GameObjects.Values)
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

		let gameobjectId = Guid.Create();

		let instanceLayer = m_RoomRuntime.Room.InstanceLayers[instanceLayerKey];
		instanceLayer.GameObjects.Add(gameobjectId, item);
		item.[Friend]InstanceLayerID = instanceLayerKey;
		item.[Friend]GameObjectID = gameobjectId;
		item.CreateEvent();

		return item;
	}

	public Room.InstanceLayer AddInstanceLayer()
	{
		var il = new Room.InstanceLayer();
		il.SetName("Instances");
		m_RoomRuntime.Room.InstanceLayers.Add(Guid.Create(), il);
		return il;
	}

	public Room.InstanceLayer GetInstanceLayer(Guid guid)
	{
		return m_RoomRuntime.Room.InstanceLayers[guid];
	}
}