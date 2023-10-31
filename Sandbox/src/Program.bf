using System;
using FantyEngine;

namespace Sandbox;

class Program
{
	public static int Main(String[] args)
	{
		let game = scope Game("Sandbox");
		game.AddInstanceLayer();
		game.AddGameObject<Player>(new .());

		game.AddGameObject<Gun>(new .());
		game.AddGameObject<Sandbox.oCamera>(new .());


		for (var i < 8)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = i * 32;
			wall.y = 32 * 8;
		}
		for (var i < 7)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = (32 * 8) + (i * 32);
			wall.y = 32 * 9;
		}
		for (var i < 8)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = (32 * 15) + (i * 32);
			wall.y = 32 * 8;
		}
		/*
		for (var i < 8)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 0;
			wall.y = 160 + (i * 64);
		}
		for (var i < 28)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = i * 64;
			wall.y = 272;
		}
		for (var i < 8)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 432;
			wall.y = 160 + (i * 64);
		}
		for (var i < 5)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 432 + (i * 64);
			wall.y = 160;
		}
		for (var i < 12)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 496;
			wall.y = 160 + (i * 64);
		}

		for (var i < 2)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 176;
			wall.y = 240 + (i * 64);
		}
		for (var i < 2)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 256;
			wall.y = 240 + (i * 64);
		}
		for (var i < 4)
		{
			let wall = game.AddGameObject<Wall>(new .());
			wall.x = 192 + (i * 64);
			wall.y = 240;
		}
		*/

		game.Run();

		return 0;
	}
}