package
{
	
	import org.flixel.FlxButton;
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	public class IntroLevel_01State extends FlxState
	{
		public var skyY:FlxTilemap;
		public var skyX:FlxTilemap;
		public var clouds1:FlxSprite;
		public var clouds3:FlxSprite;
		public var clouds2:FlxSprite;
		public var clouds4:FlxSprite;
		public var paintedSky:FlxSprite;
		public var map:FlxTilemapExt;
		public var bg2:FlxSprite;
		public var trees1:FlxSprite;
		public var trees2:FlxSprite;
		public var waterfall:FlxSprite;
		public var bg1:FlxSprite;
		public var mg:FlxSprite;
		public var bigTree:FlxSprite;
		public var fgStatic1:FlxSprite;
		public var fgStatic2:FlxSprite;
		public var fgBush:FlxSprite;
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		public var preborder:FlxSprite;
		public var title:FlxSprite;
		
		private var _player:Player;
		private var _playerHead:FlxObject;
		private var _playerGibs:FlxEmitter;
		private var _hangSensors:FlxGroup;
		private var _branchSensor:FlxObject;
		private var _narrator:Narrator;
		
		//load screen!
		private var _loadingScreen:LoadingScreen;
		private var _loadingBg:FlxSprite;
		private var _loadStep:int = 0;
		private var _inGame:Boolean = false;
		private var _endGame:Boolean = false;
		
		//title!
		private var _titleCamera:FlxObject;
		private var _titleCameraPath:FlxPath;
		private var _titleCameraTimer:Number = 0;
		private var _screenFade:FlxSprite;
		private var _playButton:FlxButton;
		private var _titleBool:Boolean = true;
		private var _clickedPlay:Boolean = false;
		private var _playBool:Boolean = false;
		
		//camera testing
		private var _cameraBool:Boolean = false;
		private var _cameraResetTriggers:FlxGroup;
		private var _riverCameraTrigger:FlxObject;
		private var _riverCamera:FlxObject;
		private var _riverCameraPath:FlxPath;
		private var _resetCameraPath:FlxPath;
		
		//branch test
		private var _branch:Branch;
		
		//gator
		private var _gator1a:FlxSprite;
		private var _gator1b:FlxSprite;
		private var _gatorBlocks:FlxGroup;
		private var _gatorAttack:Boolean = false;
		
		//misc properties
		public var _respawnTimer:Number = 0;
		public var _narrateTimer:Number = 0;
		public var _narrateCount:Number = 0;
		public var _specialCount:Number = 0;
		public var _nSound:Boolean = false;
		public var _titleSequence:Boolean = true;
		public var narratorTriggers:FlxGroup;
		
		[Embed(source="../data/sfx/intro/Intro-001.mp3"] static public var Intro_001:Class;
		[Embed(source="../data/sfx/intro/Intro-002.mp3"] static public var Intro_002:Class;
		[Embed(source="../data/sfx/intro/Intro-003.mp3"] static public var Intro_003:Class;
		[Embed(source="../data/sfx/intro/Intro-004.mp3"] static public var Intro_004:Class;
		[Embed(source="../data/sfx/intro/Intro-005.mp3"] static public var Intro_005:Class;
		[Embed(source="../data/sfx/intro/Intro-006.mp3"] static public var Intro_006:Class;
		[Embed(source="../data/sfx/intro/Intro-007.mp3"] static public var Intro_007:Class;
		[Embed(source="../data/sfx/intro/Intro-008.mp3"] static public var Intro_008:Class;
		
		[Embed(source="../data/Level01_redux2.mp3"] static public var Level01_Redux:Class;
				
		override public function create():void
		{
			
			//FlxG.visualDebug = true;
			FlxG.bgColor = 0x263A3B;
			
			_titleCameraTimer = 0;
			
			_loadingBg = new FlxSprite();
			//_loadingBg.makeGraphic(FlxG.width, FlxG.height, 0xff263A3B);
			_loadingBg.loadGraphic(DataRegistry.load, false, false, 800, 500);
			_loadingBg.scrollFactor.x = _loadingBg.scrollFactor.y = 0;
			_loadingScreen = new LoadingScreen();
			add(_loadingScreen);
			
			_screenFade = new FlxSprite();
			_screenFade.makeGraphic(FlxG.width, FlxG.height, 0xff263A3B);
			_screenFade.scrollFactor.x = _screenFade.scrollFactor.y = 0;
			_screenFade.alpha = 0;
			
			//FlxG.watch(this, "_narrateCount", "Narrate Count");
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
					_inGame = true;
					FlxG.watch(this, "_narrateCount", "Narrate Count");
					FlxG.watch(this, "_nSound", "Narrate Sound");
				}
			}
			
			if(_inGame)
			{
				if(!_titleBool)
				{
					FlxG.mouse.hide();
					
				}
				if(_loadingBg.alpha > 0)
				{
					_loadingBg.alpha -= 0.01;
				}
				else
				{
					_loadingBg.alpha = 0;
					_loadingBg.exists = false;
				}
				
				if(_titleBool && _clickedPlay)
				{
					titleFade();
					
				}
				if (!_titleBool && _titleSequence)
				{
					_titleCameraTimer += FlxG.elapsed;
					_narrateTimer += FlxG.elapsed;
					FlxG.watch(this, "_narrateTimer", "Narrate Time");
					FlxG.watch(_narrator, "isNarrating", "isNarrating");
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(Intro_001);
						FlxG.playMusic(Level01_Redux);
						_nSound = true;
					}
					if(_narrateTimer >= 0)
					{
						if(_titleCamera.y < 800 && _narrateTimer < 11)
						{
							_titleCamera.velocity.y = 150;
						}
					}
					if(_narrateTimer >= 0.5 && _narrateTimer < 0.6)
					{
						_narrator.timeToDisplay = 5;
						if(!_narrator.isNarrating)
							_narrator.narrate("There once was a young girl who traveled the world seeking knowledge.");
					}
					
					if(_narrateTimer >= 6 && _narrateTimer < 6.1)
					{
						_narrator.timeToDisplay = 5.5;
						if(!_narrator.isNarrating)
							_narrator.narrate("Each new land held opportunity to teach her morals by which to live her life.");
					}
					if(_narrateTimer >= 9 && _narrateTimer < 11)
					{
						fadeOut();
					}
					if(_narrateTimer >= 11 && _narrateTimer < 11.1)
					{
						_titleCamera.y = 720;
						_titleCamera.velocity.y = 15;
						return;
					}
					if(_narrateTimer >= 12 && _narrateTimer < 14)
					{
						fadeIn();
					}
					if(_narrateTimer >= 12 && _narrateTimer < 12.1)
					{
						_narrator.timeToDisplay = 5.5;
						if(!_narrator.isNarrating)
							_narrator.narrate("One day, she came upon a strange wood and decided to explore it.");
					}
					if(_narrateTimer >= 17 && _narrateTimer < 17.1)
					{
						_titleSequence = false;
						_narrateTimer = 0;
						_player.cutscene = false;
						_playBool = true;
						_nSound = false;
					}
					if(_titleCamera.y >= 800)
					{
						_titleCamera.velocity.y = 0;
					}
				}
				
				FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height + 300);
				//FlxG.camera.bounds = new FlxRect(0, 0, 4832, map.height);
				
				//enable collision checking
				FlxG.collide(_player.position, map);
				FlxG.collide(_gator1a, _gatorBlocks);
				//specific collision handling
				FlxG.overlap(_player.position, _riverCameraTrigger, riverCamera);
				FlxG.overlap(_player.position, _cameraResetTriggers, resetCamera);
				FlxG.overlap(_player.position, _hangSensors, hang);
				FlxG.overlap(_player.position, narratorTriggers, narrator);
				FlxG.overlap(_player.position, _gator1a, gator);
				_gator1b.x = _gator1a.x;
				_gator1b.y = _gator1a.y;
				//gator logic
				if(_player.position.x > 2560 && _player.position.x < 3040)
				{
					_gator1a.x = (_player.position.x + _player.position.width / 2) - _gator1a.width / 2;
				}
				if(_player.position.y >= 1244 && !_gatorAttack)
				{
					_gatorAttack = true;
					_gator1a.alpha = 1;
					_gator1b.alpha = 1;
					_gator1a.velocity.y = -166;
				}
				else if(_player.position.y < 1244)
				{
					_gatorAttack = false;
					_gator1a.alpha = 0;
					_gator1b.alpha = 0;
				}
				if(_gatorAttack && _player.alive)
				{
					_gator1a.loadGraphic(DataRegistry.gator1a, false, false, 307, 365);
					_gator1a.scale.x = 0.5;
					_gator1a.scale.y = 0.5;
					_gator1a.width = 96;
					_gator1a.height = 32;
					_gator1a.offset.x = 110;
					_gator1a.offset.y = 224;
				}
				//checkpoints
				if(_player.position.x >= 2399)
				{
					_player.spawnPoint = new FlxPoint(2399, 736);
				}
				//checkpoints
				//death
				if(!_player.alive)
				{
					_respawnTimer += FlxG.elapsed;
					FlxG.watch(this, "_respawnTimer", "spawn timer");
					if(_respawnTimer >= 4)
					{
						_respawnTimer = 0;
						_player.position.reset(_player.spawnPoint.x, _player.spawnPoint.y);
						_player.alive = true;
						_player.respawn();
					}
				}
				//death
				//gator logic
				if(!_branch.broken)
				{
					FlxG.collide(_player.position, _branch);
					FlxG.overlap(_player.position, _branchSensor, branch);
				}
				else
				{
					FlxG.collide(_branch, map);
				}
				//test
				if(_riverCamera.pathSpeed == 0)
				{
					if(_player.position.x < 4532)
					{
						if(!_cameraBool && _playBool && _player.alive)
							FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
						else if(!_cameraBool && !_playBool)
							FlxG.camera.follow(_titleCamera, FlxCamera.STYLE_PLATFORMER);
					}
					else
					{
						FlxG.camera.active = false;
					}
				}
				//4992 endscene trigger
				if(_player.position.x >= 4992)
				{
					_player.cutscene = true;
				}
				//change levels
				if(FlxG.keys.justPressed("TWO"))
				{
					FlxG.switchState(new Level_01State());
				}
				else if(FlxG.keys.justPressed("THREE"))
				{
					FlxG.switchState(new Level_02State());
				}
				else if(FlxG.keys.justPressed("FOUR"))
				{
					FlxG.switchState(new Level_03State());
				}
				//move the clouds
				clouds();
				//narrator shit
				//1
				if(_narrateCount == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_002);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _narrateCount == 1)
				{
					_narrator.timeToDisplay = 5;
					if(!_narrator.isNarrating)
						_narrator.narrate("The girl long ago learned a little SPACE between herself and the ground...");
				}
				if(_narrateTimer >= 6 && _narrateTimer < 6.1 && _narrateCount == 1)
				{
					_narrator.timeToDisplay = 2;
					if(!_narrator.isNarrating)
						_narrator.narrate("...wasn't always a bad thing.");
				}
				if(_narrateTimer >= 8 && _narrateCount == 1)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//2
				if(_narrateCount == 3)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_003);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _narrateCount == 3)
				{
					_narrator.timeToDisplay = 4;
					if(!_narrator.isNarrating)
						_narrator.narrate("It was strenuous, but the girl knew if she kept her chin UP...");
				}
				if(_narrateTimer >= 5 && _narrateTimer < 5.1 && _narrateCount == 3)
				{
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("...she could overcome anything.");
				}
				if(_narrateTimer >= 8 && _narrateCount == 3)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//3
				if(_narrateCount == 5)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_004);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _narrateCount == 5)
				{
					_narrator.timeToDisplay = 4;
					if(!_narrator.isNarrating)
						_narrator.narrate("The girl knew that if you HOLD firm to what you learn...");
				}
				if(_narrateTimer >= 5 && _narrateTimer < 5.1 && _narrateCount == 5)
				{
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("...no SPACE is unsurpassable.");
				}
				if(_narrateTimer >= 8 && _narrateCount == 5)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//4
				if(_narrateCount == 7)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_005);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _narrateCount == 7)
				{
					_narrator.timeToDisplay = 3.5;
					if(!_narrator.isNarrating)
						_narrator.narrate("Lessons are not given, they are taken.");
				}
				if(_narrateTimer >= 4 && _narrateCount == 7)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//5
				if(_narrateCount == 9)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_007);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _narrateCount == 9)
				{
					_narrator.timeToDisplay = 3.5;
					if(!_narrator.isNarrating)
						_narrator.narrate("She who is once deceived is doubly cautious.");
				}
				if(_narrateTimer >= 4 && _narrateCount == 9)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//5
				if(_narrateCount == 11)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_008);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _narrateCount == 11)
				{
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("The young girl wandered deeper into the forest...");
				}
				if(_narrateTimer >= 4 && _narrateCount == 11)
				{
					//_narrateCount++;
					//_narrateTimer = 0;
					//_nSound = false;
					_inGame = false;
					nextLevel();
				}
				//special
				if(_specialCount == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(!_nSound)
					{
						_nSound = true;
						FlxG.play(Intro_006);
					}
				}
				if(_narrateTimer >= 0 && _narrateTimer < 0.1 && _specialCount == 1)
				{
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("Once bitten, twice shy.");
				}
				if(_narrateTimer >= 4 && _specialCount == 1)
				{
					_specialCount++
					_narrateTimer = 0;
					_nSound = false;
				}
				//narrator shit
			}
			if(_endGame && !_narrator.isNarrating)
			{
				FlxG.switchState(new Level_01State());
			}
			
			//update after changes
			super.update();
		}
		public function narrator(Object1:FlxObject, Object2:FlxObject):void
		{
			FlxG.watch(this, "_narrateCount", "Narrate Count");
			Object2.kill();
			_narrateCount++;
		}
		public function gator(Object1:FlxObject, Object2:FlxObject):void
		{
			_gator1a.loadGraphic(DataRegistry.gator2, false, false, 307, 365);
			_gator1a.scale.x = 0.5;
			_gator1a.scale.y = 0.5;
			_gator1a.width = 96;
			_gator1a.height = 32;
			_gator1a.offset.x = 110;
			_gator1a.offset.y = 224;
			_gator1b.alpha = 0;
			_player.kill();
			if(_specialCount == 0)
				_specialCount = 1;
		}
		////////////////////
		//	old, rework ASAP
		////////////////////
		public function hang(Sprite1:FlxObject, Sprite2:FlxObject):void
		{
			if(Sprite1.acceleration.y > 0)
			{
				//fucking number wizardry
				//edge case bullshit etc.
				if(_player.facing == FlxObject.RIGHT)
				{
					if(FlxU.floor(Sprite1.x) == Sprite2.x && (FlxU.floor(Sprite1.y) == Sprite2.y || FlxU.floor(Sprite1.y) - 1 == Sprite2.y || FlxU.floor(Sprite1.y) + 1 == Sprite2.y || FlxU.floor(Sprite1.y) + 2 == Sprite2.y))
					{
						//hang time
						if(!_player.isHanging)
							_player.isHanging = true;
					}
				}
				if(_player.facing == FlxObject.LEFT)
				{
					if(FlxU.ceil(Sprite1.x) == Sprite2.x && (FlxU.floor(Sprite1.y) == Sprite2.y || FlxU.floor(Sprite1.y) - 1 == Sprite2.y || FlxU.floor(Sprite1.y) + 1 == Sprite2.y || FlxU.floor(Sprite1.y) + 2 == Sprite2.y))
					{
						//hang time
						if(!_player.isHanging)
							_player.isHanging = true;
					}
				}
			}
		}
		////////////////////
		//	old, rework ASAP
		////////////////////
		private function buildLevel():void
		{
			//creating
			switch(_loadStep)
			{
				//map
				case 0:
					_loadingScreen.loadingPercentage = 0;
					map = new FlxTilemapExt;
					map.loadMap(new DataRegistry.introLevelHits, DataRegistry.testMapTiles);
					FlxG.log("map loaded!");
					_loadStep++;
					break;
				//end branch
				case 1:
					_loadingScreen.loadingPercentage = 5;
					_loadStep++;
					break;
				//sky
				case 2:
					_loadingScreen.loadingPercentage = 10;
					skyY = new FlxTilemap();
					skyY.loadMap(new DataRegistry.introLevelSkyY, DataRegistry.skyYAxis01, 32, 1598, FlxTilemap.OFF, 0, 0);
					skyY.x = -800
					skyY.y = -1000;
					skyY.scrollFactor.y = 0.2;
					FlxG.log("skyY loaded!");
					clouds2 = new FlxSprite(100, -450);
					clouds2.loadGraphic(DataRegistry.clouds201, false, false, 844, 498);
					clouds2.scrollFactor.x = 0.1;
					clouds2.scrollFactor.y = 0.1;
					FlxG.log("clouds2 loaded!");
					
					clouds4 = new FlxSprite(clouds2.x + clouds2.width, -450);
					clouds4.loadGraphic(DataRegistry.clouds201, false, false, 844, 498);
					clouds4.scrollFactor.x = 0.1;
					clouds4.scrollFactor.y = 0.1;
					FlxG.log("clouds4 loaded!");
					
					clouds1 = new FlxSprite(-100, -1250);
					clouds1.loadGraphic(DataRegistry.clouds101, false, false, 1189, 592);
					clouds1.scrollFactor.x = 0.3;
					clouds1.scrollFactor.y = 0.3;
					FlxG.log("clouds1 loaded!");
					
					clouds3 = new FlxSprite(clouds1.x + clouds1.width, -1250);
					clouds3.loadGraphic(DataRegistry.clouds101, false, false, 1189, 592);
					clouds3.scrollFactor.x = 0.3;
					clouds3.scrollFactor.y = 0.3;
					FlxG.log("clouds3 loaded!");
					
					//add title card and butans
					title = new FlxSprite(0, 0);
					title.loadGraphic(DataRegistry.titleCard, false, false, 502, 420);
					title.x = (FlxG.width / 2 - title.width / 2);
					title.y = FlxG.height / 2 - title.height / 2 - 20;
					title.scrollFactor.x = 0;
					title.scrollFactor.y = 0;
					FlxG.log("title loaded!");
					_playButton = new FlxButton(0, 0, null, play);
					_playButton.loadGraphic(DataRegistry.playButton, false, false, 156, 44);
					_playButton.x = FlxG.width / 2 - _playButton.width / 2;
					_playButton.y = FlxG.height / 2 + 72;
					_playButton.scrollFactor.x = 0;
					_playButton.scrollFactor.y = 0;
					_playButton.onOver = function():void { _playButton.loadGraphic(DataRegistry.playOnOver, false, false, 156, 44); }
					_playButton.onOut = function():void { _playButton.loadGraphic(DataRegistry.playButton, false, false, 156, 44); }
					//title camera object and path
					_titleCamera = new FlxObject(32, -3776);
					_titleCamera.width = 32;
					_titleCamera.height = 96;
					_titleCamera.acceleration.y = 0;
					//_titleCameraPath = new FlxPath();
					/*
					_titleCameraPath.add(32, 100);
					_titleCameraPath.add(32, 200);
					_titleCameraPath.add(32, 400);
					_titleCameraPath.add(32, 600);
					_titleCameraPath.add(32, 700);
					_titleCameraPath.add(32, 800);
					*/
					_loadStep++;

					break;
				//bg layer 2
				case 3:
					_loadingScreen.loadingPercentage = 15;
					bg2 = new FlxSprite(-256, 69);
					bg2.loadGraphic(DataRegistry.bg201, false, false, 1483, 230);
					bg2.scrollFactor.x = 0.1;
					bg2.scrollFactor.y = 0.1;
					FlxG.log("bg2 loaded!");
					_loadStep++;
					break;
				//painted sky
				case 4:
					_loadingScreen.loadingPercentage = 20;
					paintedSky = new FlxSprite(500, -125);
					paintedSky.loadGraphic(DataRegistry.paintedSky01, false, false, 3139, 648);
					paintedSky.scrollFactor.x = 0.5;
					paintedSky.scrollFactor.y = 0.5;
					FlxG.log("paintedSky loaded!");
					_loadStep++;
					break;
				//bg layer 1
				case 5:
					_loadingScreen.loadingPercentage = 25;
					bg1 = new FlxSprite(-320, 275);
					bg1.loadGraphic(DataRegistry.bg101, false, false, 1226, 201);
					bg1.scrollFactor.x = 0.3;
					bg1.scrollFactor.y = 0.3;
					FlxG.log("bg1 loaded!");
					_loadStep++;
					break;
				//tree layer 1
				case 6:
					_loadingScreen.loadingPercentage = 30;
					trees1 = new FlxSprite(600, 200);
					trees1.loadGraphic(DataRegistry.trees101, false, false, 1708, 551);
					trees1.scrollFactor.x = 0.8;
					trees1.scrollFactor.y = 0.8;
					FlxG.log("trees1 loaded!");
					_loadStep++;
					break;
				//tree layer 2
				case 7:
					_loadingScreen.loadingPercentage = 35;
					trees2 = new FlxSprite(2350, -50);
					trees2.loadGraphic(DataRegistry.trees201, false, false, 1984, 834);
					trees2.scrollFactor.x = 0.8;
					trees2.scrollFactor.y = 0.8;
					FlxG.log("trees2 loaded!");
					_loadStep++;
					break;
				//waterfall
				case 8:
					_loadingScreen.loadingPercentage = 40;
					waterfall = new FlxSprite(1550, 275);
					waterfall.loadGraphic(DataRegistry.waterfall01, false, false, 2854, 1054);
					waterfall.scrollFactor.x = 0.7;
					waterfall.scrollFactor.y = 0.7;
					FlxG.log("waterfall loaded!");
					
					_loadStep++;
					break;
				//main
				case 9:
					_loadingScreen.loadingPercentage = 45;
					mg = new FlxSprite(-340, -1);
					mg.loadGraphic(DataRegistry.mg01, false, false, 5562, 1598);
					FlxG.log("mg loaded!");
					_branch = new Branch(4266, 832);
					FlxG.log("_branch loaded!");
					_loadStep++;
					break;
				//player
				case 10:
					_loadingScreen.loadingPercentage = 50;
					
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
					
					_player = new Player(32, 800, _playerGibs);
					_player.setLeftControl("LEFT");
					_player.setRightControl("RIGHT");
					_player.setUpControl("UP");
					_player.setDownControl("DOWN");
					_player.setAction1Control("SPACE");
					_player.setAction2Control("SHIFT");
					_player.cutscene = true;
					FlxG.log("_player loaded!");
					_loadStep++;
					break;
				//tree bark
				case 11:
					_loadingScreen.loadingPercentage = 55;
					bigTree = new FlxSprite(4022, 614);
					bigTree.loadGraphic(DataRegistry.bigTree01, false, false, 231, 252);
					FlxG.log("bigTree loaded!");
					_loadStep++;
					break;
				//fg static
				case 12:
					_loadingScreen.loadingPercentage = 60;
					fgStatic1 = new FlxSprite(750, 800);
					fgStatic1.loadGraphic(DataRegistry.fgStatic101, false, false, 1993, 764);
					fgStatic1.scrollFactor.x = 1.1;
					FlxG.log("fgStatic1 loaded!");
					fgStatic2 = new FlxSprite(3485, 1000);
					fgStatic2.loadGraphic(DataRegistry.fgStatic201, false, false, 2014, 524);
					fgStatic2.scrollFactor.x = 1.1;
					FlxG.log("fgStatic2 loaded!");
					_loadStep++;
					break;
				//fg bush
				case 13:
					_loadingScreen.loadingPercentage = 65;
					fgBush = new FlxSprite(2776, 1200);
					fgBush.loadGraphic(DataRegistry.fgBush01, false, false, 676, 472);
					fgBush.scrollFactor.x = 1.3;
					FlxG.log("fgBush loaded!");
					_loadStep++;
					break;
				//river camera
				case 14:
					_loadingScreen.loadingPercentage = 70;
					_riverCameraTrigger = new FlxObject(2560, 736, 32, 32);
					FlxG.log("_riverCameraTrigger loaded!");
					_riverCamera = new FlxObject(0, 0, 32, 96);
					FlxG.log("_riverCamera loaded!");
					_riverCameraPath = new FlxPath();
					FlxG.log("_riverCameraPath loaded!");
					_loadStep++;
					break;
				//camera resets
				case 15:
					_loadingScreen.loadingPercentage = 75;
					_cameraResetTriggers = new FlxGroup();
					_cameraResetTriggers.add(new FlxObject(2399, 736, 32, 32));
					_cameraResetTriggers.add(new FlxObject(3200, 992, 32, 32));
					_cameraResetTriggers.add(new FlxObject(2592, 1106, 448, 32));
					FlxG.log("_cameraResetTriggers loaded!");
					_resetCameraPath = new FlxPath();
					FlxG.log("_resetCameraPath loaded!");
					_loadStep++;
					break;
				//sensors
				case 16:
					_loadingScreen.loadingPercentage = 80;
					//hang sensors
					addSensors();
					FlxG.log("hang sensors loaded!");
					//branch sensors
					_branchSensor = new FlxObject(4324, 736);
					_branchSensor.width = _branchSensor.height = 32;
					FlxG.log("branch sensors loaded!");
					_loadStep++;
					narratorTriggers = new FlxGroup();
					narratorTriggers.add(new FlxObject(544, 768, 32, 96));
					narratorTriggers.add(new FlxObject(1344, 587, 32, 96));
					narratorTriggers.add(new FlxObject(2464, 736, 32, 96));
					narratorTriggers.add(new FlxObject(3200, 992, 32, 96));
					narratorTriggers.add(new FlxObject(4320, 896, 96, 32));
					narratorTriggers.add(new FlxObject(4992, 1024, 32, 96));
					break;
				//narrator sensors
				//coming soon!
				case 17:
					_loadingScreen.loadingPercentage = 85;
					
					_gatorBlocks = new FlxGroup();
					var floor:FlxObject = new FlxObject(2592, 1500, 448, 32);
					floor.immovable = true;
					floor.solid = true;
					var wallL:FlxObject = new FlxObject(2592, 1244, 32, 256);
					wallL.immovable = true;
					wallL.solid = true;
					var wallR:FlxObject = new FlxObject(3008, 1244, 32, 256);
					wallR.immovable = true;
					wallR.solid = true;
					_gatorBlocks.add(floor);
					_gatorBlocks.add(wallL);
					_gatorBlocks.add(wallR);
					
					_gator1b = new FlxSprite(2757, 1400);
					_gator1b.loadGraphic(DataRegistry.gator1b, false, false, 307, 365);
					_gator1b.scale.x = 0.5;
					_gator1b.scale.y = 0.5;
					_gator1b.width = 96;
					_gator1b.height = 32;
					_gator1b.offset.x = 110;
					_gator1b.offset.y = 224;
					_gator1b.alpha = 0;
					_gator1a = new FlxSprite(2757, 1200);
					_gator1a.loadGraphic(DataRegistry.gator1a, false, false, 307, 365);
					_gator1a.scale.x = 0.5;
					_gator1a.scale.y = 0.5;
					_gator1a.width = 96;
					_gator1a.height = 32;
					_gator1a.offset.x = 110;
					_gator1a.offset.y = 224;
					_gator1a.acceleration.y = 420;
					_gator1a.alpha = 0;
					_loadStep++;
					break;
				//overlay
				case 18:
					_loadingScreen.loadingPercentage = 90;
					overlay = new FlxSprite(0, 0);
					overlay.loadGraphic(DataRegistry.multiplyTexture, false, false, 800, 500);
					overlay.scrollFactor.x = 0;
					overlay.scrollFactor.y = 0;
					overlay.blend = "multiply";
					FlxG.log("overlay loaded!");
					_loadStep++;
					break;
				//border
				case 19:
					_loadingScreen.loadingPercentage = 95;
					border = new FlxSprite(0, 0);
					border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
					border.scrollFactor.x = 0;
					border.scrollFactor.y = 0;
					FlxG.log("border loaded!");
					_loadStep++;
					break;
				//narrator
				case 20:
					_loadingScreen.loadingPercentage = 100;
					_narrator = new Narrator(FlxG.camera.scroll.x + 16, FlxG.camera.scroll.y + FlxG.height - 50);
					FlxG.log("_narrator loaded!");
					_loadStep++;
					break;
				//add				
				case 21:
					_loadingScreen.loadingPercentage = 100;
					add(map);
					
					add(skyY);
					add(clouds1);
					add(clouds3);
					add(clouds2);
					add(clouds4);
					add(title);
					add(_playButton);
					add(_titleCamera);
					add(bg2);
					add(paintedSky);
					add(bg1);
					add(trees1);
					add(waterfall);
					add(trees2);
					add(mg);		
					add(_branch);
					add(_riverCameraTrigger);
					add(_cameraResetTriggers);	
					add(_gatorBlocks);
					add(_branchSensor);	
					add(narratorTriggers);
					add(_gator1b)
					add(_player);
					add(_gator1a);
					add(_playerGibs);
					add(bigTree);	
					add(fgStatic1);
					add(fgStatic2);
					add(fgBush);		
					add(overlay);
					add(_screenFade);
					add(border);
					add(_loadingBg);
					add(_narrator);
				
					FlxG.mouse.show(DataRegistry.cursor, 1, 0, -53);
					break;
			}
			return;
		}
		private function loadGame():void
		{
			if(_loadStep < 21)
			{
				buildLevel();
			}
			else
			{
				_loadingScreen.loadingPercentage = 100;
			}
		}
		private function addSensors():void
		{
			_hangSensors = new FlxGroup();
			var sensorsMap:FlxTilemapExt = new FlxTilemapExt;
			sensorsMap.loadMap(new DataRegistry.introLevelSensors, DataRegistry.testMapTiles, 32, 32);
			for(var ty:int = 0; ty < sensorsMap.heightInTiles; ty++)
			{
				for(var tx:int = 0; tx < sensorsMap.widthInTiles; tx++)
				{
					//sensors
					if(sensorsMap.getTile(tx, ty) == 1)
						_hangSensors.add(new FlxObject(tx*32, ty*32, 32, 32));
				}
			}
			add(_hangSensors);
		}
		private function riverCamera(Object1:FlxObject, Object2:FlxObject):void
		{			
			if(!_cameraBool)
			{
				_riverCamera.stopFollowingPath(true);
				_riverCamera.x = _player.position.x;
				_riverCamera.y = _player.position.y;
				_riverCameraPath = new FlxPath();
				_riverCameraPath.add(_riverCamera.x + _riverCamera.width / 2, _riverCamera.y + _riverCamera.height / 2);
				_riverCameraPath.add(_riverCamera.x + _riverCamera.width / 2 + 320, _riverCamera.y + _riverCamera.height / 2 + 120);
				add(_riverCamera);
				_cameraBool = true;
				_player.cameraBool = true;
				FlxG.camera.follow(_riverCamera, FlxCamera.STYLE_PLATFORMER);
				_riverCamera.followPath(_riverCameraPath, _player.position.maxVelocity.x * 2, FlxObject.PATH_FORWARD);
			}
		}
		private function resetCamera(Object1:FlxObject, Object2:FlxObject):void
		{
			if(_cameraBool)
			{
				_riverCamera.stopFollowingPath(true);
				_cameraBool = false;
				_player.cameraBool = false;
				_resetCameraPath = new FlxPath();
				_resetCameraPath.add(_riverCamera.x + _riverCamera.width / 2, _riverCamera.y + _riverCamera.height / 2);
				_resetCameraPath.add(_player.position.x + _player.position.width / 2, _player.position.y + _player.position.height / 2);
				_riverCamera.followPath(_resetCameraPath, 1500, FlxObject.PATH_FORWARD);
			}
		}
		private function play():void
		{
			_clickedPlay = true;
			_playButton.loadGraphic(DataRegistry.playButton, false, false, 156, 44);
			_playButton.active = false;
		}
		private function nextLevel():void
		{
			_inGame = false;
			fadeOut();
		}
		private function fadeIn():void
		{
			border.alpha = 1;
			if(_screenFade.alpha != 0)
			{
				_screenFade.alpha -= 0.01;
			}
		}
		private function fadeOut():void
		{
			if(_screenFade.alpha != 1)
			{
				_screenFade.alpha += 0.01;
			}
			else
			{
				border.alpha = 0;
				if(!_inGame && !_endGame)
				{
					
					//_narrateCount++;
					_endGame = true;
				}
			}
		}
		private function titleFade():void
		{
			if (title.alpha > 0)
			{
				
				title.alpha -= 0.01;
				_playButton.alpha -= 0.01;
			}
			else
			{
				title.exists = false;
				_playButton.exists = false;
				_titleBool = false;
				
			}
		}
		private function clouds():void
		{
			//loop clouds forever!
			clouds1.velocity.x = -15;
			clouds3.velocity.x = -15;
			clouds2.velocity.x = -5;
			clouds4.velocity.x = -5;
			
			if(clouds1.x + clouds1.width < -1189)
			{
				clouds1.x = clouds3.x + clouds1.width;
			}
			if(clouds2.x + clouds2.width < -844)
			{
				clouds2.x = clouds4.x + clouds2.width; 
			}
			
			if(clouds3.x + clouds2.width < -1189)
			{
				clouds3.x = clouds1.x + clouds3.width;
			}
			if(clouds4.x + clouds4.width < -844)
			{
				clouds4.x = clouds2.x + clouds4.width;
			}
			
		}
		private function branch(o1:FlxObject, o2:FlxObject):void
		{
			_branch.snap();
		}
	}
}