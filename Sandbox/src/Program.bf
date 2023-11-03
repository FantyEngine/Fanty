using System;
using FantyEngine;

namespace Sandbox;

class Program
{
	public static LayerID mountainsLayer;
	public static LayerID treesLayer;

	public static int Main(String[] args)
	{
		let game = scope Game("Sandbox");
		game.AddInstanceLayer();
		mountainsLayer = Fanty.LayerBackgroundCreate(0, "Mountains", "sMountain");
		Fanty.LayerBackgroundSetHTiled(mountainsLayer, true);
		treesLayer = Fanty.LayerBackgroundCreate(0, "Trees", "sTrees");
		Fanty.LayerBackgroundSetHTiled(treesLayer, true);

		game.AddGameObject<Player>(new .());

		game.AddGameObject<Gun>(new .());
		game.AddGameObject<Sandbox.oCamera>(new .());


		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 32;
			wall.y = 64 * 8;
			wall.ImageXScale = 8;
			wall.ImageYScale = 8;
		}
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = (32 * 8) + (32);
			wall.y = 64 * 9;
			wall.ImageXScale = 8;
			wall.ImageYScale = 8;

		}
		let wall = game.AddGameObject<Wall>(new .());
		wall.x = (32 * 15) + (32);
		wall.y = 64 * 8;
		wall.ImageXScale = 200;
		wall.ImageYScale = 8;

		game.Run();

		return 0;
	}
}