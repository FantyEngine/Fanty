using System;
using FantyEngine;
using RaylibBeef;
using System.Collections;

namespace FantyRuntime;

class Program
{
	struct GameObjectType
	{
		public Type type;
		public StringView Name;
	}

	public static void Main(String[] args)
	{
		List<GameObjectType> goTypes = scope .();

		for (let type in Type.Types)
		{
			if (let regAttribute = type.GetCustomAttribute<FantyEngine.RegisterGameObjectAttribute>())
			{
				goTypes.Add(.() { type = type, Name = regAttribute.Name });
			}
		}

		Raylib.SetConfigFlags((int32)(ConfigFlags.FLAG_VSYNC_HINT));
		Raylib.SetTraceLogLevel((int32)(TraceLogLevel.LOG_WARNING | .LOG_ERROR | .LOG_FATAL));
		Raylib.InitWindow(1280, 720, "Fanty Runtime - Sandbox");

		AssetsManager.LoadAllAssets();
		RoomAsset room = scope .();
		Bon.Bon.DeserializeFromFile(ref room, scope $"{FantyEngine.AssetsManager.AssetsPath}/rooms/testroom.room");

		var roomInstance = scope RoomInstance();
		roomInstance.Width = room.Width;
		roomInstance.Height = room.Height;
		for (var instanceLayer in room.InstanceLayers)
		{
			var newInstanceLayer = new RoomInstance.InstanceLayer();

			for (var go in instanceLayer.GameObjects)
			{
				for (let goType in goTypes)
				{
					var goAsset = AssetsManager.GameObjectAssets[go.AssetName];

					if (go.AssetName == goType.Name)
					{
						let type = goType.type;
						if (Object typeobj = type.CreateObject())
						{
							// We should check for this cast
							var gameobject = (GameObject)typeobj;
							gameobject.x = go.x;
							gameobject.y = go.y;
							gameobject.[Friend]m_SpriteIndex = new String(goAsset.SpriteAssetName);
							// Console.WriteLine(gameobject.x);
							newInstanceLayer.GameObjects.Add(gameobject);
						}
					}
				}

			}
			roomInstance.InstanceLayers.Add(newInstanceLayer);
		}
		for (var bgLayer in room.BackgroundLayers)
		{
			var newBGLayer = new RoomInstance.BackgroundLayer();
			newBGLayer.Color = bgLayer.Color;
			newBGLayer.Position = bgLayer.Position;
			newBGLayer.Speed = bgLayer.Speed;
			newBGLayer.Stretch = bgLayer.Stretch;
			newBGLayer.HorizontalTile = bgLayer.HorizontalTile;
			newBGLayer.VerticalTile = bgLayer.VerticalTile;
			if (bgLayer.HasSprite())
				newBGLayer.SetSprite(bgLayer.Sprite);

			roomInstance.BackgroundLayers.Add(newBGLayer);
		}

		Raylib.SetWindowSize((int32)roomInstance.Width, (int32)roomInstance.Height);

		void Update()
		{
			for (let layer in roomInstance.InstanceLayers)
				for (var object in layer.GameObjects)
				{
					// m_RoomRuntime.CurrentGameObject = &object;
					object.BeginStepEvent();
				}
			for (let layer in roomInstance.InstanceLayers)
				for (var object in layer.GameObjects)
				{
					// m_RoomRuntime.CurrentGameObject = &object;
					object.StepEvent();
				}
			for (let layer in roomInstance.InstanceLayers)
				for (var object in layer.GameObjects)
				{
					// m_RoomRuntime.CurrentGameObject = &object;
					object.EndStepEvent();
				}

			Raylib.BeginDrawing();
			Raylib.ClearBackground(FantyEngine.Color.black);

			for (let layer in roomInstance.BackgroundLayers)
			{
				if (String.IsNullOrEmpty(layer.Sprite))
					Fanty.DrawClear(layer.Color);
				else
				{
					var countX = 1;
					var countY = 1;
					var asset = AssetsManager.Sprites[layer.Sprite];

					if (layer.HorizontalTile)
						countX = (roomInstance.Width / asset.Size.x) + 1;
					if (layer.VerticalTile)
						countY = (roomInstance.Height / asset.Size.y) + 1;

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

			for (let layer in roomInstance.InstanceLayers)
			for (var object in layer.GameObjects)
			{
				// m_RoomRuntime.CurrentGameObject = &object;
				object.DrawBeginEvent();
			}
			for (let layer in roomInstance.InstanceLayers)
			for (var object in layer.GameObjects)
			{
				// m_RoomRuntime.CurrentGameObject = &object;
				object.DrawEvent();
			}
			for (let layer in roomInstance.InstanceLayers)
			for (var object in layer.GameObjects)
			{
				// m_RoomRuntime.CurrentGameObject = &object;
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
}