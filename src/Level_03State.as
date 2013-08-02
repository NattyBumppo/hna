package
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	public class Level_03State extends FlxState
	{
		//general
		public var map:FlxTilemapExt;
		public var mg:FlxSprite;
		public var bg:FlxSprite;
		public var fg:FlxSprite;
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		public var player:Player;
		public var narrator:Narrator;
		public var unicorn:Unicorn;
		private var _lasers:FlxGroup;
		private var _playerHead:FlxObject;
		private var _playerFeet:FlxObject;
		private var _playerGibs:FlxEmitter;
		private var _hangSensors:FlxGroup;
		private var _uniWallL:FlxObject;
		private var _uniWallR:FlxObject;
		
		private var _projectileWall:FlxObject;
		
		private var _intro:Boolean = true;
		private var _endFloor:FlxObject;
		private var _startFloor:FlxObject;
		public var _respawnTimer:Number = 0;
		
		//load
		public var inGame:Boolean = false;
		public var endGame:Boolean = false;
		private var _loadingScreen:LoadingScreen;
		private var _loadingBg:FlxSprite;
		private var _loadStep:int = 0;
		private var _screenFade:FlxSprite;
		
		//misc
		private var _feetHit:Boolean = false;
		private var _burst:FlxSprite;
		public var _burstTimer:Number = 0;
		private var _endTimer:Number = 0;
		
		public var _narrateTimer:Number = 0;
		public var _narrateCount:Number = 0;
		public var _specialCount:Number = 0;
		public var _belowNar:Number = 0;
		public var _dieNar:Number = 0;
		public var _winNar:Number = 0;
		public var _nSound:Boolean = false;
		public var narratorTriggers:FlxGroup;
		
		[Embed(source="../data/sfx/puzzle3/P3-001-alt.mp3"] static public var P3_001:Class;
		[Embed(source="../data/sfx/puzzle3/P3-002.mp3"] static public var P3_002:Class;
		[Embed(source="../data/sfx/puzzle3/P3-003-alt.mp3"] static public var P3_003:Class;
		[Embed(source="../data/sfx/puzzle3/P3-004.mp3"] static public var P3_004:Class;
		[Embed(source="../data/sfx/puzzle3/P3-005-alt.mp3"] static public var P3_005:Class;
		
		[Embed(source="../data/Boss_Test01.mp3"] static public var Boss:Class;
		
		override public function create():void
		{
			//FlxG.visualDebug = true;
			FlxG.mouse.hide();
			FlxG.pauseSounds();
			
			
			_loadingBg = new FlxSprite();
			_loadingBg.loadGraphic(DataRegistry.load, false, false, 800, 500);
			_loadingBg.scrollFactor.x = _loadingBg.scrollFactor.y = 0;
			
			_loadingScreen = new LoadingScreen();
			add(_loadingScreen);
			
			_screenFade = new FlxSprite();
			_screenFade.makeGraphic(FlxG.width, FlxG.height, 0xff263A3B);
			_screenFade.scrollFactor.x = _screenFade.scrollFactor.y = 0;
			_screenFade.alpha = 0;
			
		}
		override public function update():void
		{
			if(!_loadingScreen.loadingComplete)
			{
				loadGame();
			}
			else
			{
				if(_loadingScreen.loadingText.alpha <= 0)
				{
					buildLevel();
					_loadingScreen.exists = false;
					inGame = true;
				}
			}
			
			if(inGame)
			{
				
				if(_loadingBg.alpha > 0)
				{
					_loadingBg.alpha -= 0.01;
				}
				else
				{
					_loadingBg.alpha = 0;
					_loadingBg.exists = false;
				}
				//hang 2.0
				if(!player.isClimbing)
				{
					if(player.facing == FlxObject.LEFT)
					{
						_playerHead.x = player.position.x;
						_playerHead.y = player.position.y;
						_playerFeet.x = player.position.x;
						_playerFeet.y = player.position.y + player.position.height;
					}
					else if(player.facing == FlxObject.RIGHT)
					{
						_playerHead.x = player.position.x + 24;
						_playerHead.y = player.position.y;
						_playerFeet.x = player.position.x + 24;
						_playerFeet.y = player.position.y + player.position.height;
					}
					
				}
				//set up world/camera
				FlxG.camera.bounds = new FlxRect(0, 288, map.width, map.height);
				FlxG.worldBounds = new FlxRect(-96, 0, map.width, map.height);
				if(_intro && _loadingBg.exists)
				{
					player.active = false;
				}
				if(_intro && !_loadingBg.exists)
				{
					player.active = true;
					player.position.velocity.x = player.position.maxVelocity.x;
				}
				if(_intro && player.position.x >= 96)
				{
					_intro = false;
					player.position.velocity.x = 0;
				}
				if(!_intro && _narrateCount == 0)
				{
					_narrateTimer += FlxG.elapsed;
				}
				if(_narrateTimer > 0 && !_nSound && _narrateCount == 0)
				{
					FlxG.play(P3_001);
					_nSound = true;
				}
				if(_narrateTimer >= 0.1 && _narrateTimer < 0.2 && _narrateCount == 0)
				{
					narrator.timeToDisplay = 5;
					if(!narrator.isNarrating)
						narrator.narrate("Look! A unicorn. The purest of all creatures.");
				}
				if(_narrateTimer >= 6 && _narrateTimer < 6.1 && _narrateCount == 0)
				{
					narrator.timeToDisplay = 2.5;
					if(!narrator.isNarrating)
						narrator.narrate("I was going to give him to you, you know...");
				}
				if(_narrateTimer >= 9 && _narrateTimer < 9.1 && _narrateCount == 0)
				{
					narrator.timeToDisplay = 1.5;
					if(!narrator.isNarrating)
						narrator.narrate("as a reward.");
				}
				if(_narrateTimer >= 11 && _narrateTimer < 11.1 && _narrateCount == 0)
				{
					narrator.timeToDisplay = 2;
					if(!narrator.isNarrating)
						narrator.narrate("But I've changed my mind.");
				}
				if(_narrateTimer >= 14 && _narrateTimer < 14.1 && _narrateCount == 0)
				{
					narrator.timeToDisplay = 3;
					if(!narrator.isNarrating)
						narrator.narrate("Your touch would just corrupt it.");
				}
				if(_narrateTimer >= 18 && _narrateTimer < 18.1 && _narrateCount == 0)
				{
					narrator.timeToDisplay = 3;
					if(!narrator.isNarrating)
						narrator.narrate("Now, reap what you have sown!");
				}
				if(_narrateTimer >= 22 && _narrateTimer < 22.1 && _narrateCount == 0)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
					//player.cutscene = false;
				}
				if(!_intro && _narrateCount == 1)
				{
					_narrateTimer += FlxG.elapsed;
				}
				if(_narrateTimer > 0 && !_nSound && _narrateCount == 1)
				{
					FlxG.play(P3_002);
					_nSound = true;
				}
				if(_narrateTimer >= 0.1 && _narrateTimer < 0.2 && _narrateCount == 1)
				{
					narrator.timeToDisplay = 3;
					if(!narrator.isNarrating)
						narrator.narrate("Unicorn, attack!!");
				}
				if(_narrateTimer >= 4 && _narrateTimer < 4.1 && _narrateCount == 1)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
					player.cutscene = false;
					unicorn.fight = true;
					FlxG.playMusic(Boss);
				}
				if(_dieNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P3_004);
						_nSound = true;
					}
					if(_narrateTimer >= 1 && _narrateTimer < 1.1)
					{						
						narrator.timeToDisplay = 5;
						if(!narrator.isNarrating)
							narrator.narrate("And so she died happily ever after.");
					}
					if(_narrateTimer >= 7 && _narrateTimer < 7.1)
					{
						_dieNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_belowNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P3_003);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{						
						narrator.timeToDisplay = 3;
						if(!narrator.isNarrating)
							narrator.narrate("You cannot escape your fate.");
					}
					if(_narrateTimer >= 4 && _narrateTimer < 4.1)
					{
						_belowNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_winNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P3_005);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{						
						narrator.timeToDisplay = 3;
						if(!narrator.isNarrating)
							narrator.narrate("You cannot escape your fate.");
					}
					if(_narrateTimer >= 4 && _narrateTimer < 4.1)
					{
						_winNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(player.position.y >= 832)
				{
					if(_belowNar == 0)
						_belowNar = 1;
				}
				//enable collision checking
				if(!_intro)
				{
					if(player.position.velocity.y == player.position.maxVelocity.y)
					{
						//FlxG.collide(_player.position, map, mapDeath);
					}
					else
					{
						FlxG.collide(player.position, map);
					}
				}
				FlxG.collide(player.position, _startFloor);
				FlxG.collide(unicorn.main, map);
				FlxG.collide(unicorn.emitter, _projectileWall, emitter);
				//specific collision handling
				FlxG.overlap(_playerHead, _hangSensors, hang);
				FlxG.overlap(_playerFeet, unicorn.win, win);
				if(!_feetHit)
				{
					FlxG.overlap(player.position, unicorn.main, unicornCollide);
				}
				FlxG.overlap(player.position, unicorn.emitter, unicornCollide);
				FlxG.overlap(player.position, unicorn.lasers, unicornCollide);
				//adjust scrolling
				if(!player.isClimbing)
				{
					FlxG.camera.follow(player.position, FlxCamera.STYLE_PLATFORMER);
				}
				//death
				if(!player.alive)
				{
					_respawnTimer += FlxG.elapsed;
					if(_respawnTimer >= 2)
					{
						_respawnTimer = 0;
						player.position.reset(player.spawnPoint.x, player.spawnPoint.y);
						player.alive = true;
						player.respawn();
						FlxG.camera.follow(player.position, FlxCamera.STYLE_PLATFORMER);
					}
				}
				//death
				if(_feetHit)
				{
					FlxG.pauseSounds();
					_burstTimer += FlxG.elapsed;
					if(_burstTimer >= 0 && _burstTimer < 2)
					{
						if(!unicorn.isIdle)
							unicorn.isIdle = true;
						
					}
					if(_burstTimer >= 2 && _burstTimer < 4)
					{
						
						if(!unicorn.isGold)
							unicorn.isGold = true;
						if(!player.isSitting)
							player.isSitting = true;
						
						player.position.x = unicorn.gold.x + unicorn.gold.width / 2 - player.position.width / 2;
						player.position.y = unicorn.gold.y - player.position.height / 2 + 16;
					}
					if(_burstTimer >= 10)
					{
						FlxG.switchState(new CreditsState());
					}
				}
			}
			//change levels
			if(FlxG.keys.justPressed("ONE"))
			{
				FlxG.switchState(new IntroLevel_01State());
			}
			else if(FlxG.keys.justPressed("TWO"))
			{
				FlxG.switchState(new Level_01State());
			}
			else if(FlxG.keys.justPressed("THREE"))
			{
				FlxG.switchState(new Level_02State());
			}
			//update after changes
			super.update();
		}
		public function hang(Sprite1:FlxObject, Sprite2:FlxObject):void
		{
			if(player.position.velocity.y > 0)
			{
				if(!player.isHanging)
				{
					player.position.y = Sprite2.y;
					player.isHanging = true;
				}
			}
		}
		public function win(Object1:FlxObject, Object2:FlxObject):void
		{
			//dirty
			_feetHit = true;

			unicorn.fight = false;

			player.cutscene = true;
			player.position.velocity.make(0,0);
			player.position.acceleration.make(0,0);
			player.facing = unicorn.facing;
			
			unicorn.isIdle = false;
			unicorn.isWandering = false;
			unicorn.isGrazing = false;
			unicorn.isShooting = false;
			unicorn.isChasing = false;
			unicorn.isRodeo = false;
			unicorn.isLaser = false;
		}
		public function emitter(Object1:FlxObject, Object2:FlxObject):void
		{
			Object1.kill();
		}
		public function unicornCollide(Object1:FlxObject, Object2:FlxObject):void
		{
			player.kill();
			if(_dieNar == 0)
				_dieNar = 1;
		}
		private function loadGame():void
		{
			if(_loadStep < 6)
			{
				buildLevel();
			}
			else
			{
				_loadingScreen.loadingPercentage = 100;
			}
		}
		private function buildLevel():void
		{
			switch(_loadStep)
			{
				//map
				case 0:
					_loadingScreen.loadingPercentage = 0;
					map = new FlxTilemapExt;
					map.loadMap(new DataRegistry.level03Hits, DataRegistry.testMapTiles);
					_projectileWall = new FlxObject(0, 960, map.width, 32);
					_projectileWall.immovable = true;
					FlxG.log("map loaded!");
					//mg
					mg = new FlxSprite(0, 180);
					mg.loadGraphic(DataRegistry.mg03, false, false, 1280, 1148);
					FlxG.log("mg loaded!");
					//fg
					fg = new FlxSprite(0,704);
					fg.loadGraphic(DataRegistry.fg03, false, false, 1280, 454);
					FlxG.log("fg loaded!");
					//bg
					bg = new FlxSprite(0, 0);
					bg.loadGraphic(DataRegistry.bg03, false, false, 3424, 1373);
					bg.scrollFactor.x = 0.5;
					bg.scrollFactor.y = 0.5;	
					FlxG.watch(bg, "x", "bG X");
					FlxG.watch(bg, "y", "bG Y");
					FlxG.log("bg loaded!");
					_loadStep++;
					break;
				//player
				case 1:
					_loadingScreen.loadingPercentage = 20;
					//instantiate player
					_playerGibs = new FlxEmitter();
					_playerGibs.setXSpeed(-150, 150);
					_playerGibs.setYSpeed(-200, 200);
					_playerGibs.setRotation(-720, -720);
					_playerGibs.gravity = 420;
					_playerGibs.bounce = 0;
					_playerGibs.makeParticles(DataRegistry.blood, 50, 16, true, 0.8);
					for each(var p:FlxParticle in _playerGibs.members)
					{
						p.alpha = 0.75;
					}
					FlxG.log("_playerGibs loaded!");
					
					player = new Player(-32, 672,_playerGibs);
					player.spawnPoint = new FlxPoint(96, 672);
					player.setLeftControl("LEFT");
					player.setRightControl("RIGHT");
					player.setUpControl("UP");
					player.setDownControl("DOWN");
					player.setAction1Control("SPACE");
					player.setAction2Control("SHIFT");
					_playerHead = new FlxObject(player.position.x, player.position.y, 8, 1);
					FlxG.log("player loaded!");
					_playerFeet = new FlxObject(player.position.x, player.position.y, 8, 1);
					_lasers = new FlxGroup();
					unicorn = new Unicorn(560, 672, player);
					FlxG.log("unicorn loaded!");
					_startFloor = new FlxObject(-96, 768, 240, 32);
					_startFloor.immovable = true;
					_loadStep++;
					break;
				//hang
				case 2:
					_loadingScreen.loadingPercentage = 40;
					addSensors();
					FlxG.log("hang sensors loaded!");
					_burst = new FlxSprite(unicorn.main.x,unicorn.main.y);
					_burst.loadGraphic(DataRegistry.burst, true, false, 200, 193);
					FlxG.watch(_burst.offset, "x", "burst offx");
					FlxG.watch(_burst.offset, "y", "burst offy");
					FlxG.watch(this, "_burstTimer", "burst timer");
					_burst.addAnimation("burst", [0,1,2,3,4,5,6,7,8,9,10,
						11,12,13,14,15,16,17,18,19,20,
						21,22,23,24,25,26,27,28,29,30,
						31,32,33,34,35,36,37,38,39,40,
						41,42,43,44,45,46,47,48,49,50,
						51,52,53,54,55,56,57,58,59,60,
						61,62], 15, false);
					_loadStep++;
					_burst.play("burst");
					_loadStep++;
					break;
				//overlay
				case 3:
					_loadingScreen.loadingPercentage = 60;
					overlay = new FlxSprite(0, 0);
					overlay.loadGraphic(DataRegistry.multiplyTexture, false, false, 800, 500);
					overlay.scrollFactor.x = 0;
					overlay.scrollFactor.y = 0;
					overlay.blend = "multiply";
					FlxG.log("overlay loaded!");
					_loadStep++;
					break;
				//border
				case 4:
					_loadingScreen.loadingPercentage = 80;
					border = new FlxSprite(0, 0);
					border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
					border.scrollFactor.x = 0;
					border.scrollFactor.y = 0;
					FlxG.log("border loaded!");
					_loadStep++;
					break;
				//narrator
				case 5:
					_loadingScreen.loadingPercentage = 100;
					narrator = new Narrator(FlxG.camera.scroll.x + 16, FlxG.camera.scroll.y + FlxG.height - 50);
					FlxG.log("narrator loaded!");
					_loadStep++;
					break;
				//add
				case 6:
					_loadingScreen.loadingPercentage = 100;
					FlxG.bgColor = 0xff070C10;
					add(map);
					add(bg);
					add(mg);
					add(fg);
					add(unicorn);
					add(player);
					add(_lasers);
					add(_startFloor);
					add(_playerHead);
					add(_playerFeet);
					add(_playerGibs);
					//add(_burst);
					add(overlay);
					add(_screenFade);
					add(border);
					add(_loadingBg);
					add(narrator);
					add(_projectileWall);
					break;
			}
		}
		private function addSensors():void
		{
			_hangSensors = new FlxGroup();
			var sensorsMapL:FlxTilemapExt = new FlxTilemapExt;
			var sensorsMapR:FlxTilemapExt = new FlxTilemapExt;
			sensorsMapL.loadMap(new DataRegistry.level03SensorsL, DataRegistry.testMapTiles, 32, 32);
			sensorsMapR.loadMap(new DataRegistry.level03SensorsR, DataRegistry.testMapTiles, 32, 32);
			for(var ly:int = 0; ly < sensorsMapL.heightInTiles; ly++)
			{
				for(var lx:int = 0; lx < sensorsMapL.widthInTiles; lx++)
				{
					//sensors
					if(sensorsMapL.getTile(lx, ly) == 1)
						_hangSensors.add(new FlxObject(((lx+1)*32) - 1, ly*32, 32, 1));
				}
			}
			for(var ry:int = 0; ry < sensorsMapR.heightInTiles; ry++)
			{
				for(var rx:int = 0; rx < sensorsMapR.widthInTiles; rx++)
				{
					//sensors
					if(sensorsMapR.getTile(rx, ry) == 1)
						_hangSensors.add(new FlxObject(((rx-1)*32) + 2, ry*32, 32, 1));
				}
			}
			add(_hangSensors);
		}
	}
}