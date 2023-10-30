using System;
using FantyEngine;
using Bon;

namespace Sandbox;

class Program
{
	public static int Main(String[] args)
	{
		let game = scope Game("Sandbox");
		game.AddGameObject<TestObject>(new .());


		for (var i < 8)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 0;
			wall.y = 160 + (i * 16);
		}
		for (var i < 28)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = i * 16;
			wall.y = 272;
		}
		for (var i < 8)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 432;
			wall.y = 160 + (i * 16);
		}
		for (var i < 5)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 432 + (i * 16);
			wall.y = 160;
		}
		for (var i < 12)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 496;
			wall.y = 160 + (i * 16);
		}

		for (var i < 2)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 176;
			wall.y = 240 + (i * 16);
		}
		for (var i < 2)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 256;
			wall.y = 240 + (i * 16);
		}
		for (var i < 4)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 192 + (i * 16);
			wall.y = 240;
		}

		/*
		gBonEnv.serializeFlags |= .Verbose;
		let structure = scope Sprite()
		{
		};

		var frames = scope System.Collections.List<SpriteFrame>();
		frames.Add(new .() { TextureRegion = .(0, 0, 32, 32) });

		structure.Frames = new .[frames.Count];
		frames.CopyTo(structure.Frames);

		let str = Bon.Serialize(structure, .. scope .());
		Console.WriteLine(str);

		Sprite a = scope .();
		Bon.Deserialize(ref a, str);
		*/

		game.Run();

		return 0;
	}

	[BonTarget]
	class ass
	{
		public int a = 0;
	}
}