package
{
	import org.flixel.*;
	
	public class TestState extends FlxState
	{
		public var map:FlxTilemapExt;
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		
		private var _player:Player;
		private var _playerGibs:FlxEmitter;
		private var _items:FlxGroup;
		private var _itemEmitter:FlxEmitter;
		private var _narrator:Narrator;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffEEEEEE;
			
			//map
			map = new FlxTilemapExt;
			map.loadMap(new DataRegistry.TestHits, DataRegistry.testMapTiles);
			FlxG.log("map loaded!");
			add(map);
			//player gibs - recylce!
			_playerGibs = new FlxEmitter();
			_playerGibs.setXSpeed(-150, 150);
			_playerGibs.setYSpeed(-200, 0);
			_playerGibs.setRotation(-720, -720);
			_playerGibs.gravity = 420;
			_playerGibs.bounce = 0;
			_playerGibs.makeParticles(DataRegistry.blood, 100, 10, true, 0.5);
			for each(var i:FlxParticle in _playerGibs.members)
			{
				i.alpha = 0.70;
			}
			FlxG.log("_playerGibs loaded!");
			add(_playerGibs);
			//instantiate player
			_player = new Player(32, 64, _playerGibs);
			_player.setLeftControl("LEFT");
			_player.setRightControl("RIGHT");
			_player.setUpControl("UP");
			_player.setDownControl("DOWN");
			_player.setAction1Control("SPACE");
			_player.setAction2Control("SHIFT");
			FlxG.log("_player loaded!");
			add(_player);
			//overlay
			overlay = new FlxSprite(0, 0);
			overlay.loadGraphic(DataRegistry.multiplyTexture, false, false, 800, 500);
			overlay.scrollFactor.x = 0;
			overlay.scrollFactor.y = 0;
			overlay.blend = "multiply";
			FlxG.log("overlay loaded!");
			add(overlay);
			//border
			border = new FlxSprite(0, 0);
			border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
			border.scrollFactor.x = 0;
			border.scrollFactor.y = 0;
			FlxG.log("border loaded!");
			add(border);
			//narrator
			_narrator = new Narrator(FlxG.camera.scroll.x + 16, FlxG.camera.scroll.y + FlxG.height - 50);
			FlxG.log("_narrator loaded!");
			add(_narrator);
		}
		override public function update():void
		{
			
			//enable collision checking
			FlxG.collide(_player.position, map);
			FlxG.collide(_items, map);
			//specific collision handling
			////
			//test
			if(FlxG.keys.justPressed("N"))
			{
				_narrator.narrate("Dehumanize yourself and face to bloodshed");
			}
			if(FlxG.keys.justPressed("K"))
			{
				_player.kill();
			}
			//adjust scrolling
			if(!_player.isClimbing)
			{
				FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
			}
			//update after changes
			super.update();
		}
	}
}