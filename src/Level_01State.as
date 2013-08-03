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
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	public class Level_01State extends FlxState
	{
		
		public var map:FlxTilemapExt;
		public var mg:FlxSprite;
		public var bg4:FlxSprite;
		public var bg1:FlxSprite;
		public var bg2:FlxSprite;
		public var bg3:FlxSprite;
		public var fg:FlxSprite;
		public var inventory:Item;
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		
		//load screen!
		private var _loadingScreen:LoadingScreen;
		private var _loadingBg:FlxSprite;
		private var _loadStep:int = 0;
		public var _inGame:Boolean = false;
		private var _endGame:Boolean = false;
		private var _screenFade:FlxSprite;
		
		private var _player:Player;
		private var _playerHead:FlxObject;
		private var _playerGibs:FlxEmitter;
		private var _hangSensors:FlxGroup;
		private var _items:FlxGroup;
		private var _meat:FlxGroup;
		private var _itemSpawns:Array;
		
		//branches
		private var _branch1:Branch;
		private var _branch2:Branch;
		private var _branch3:Branch;
		private var _branchSensors:FlxGroup;
		
		//items
		private var _meat1:Item;
		private var _meat2:Item;
		
		private var _narrator:Narrator;
		
		private var _wolf:Wolf;
		private var _wolfWall:FlxObject;
		private var _wolfFloor:FlxObject;
		public var _wolfTimer:Number = 0;
		
		//misc
		private var _intro:Boolean = true;
		public var _respawnTimer:Number = 0;
		private var _crystal:FlxObject;
		
		public var _narrateTimer:Number = 0;
		public var _narrateCount:Number = 0;
		public var _specialCount:Number = 0;
		public var _wolfCount:Number = 0;
		public var _chocolate:Number = 0;
		public var _chocolateFeed:Number = 0;
		public var _bone:Number = 0;
		public var _boneFeed:Number = 0;
		public var _flower:Number = 0;
		public var _flowerFeed:Number = 0;
		public var _meatC:Number = 0;
		public var _nSound:Boolean = false;
		public var narratorTriggers:FlxGroup;
		
		[Embed(source="../data/sfx/puzzle1/P1-001.mp3"] static public var P1_001:Class;
		[Embed(source="../data/sfx/puzzle1/P1-002.mp3"] static public var P1_002:Class;
		[Embed(source="../data/sfx/puzzle1/P1-003.mp3"] static public var P1_003:Class;
		[Embed(source="../data/sfx/puzzle1/P1-004-alt.mp3"] static public var P1_004:Class;
		[Embed(source="../data/sfx/puzzle1/P1-005.mp3"] static public var P1_005:Class;
		[Embed(source="../data/sfx/puzzle1/P1-006-alt.mp3"] static public var P1_006:Class;
		[Embed(source="../data/sfx/puzzle1/P1-007.mp3"] static public var P1_007:Class;
		[Embed(source="../data/sfx/puzzle1/P1-008.mp3"] static public var P1_008:Class;
		[Embed(source="../data/sfx/puzzle1/P1-009.mp3"] static public var P1_009:Class;
		[Embed(source="../data/sfx/puzzle1/P1-010.mp3"] static public var P1_010:Class;
		[Embed(source="../data/sfx/puzzle1/P1-011.mp3"] static public var P1_011:Class;
		[Embed(source="../data/sfx/puzzle1/P1-012.mp3"] static public var P1_012:Class;
		
		
		
		override public function create():void
		{
			//FlxG.visualDebug = true;
			FlxG.mouse.hide();
			
			_loadingBg = new FlxSprite();
			_loadingBg.loadGraphic(DataRegistry.load, false, false, 800, 500);
			_loadingBg.scrollFactor.x = _loadingBg.scrollFactor.y = 0;
			
			_loadingScreen = new LoadingScreen();
			add(_loadingScreen);
			
			_screenFade = new FlxSprite();
			_screenFade.makeGraphic(FlxG.width, FlxG.height, 0xff263A3B);
			_screenFade.scrollFactor.x = _screenFade.scrollFactor.y = 0;
			_screenFade.alpha = 0;
			
			FlxG.watch(this, "_narrateTimer", "Narrate Time");
			//FlxG.watch(_narrator, "isNarrating", "isNarrating");
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
				}
			}
			if(_inGame)
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
				if(_intro && _loadingBg.exists)
				{
					_player.active = false;
				}
				if(_intro && !_loadingBg.exists)
				{
					_narrateTimer += FlxG.elapsed;
					_player.active = true;
					_player.cutscene = true;
					_player.position.velocity.x = _player.position.maxVelocity.x;
					
				}
				if(_intro && _player.position.x >= 64)
				{
					_intro = false;
					_player.position.velocity.x = 0;
				}
				if(!_intro && _narrateCount == 0)
				{
					_narrateTimer += FlxG.elapsed;
				}
				if(_narrateTimer > 0 && !_nSound && _narrateCount == 0)
				{
					FlxG.play(P1_001);
					_nSound = true;
				}
				if(_narrateTimer >= 1 && _narrateTimer < 1.1 && _narrateCount == 0)
				{
					_narrator.timeToDisplay = 3.5;
					if(!_narrator.isNarrating)
						_narrator.narrate("The forest had grown thicker around her and the girl realized...");
				}
				if(_narrateTimer >= 5 && _narrateTimer < 5.1 && _narrateCount == 0)
				{
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("...this wood was no stranger to visitors.");
				}
				if(_narrateTimer >= 8.5 && _narrateTimer < 8.6 && _narrateCount == 0)
				{
					_player.cutscene = false;
					_narrator.timeToDisplay = 6;
					if(!_narrator.isNarrating)
						_narrator.narrate("She traveled deeper without concern for danger, instead seeing a chance to learn more.");
				}
				if(_narrateTimer >= 16 && _narrateTimer < 16.1 && _narrateCount == 0)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//checkpoints
				if(_player.position.x >= 1024 && (_player.position.y <= 1312 && _player.position.y > 1250))
				{
					_player.spawnPoint = new FlxPoint(1024, 1312);
				}
				else if(_player.position.x >= 1632 && (_player.position.y <= 1088 && _player.position.y > 1000))
				{
					_player.spawnPoint = new FlxPoint(1632, 1088);
				}
				else if(_player.position.x <= 1696 && (_player.position.y <= 705 && _player.position.y > 620))
				{
					_player.spawnPoint = new FlxPoint(1632, 1088);
				}
				//checkpoints
				//death
				if(_wolf.isSnarling)
				{
					_wolfTimer += FlxG.elapsed;
					if(_wolfTimer >= 2)
					{
						if(_player.alive)
						{
							_wolfTimer = 0;
							_wolf.loadGraphic(DataRegistry.wolf, true, true, 348, 165);
							_wolf.offset.x = 112;
							_wolf.offset.y = 14;
							_wolf.isSnarling = false;
						}
						FlxG.log("BAD");
						_player.spawnPoint = new FlxPoint(64, 1314);
						_player.kill();
						_player.cutscene = false;
						
					}
					
				}
				else if(_wolf.isSleeping)
				{
					_wolfTimer += FlxG.elapsed;
					if(_wolfTimer >= 2)
					{
						_wolfTimer = 0;
						FlxG.log("Good");
						
					}
				}
				//death
				//hang 2.0
				if(!_player.isClimbing)
				{
					if(_player.facing == FlxObject.LEFT)
					{
						_playerHead.x = _player.position.x;
						_playerHead.y = _player.position.y;
					}
					else if(_player.facing == FlxObject.RIGHT)
					{
						_playerHead.x = _player.position.x + 24;
						_playerHead.y = _player.position.y;
					}
					
				}
				else
				{
					_playerHead.x = 0
					_playerHead.y = 0
				}
				
				
				FlxG.camera.bounds = new FlxRect(0, 0, map.width, map.height);
				FlxG.worldBounds = new FlxRect(-64, 0, map.width + 256, map.height);
				//enable collision checking
				if(!_intro)
				{
					if(_player.position.velocity.y == _player.position.maxVelocity.y)
					{
						FlxG.collide(_player.position, map, mapDeath);
					}
					else
					{
						FlxG.collide(_player.position, map);
					}
					
				}
				
				FlxG.collide(_player.position, _wolfWall);
				FlxG.collide(_player.position, _wolfFloor);
				if(!_wolf.isSleeping)
				{
					FlxG.collide(_player.position, _wolf, wolf);
				}
				FlxG.collide(_items, map, toggleItem);
				FlxG.collide(_meat, map);
				//specific collision handling
				FlxG.overlap(_playerHead, _hangSensors, hang);
				FlxG.overlap(_player.position, _branchSensors, branch);
				FlxG.overlap(_player.position, narratorTriggers, narrator);
				FlxG.overlap(_player.position, _crystal, mapDeath);
				//items
				FlxG.overlap(_player.position, _items, item);
				//meat
				FlxG.overlap(_player.position, _meat, meat);
				//death
				if(!_player.alive)
				{
					_respawnTimer += FlxG.elapsed;
					if(_respawnTimer >= 2)
					{
						_respawnTimer = 0;
						_player.position.reset(_player.spawnPoint.x, _player.spawnPoint.y);
						_player.alive = true;
						_player.respawn();
					}
				}
				//death
				//branches
				if(_branch1.broke < 0.33)
					FlxG.collide(_player.position, _branch1);
				else
					FlxG.collide(_branch1, map);
				if(_branch2.broke < 0.33)
					FlxG.collide(_player.position, _branch2);
				else
					FlxG.collide(_branch2, map);
				if(_branch3.broke < 0.33)
					FlxG.collide(_player.position, _branch3);
				else
					FlxG.collide(_branch3, map);
				//change levels
				if(FlxG.keys.justPressed("ONE"))
				{
					FlxG.switchState(new IntroLevel_01State());
				}
				else if(FlxG.keys.justPressed("THREE"))
				{
					FlxG.switchState(new Level_02State());
				}
				//narrator shit
				//wolf
				if(_wolfCount == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						_player.cutscene = true;
						_player.position.velocity.x = 0;
						_player.position.acceleration.x = 0;
						FlxG.play(P1_004);
						_nSound = true;
					}
					if(_narrateTimer >= 1 && _narrateTimer < 1.1)
					{						
						_narrator.timeToDisplay = 5;
						if(!_narrator.isNarrating)
							_narrator.narrate("Before long, the girl found herself confronted by a hungry looking wolf.");
					}
					if(_narrateTimer >= 7 && _narrateTimer < 7.1)
					{						
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("She knew to be wary of wolves - guardians of woodlands");
					}
					if(_narrateTimer >= 11 && _narrateTimer < 11.1)
					{						
						_narrator.timeToDisplay = 2;
						if(!_narrator.isNarrating)
							_narrator.narrate("...but they could usually be appeased.");
					}
					if(_narrateTimer >= 14 && _narrateTimer < 14.1)
					{						
						_player.cutscene = false;
						_narrator.timeToDisplay = 5;
						if(!_narrator.isNarrating)
							_narrator.narrate("The woods were littered with things of use, she just needed to find the right one.");
					}
					if(_narrateTimer >= 20 && _narrateTimer < 20.1)
					{						
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("Do nothing without regard to the consequences...");
					}
					if(_narrateTimer >= 24 && _narrateTimer < 24.1)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("...for one man's meat may be another man's poison.");
					}
					if(_narrateTimer >= 28 && _narrateTimer < 28.1)
					{
						_wolfCount++;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				//chocolate
				if(_chocolate == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{

						FlxG.play(P1_007);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{						
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("Chocolate. A strange find.");
					}
					if(_narrateTimer >= 4 && _narrateTimer < 4.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("A child could live in a house of the stuff and still not leave it behind.");
					}
					if(_narrateTimer >= 9 && _narrateTimer < 9.1)
					{
						_chocolate = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
					
				}
				if(_bone == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						
						FlxG.play(P1_008);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{						
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("A chicken bone. There was still a little meat stuck to it.");
					}
					if(_narrateTimer >= 5 && _narrateTimer < 5.1)
					{
						_bone = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_flower == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						
						FlxG.play(P1_009);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{						
						_narrator.timeToDisplay = 5.5;
						if(!_narrator.isNarrating)
							_narrator.narrate("The girl had seen this plant before. She’d been told never to eat it.");
					}
					if(_narrateTimer >= 6 && _narrateTimer < 6.1)
					{
						_flower = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_meatC == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P1_003);
						_nSound = true;
					}
					if(_narrateTimer >= 0.3 && _narrateTimer < 0.4)
					{						
						_narrator.timeToDisplay = 6.5;
						if(!_narrator.isNarrating)
							_narrator.narrate("The desire for imaginary benefits often involves the loss of present blessings.");
					}
					if(_narrateTimer >= 8 && _narrateTimer < 8.1)
					{
						_meatC = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_wolfCount == 2)
				{
					if(_chocolateFeed == 1)
					{
						_narrateTimer += FlxG.elapsed;
						if(_narrateTimer > 0 && !_nSound)
						{
							
							FlxG.play(P1_010);
							_nSound = true;
						}
						if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
						{						
							_narrator.timeToDisplay = 4;
							if(!_narrator.isNarrating)
								_narrator.narrate("Chocolate and canines are a poor mix.");
						}
						if(_narrateTimer >= 5 && _narrateTimer < 5.1)
						{
							_chocolateFeed = 0;
							_narrateTimer = 0;
							_nSound = false;
						}
					}
					if(_flowerFeed == 1)
					{
						_narrateTimer += FlxG.elapsed;
						if(_narrateTimer > 0 && !_nSound)
						{
							_player.cutscene = true;
							_player.position.velocity.x = 0;
							_player.position.acceleration.x = 0;
							FlxG.play(P1_012);
							_nSound = true;
						}
						if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
						{						
							_narrator.timeToDisplay = 4;
							if(!_narrator.isNarrating)
								_narrator.narrate("Ah, a plant poisonous to men sated the wolf’s hunger...");
						}
						if(_narrateTimer >= 5 && _narrateTimer < 5.1)
						{
							_narrator.timeToDisplay = 3;
							if(!_narrator.isNarrating)
								_narrator.narrate("...but he seemed to grow weaker from the meal.");
						}
						if(_narrateTimer >= 9 && _narrateTimer < 9.1)
						{
							_narrator.timeToDisplay = 1;
							if(!_narrator.isNarrating)
								_narrator.narrate("Oh dear.");
						}
						if(_narrateTimer >= 11 && _narrateTimer < 11.1)
						{
							_narrator.timeToDisplay = 2;
							if(!_narrator.isNarrating)
								_narrator.narrate("He... went to sleep?");
						}
						if(_narrateTimer >= 14 && _narrateTimer < 14.1)
						{
							_narrator.timeToDisplay = 1;
							if(!_narrator.isNarrating)
								_narrator.narrate("That's not really...");
						}
						if(_narrateTimer >= 16 && _narrateTimer < 16.1)
						{
							_narrator.timeToDisplay = 4;
							if(!_narrator.isNarrating)
								_narrator.narrate("Well, uh, let's not make much ado about nothing.");
						}
						if(_narrateTimer > 21 && _narrateTimer < 21.1)
						{
							_player.cutscene = false;
							_narrator.timeToDisplay = 4;
							if(!_narrator.isNarrating)
								_narrator.narrate("The girl found she was free to continue further into the forest.");
						}
						if(_narrateTimer > 26 && _narrateTimer < 26.1)
						{
							_wolfWall.kill();
							_flowerFeed = 0;
							_narrateTimer = 0;
							_nSound = false;
							_wolfCount = 3;
						}
					}
					if(_boneFeed == 1)
					{
						_narrateTimer += FlxG.elapsed;
						if(_narrateTimer > 0 && !_nSound)
						{
							FlxG.play(P1_011);
							_nSound = true;
						}
						if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
						{						
							_narrator.timeToDisplay = 6;
							if(!_narrator.isNarrating)
								_narrator.narrate("The bones of birds and young girls shatter a bit too easily...");
						}
						if(_narrateTimer >= 7 && _narrateTimer < 7.1)
						{
							_narrator.timeToDisplay = 4;
							if(!_narrator.isNarrating)
								_narrator.narrate("It seemed no one survived the meal.");
						}
						if(_narrateTimer >= 12 && _narrateTimer < 12.1)
						{
							_boneFeed = 0;
							_narrateTimer = 0;
							_nSound = false;
						}
					}
				}
				
				//narrator shit
				//adjust scrolling
				if(!_player.isClimbing)
				{
					FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
				}
				if(_player.position.x >= 3456)
				{
					_player.cutscene = true;
					_player.position.velocity.x = 0;
					nextLevel();
				}
			}
			//endpoint - 3456
			if(_endGame)
			{
				FlxG.switchState(new Level_02State());
			}
			//update after changes
			super.update();
		}
		public function narrator(Object1:FlxObject, Object2:FlxObject):void
		{
			FlxG.watch(this, "_narrateCount", "Narrate Count");
			if(Object2.x == 3104)
			{
				if(_wolfCount == 0)
				{
					_wolfCount = 1;
				}
				if(_wolfCount == 2 && _player._heldItem.type != ItemType.EMPTY)
				{
					if(_player._heldItem.type == ItemType.BONE || _player._heldItem.type == ItemType.CHOCOLATE)
					{
						if(_player._heldItem.type == ItemType.BONE)
						{
							_boneFeed = 1;
						}
						else if(_player._heldItem.type == ItemType.CHOCOLATE)
						{
							_chocolateFeed = 1;
						}
						_wolf.loadGraphic(DataRegistry.wolfSnarl, false, true, 333, 149);
						_wolf.width = 96;
						_wolf.height = 96;
						_wolf.offset.y = 5;
						_wolf.offset.x = 106;
						_wolf.isSnarling = true;
					}
					if(_player._heldItem.type == ItemType.LEAVES)
					{
						_flowerFeed = 1;
						_wolf.loadGraphic(DataRegistry.wolfSleeping, false, true, 333, 105);
						_wolf.width = 96;
						_wolf.height = 96;
						_wolf.offset.x = 108;
						_wolf.offset.y = -30;
						_wolf.isSleeping = true;
					}
					
					_player._heldItem.type = ItemType.EMPTY;
					inventory.type = _player._heldItem.type;
					inventory.checkType();
				}
			}
			else
			{
				Object2.kill();
				_narrateCount++;
			}
			
		}
		public function hang(Sprite1:FlxObject, Sprite2:FlxObject):void
		{
			if(_player.position.velocity.y > 0)
			{
				if(!_player.isHanging)
				{
					_player.position.y = Sprite2.y;
					_player.isHanging = true;
				}
			}
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
					map.loadMap(new DataRegistry.level01Hits, DataRegistry.testMapTiles);
					bg4 = new FlxSprite(0,0);
					bg4.makeGraphic(FlxG.width, FlxG.height, 0xff070C10);
					bg4.scrollFactor.x = bg4.scrollFactor.y = 0;
					_crystal = new FlxObject(1472, 1504, 448, 448);
					FlxG.log("map loaded!");
					_loadStep++;
					break;
				//mg
				case 1:
					_loadingScreen.loadingPercentage = 20;
					mg = new FlxSprite(0, 256);
					mg.loadGraphic(DataRegistry.mg02, false, false, 3424, 1668);
					FlxG.log("mg loaded!");
					//case 2
					fg = new FlxSprite(0,1286);
					fg.loadGraphic(DataRegistry.fg02, false, false, 3424, 646);
					//case 3
					bg1 = new FlxSprite(-1000, -200);
					bg1.loadGraphic(DataRegistry.bg102, false, false, 3424, 1373);
					bg1.scrollFactor.x = 0.6;
					bg1.scrollFactor.y = 0.6;		
					//case 4
					bg2 = new FlxSprite(0, -155);
					bg2.loadGraphic(DataRegistry.bg202, false, false, 3424, 996);
					bg2.scrollFactor.x = 0.4;
					bg2.scrollFactor.y = 0.4;
					//case 5
					bg3 = new FlxSprite(-55, 55);
					bg3.loadGraphic(DataRegistry.bg302, false, false, 3424, 895);
					bg3.scrollFactor.x = 0.3;
					bg3.scrollFactor.y = 0.3;
					//other case
					_branch1 = new Branch(1832, 1346,1);
					_branch1.sprite.loadGraphic(DataRegistry.branch1, false, false, 139, 36);
					_branch2 = new Branch(2044, 927, 2);
					_branch2.sprite.loadGraphic(DataRegistry.branch2, false, false, 130, 25);
					_branch3 = new Branch(1120, 768, 3);
					_branch3.sprite.scale.x = 1.2;
					_branch3.sprite.scale.y = 1.0;
					_branchSensors = new FlxGroup();
					var s1:FlxObject = new FlxObject(_branch1.sprite.x, _branch1.sprite.y, _branch1.sprite.width, 3);
					var s2:FlxObject = new FlxObject(_branch2.sprite.x, _branch2.sprite.y, _branch2.sprite.width, 3);
					var s3:FlxObject = new FlxObject(_branch3.sprite.x, _branch3.sprite.y, _branch3.sprite.width, 3);
					_branchSensors.add(s1);
					_branchSensors.add(s2);
					_branchSensors.add(s3);
					_loadStep++;
					break;
				//player
				case 2:
					_loadingScreen.loadingPercentage = 40;
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
					
					_player = new Player(-32, 1214, _playerGibs);
					_player._heldItem = new Item(0,0,0);
					_player.setLeftControl("LEFT");
					_player.setRightControl("RIGHT");
					_player.setUpControl("UP");
					_player.setDownControl("DOWN");
					_player.setAction1Control("SPACE");
					_player.setAction2Control("SHIFT");
					_player.spawnPoint = new FlxPoint(64, 1314);
					_playerHead = new FlxObject(_player.position.x, _player.position.y, 8, 1);
					FlxG.log("_player loaded!");
					
					//yet another step
					_items = new FlxGroup();
					var i1:Item = new Item(1360, 1440, ItemType.CHOCOLATE);
					_items.add(i1);
					var i2:Item = new Item(2528, 1152, ItemType.BONE);
					_items.add(i2);
					var i3:Item = new Item(944, 672, ItemType.PLANT);
					_items.add(i3);
					FlxG.watch(_items.members, "length", "Items count");
					_meat = new FlxGroup();
					var m1:Item = new Item(803, 704, ItemType.MEAT);
					_meat.add(m1);
					var m2:Item = new Item(2127, 1568, ItemType.MEAT);
					_meat.add(m2);
					_itemSpawns = new Array();
					_itemSpawns.push(new FlxPoint(i1.x, i1.y));
					_itemSpawns.push(new FlxPoint(i2.x, i2.y));
					_itemSpawns.push(new FlxPoint(i3.x, i3.y));
					inventory = new Item();
					inventory.type = ItemType.EMPTY;
					inventory.x = FlxG.width - inventory.width * 4;
					inventory.y = inventory.height / 2 + 8;
					inventory.acceleration.y = 0;
					inventory.scrollFactor.x = inventory.scrollFactor.y = 0;
					//yet another step
					_wolf = new Wolf(3200, 1216);
					_wolf.facing = FlxObject.LEFT;
					_wolfWall = new FlxObject(map.width - 32, 1120, 32, 192);
					_wolfWall.immovable = true;
					_wolfFloor = new FlxObject(map.width - 32, 1216 + 96, 256, 32);
					_wolfFloor.immovable = true;
					_loadStep++;
					break;
				//sensors
				case 3:
					_loadingScreen.loadingPercentage = 60;
					//hang
					addSensors();
					FlxG.log("hang sensors loaded!");
					narratorTriggers = new FlxGroup();
					//wolf
					narratorTriggers.add(new FlxObject(3104, 1216, 32, 96));
					_loadStep++;
					break;
				//overlay
				case 4:
					_loadingScreen.loadingPercentage = 70;
					overlay = new FlxSprite(0, 0);
					overlay.loadGraphic(DataRegistry.multiplyTexture, false, false, 800, 500);
					overlay.scrollFactor.x = 0;
					overlay.scrollFactor.y = 0;
					overlay.blend = "multiply";
					FlxG.log("overlay loaded!");
					_loadStep++;
					break;
				//border
				case 5:
					_loadingScreen.loadingPercentage = 80;
					border = new FlxSprite(0, 0);
					border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
					border.scrollFactor.x = 0;
					border.scrollFactor.y = 0;
					FlxG.log("border loaded!");
					_loadStep++;
					break;
				//narrator
				case 6:
					_loadingScreen.loadingPercentage = 100;
					_narrator = new Narrator(FlxG.camera.scroll.x + 16, FlxG.camera.scroll.y + FlxG.height - 50);
					FlxG.log("_narrator loaded!");
					_loadStep++;
					break;
				//add
				case 7:
					_loadingScreen.loadingPercentage = 100;
					FlxG.bgColor = 0xff070C10;
					add(map);
					
					add(bg4);
					add(bg3);
					add(bg2);
					add(bg1);
					add(mg);
					add(_meat);
					add(_branch1);
					add(_branch2);
					add(_branch3);
					add(_wolf)
					add(_wolfWall);
					add(_wolfFloor);
					add(_crystal);
					add(narratorTriggers);
					add(_player);
					add(_playerHead);
					add(_playerGibs);
					add(_items);
					add(_meat);
					add(fg);
					add(_branchSensors);
					add(_hangSensors);
					add(inventory);
					add(overlay);
					add(_screenFade);
					add(border);
					add(_loadingBg);
					add(_narrator);
					break;
			}
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
					
					//_narrator.narrate("The wolf was sleeping.  That's all.");
					_endGame = true;
				}
			}
		}
		private function addSensors():void
		{
			_hangSensors = new FlxGroup();
			var sensorsMapL:FlxTilemapExt = new FlxTilemapExt;
			var sensorsMapR:FlxTilemapExt = new FlxTilemapExt;
			sensorsMapL.loadMap(new DataRegistry.level01SensorsL, DataRegistry.testMapTiles, 32, 32);
			sensorsMapR.loadMap(new DataRegistry.level01SensorsR, DataRegistry.testMapTiles, 32, 32);
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
					{
						_hangSensors.add(new FlxObject(((rx-1)*32) + 2, ry*32, 32, 1));
						FlxG.log("Sensor at: " + (rx-1)*32 + 2 + ", " + ry*32);
					}
				}
			}
		}
		private function item(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object2 as Item;
			if(i.type == ItemType.CHOCOLATE)
			{
				if(_chocolate == 0)
					_chocolate = 1;
			}
			else if(i.type == ItemType.BONE)
			{
				if(_bone == 0)
					_bone = 1;
			}
			else if(i.type == ItemType.PLANT)
			{
				if(_flower == 0)
					_flower = 1;
			}
			if(i.type == ItemType.PLANT && inventory.type == ItemType.LEAVES)
			{
				return;
			}
			if(!i.overlap && i.pickup)
			{
				if(!(i.type == ItemType.PLANT && inventory.type == ItemType.LEAVES))
				{
					i.velocity.y = -200;
					i.overlap = true;
					i.pickup = false;
					if(_player._heldItem.type != ItemType.EMPTY)
					{
						var o:Item = new Item(_player.position.x, _player.position.y, _player._heldItem.type);
						for each(var p:Item in _items.members)
						{
							FlxG.log(p.type);
							FlxG.log(o.type);
							if(p.type == o.type)
							{
								_items.replace(p, o);
							}
						}
						if(_player.facing == FlxObject.LEFT)
						{
							o.velocity.x = 100;
						}
						else if(_player.facing == FlxObject.RIGHT)
						{
							o.velocity.x = -100;
						}
						o.pickup = false;
					}
					_player.pickupItem(i);
					FlxG.log("Picked up: " + i.name);
					if(_player._heldItem.type == ItemType.PLANT)
						_player._heldItem.type = ItemType.LEAVES;
					FlxG.log(_player._heldItem.name);
				}
			}
			inventory.type = _player._heldItem.type;
			inventory.checkType();
			FlxG.log(inventory.name);
		}
		private function meat(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object2 as Item;
			var count:Number = _items.members.length;
			if(_meatC == 0)
				_meatC = 1;
			if(!i.overlap && i.pickup)
			{
				FlxG.log("Picked up: " + i.name);
				
				i.overlap = true;
				i.pickup = false;
				i.velocity.y = -200;
				_player.pickupItem(new Item(0,0,ItemType.EMPTY));
				
				inventory.type = ItemType.EMPTY;
				inventory.checkType();
				
				
				FlxG.log(_player._heldItem.name);
				FlxG.log(inventory.type);
				
				//reposition items
				for(var n:Number = 0; n < count; n++)
				{
					var p:FlxPoint = _itemSpawns[n];
					var it:Item = _items.members[n];
					var o:Item = new Item(p.x, p.y, it.type);
					if(o.type == ItemType.LEAVES)
					{
						o.type = ItemType.PLANT;
					}
					it.x = p.x;
					it.y = p.y;
					it.active = true;
					it.overlap = false;
					it.alpha = 1;
				}
			}
		}
		private function mapDeath(Object1:FlxObject, Object2:FlxObject):void
		{
			_player.kill();
		}
		private function toggleItem(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object1 as Item;
			i.velocity.x = 0;
			i.pickup = true;
		}
		private function wolf(Object1:FlxObject, Object2:FlxObject):void
		{
			if(_player._heldItem.type != ItemType.EMPTY)
			{
				_player.cutscene = true;
				_player.position.velocity.x = 0;
				_player.position.acceleration.x = 0;
				_wolfTimer = 0;
				
				
				
			}
		}
		private function branch(Object1:FlxObject, Object2:FlxObject):void
		{
			if(!_player.isClimbing && !_player.isHanging && !_player.isJumping && !_player.isFalling && !_player.isSlowFalling)
			{
				//FlxG.log("hkdjfhdkjfhsljfdhf");
				for each(var s:FlxObject in _branchSensors.members)
				{
					if(Object2 == s)
					{
						Object2.active = false;
						if(s.x == _branch1.sprite.x && s.y == _branch1.sprite.y)
						{
							_branch1.snap();
						}
						else if(s.x == _branch2.sprite.x && s.y == _branch2.sprite.y)
						{
							_branch2.snap();
							for each(var x:FlxObject in _hangSensors.members)
							{
								if(x.y == 928)
								{
									if(x.exists)	
										x.exists = false;
								}
							}
						}
						else if(s.x == _branch3.sprite.x && s.y == _branch3.sprite.y)
						{
							_branch3.snap();
						}
					}
				}
			}
			
		}
	}
}