using System;
using FantyEngine;
using RaylibBeef;

namespace FantyRuntime;

public class Game : Application
{
	public this()
	{
		Instance = this;
		Init();

		Raylib.SetConfigFlags((int32)(ConfigFlags.FLAG_VSYNC_HINT));
		Raylib.SetTraceLogLevel((int32)(TraceLogLevel.LOG_WARNING | .LOG_ERROR | .LOG_FATAL));
		Raylib.InitWindow(1280, 720, "Fanty Runtime - Sandbox");
		Raylib.SetTargetFPS(60);

		AssetsManager.LoadAllAssets();

		RoomAsset room = scope .();
		Bon.Bon.DeserializeFromFile(ref room, scope $"{FantyEngine.AssetsManager.AssetsPath}/rooms/testroom.room");

		CurrentRoom = LoadRoomFromAsset(room);

		Raylib.SetWindowSize((int32)CurrentRoom.Width, (int32)CurrentRoom.Height);

		void Update()
		{
			for (let layer in CurrentRoom.InstanceLayers)
				for (var object in layer.GameObjects)
				{
					CurrentGameObject = &object;
					object.BeginStepEvent();
				}
			for (let layer in CurrentRoom.InstanceLayers)
				for (var object in layer.GameObjects)
				{
					CurrentGameObject = &object;
					object.StepEvent();
				}
			for (let layer in CurrentRoom.InstanceLayers)
				for (var object in layer.GameObjects)
				{
					CurrentGameObject = &object;
					object.EndStepEvent();
				}

			Raylib.BeginDrawing();
			Raylib.ClearBackground(FantyEngine.Color.black);

			for (let layer in CurrentRoom.BackgroundLayers)
			{
				if (String.IsNullOrEmpty(layer.Sprite))
					Fanty.DrawClear(layer.Color);
				else
				{
					var countX = 1;
					var countY = 1;
					var asset = AssetsManager.Sprites[layer.Sprite];

					if (layer.HorizontalTile)
						countX = (CurrentRoom.Width / asset.Size.x) + 1;
					if (layer.VerticalTile)
						countY = (CurrentRoom.Height / asset.Size.y) + 1;

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

			for (let layer in CurrentRoom.InstanceLayers)
			for (var object in layer.GameObjects)
			{
				CurrentGameObject = &object;
				object.DrawBeginEvent();
			}
			for (let layer in CurrentRoom.InstanceLayers)
			for (var object in layer.GameObjects)
			{
				CurrentGameObject = &object;
				object.DrawEvent();
			}
			for (let layer in CurrentRoom.InstanceLayers)
			for (var object in layer.GameObjects)
			{
				CurrentGameObject = &object;
				object.DrawEndEvent();
			}

			Raylib.DrawFPS(20, 20);
			Raylib.EndDrawing();
		}

		while (!Raylib.WindowShouldClose())
		{
			Update();
		}

		Raylib.CloseWindow();

	}

	public ~this()
	{
		delete CurrentRoom;
	}
}