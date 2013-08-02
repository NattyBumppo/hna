package
{
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
	import org.flixel.FlxU;
	
	public class Level_02State extends FlxState
	{
		public var map:FlxTilemapExt;
		public var mg:FlxSprite;
		public var bg:FlxSprite;
		public var fg:FlxSprite;
		public var fg2:FlxSprite;
		public var fg3:FlxSprite;
		public var inventory:Item;
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		
		//load screen
		private var _loadingScreen:LoadingScreen;
		private var _loadingBg:FlxSprite;
		private var _loadStep:int = 0;
		public var _inGame:Boolean = false;
		private var _endGame:Boolean = false;
		private var _screenFade:FlxSprite;
		
		
		private var _player:Player;
		private var _playerHead:FlxObject;
		private var _playerGibs:FlxEmitter;
		private var _hasWisp:Boolean = false;
		private var _wispTaken:Boolean = false;
		private var _hangSensors:FlxGroup;
		private var _narrator:Narrator;
		
		private var _critters:FlxGroup;
		private var _tentacleCritter:Critter;
		
		private var _wispSpawns:FlxGroup;
		private var _wispCheck:Number = 0;
		private var _wispTimer:Number = 0;
		private var _wispIdle:Boolean = false;
		private var _wispPickup:Boolean = false;
		private var _wispPath1:FlxPath;
		private var _wispPath2:FlxPath;
		
		private var _trap:FlxSprite;
		private var _trapTimer:Number = 0;
		private var _rootWall:FlxObject;
		private var _petals:FlxEmitter;
		private var _items:FlxGroup;
		private var _dwarf:FlxSprite;
		private var _dwarfDead:Boolean = false;
		private var _wisp:FlxSprite;
		private var _raceTrigger:FlxObject;
		private var _tentacle:FlxSprite;
		private var _tentacleDeath:FlxObject;
		private var _tentacleAttack:Boolean = false;
		
		private var _tentacleCamera:FlxObject;
		private var _tentacleCameraFollow:Boolean = false;
		private var _tentacleCameraPath:FlxPath;
		private var _tentacleResetCameraPath:FlxPath;
		private var _tentacleCameraTriggers:FlxGroup;
		private var _tentacleCameraResets:FlxGroup;
		
		private var _crystal:FlxObject;
		private var _crystal2:FlxObject;
		private var _intro:Boolean = true;
		private var _endFloor:FlxObject;
		private var _startFloor:FlxObject;
		public var _respawnTimer:Number = 0;
		
		//misc
		public var _narrateTimer:Number = 0;
		public var _narrateCount:Number = 0;
		public var _specialCount:Number = 0;
		public var _trapNar:Number = 0;
		public var _headNar:Number = 0;
		public var _handleNar:Number = 0;
		public var _axNar:Number = 0;
		public var _dwarfNar:Number = 0;
		public var _kickNar:Number = 0;
		public var _rabbitNar:Number = 0;
		public var _fairyNar:Number = 0;
		public var _fairyGrabNar:Number = 0;
		public var _fairyWinNar:Number = 0;
		public var _fairyEatNar:Number = 0;
		public var _nSound:Boolean = false;
		public var narratorTriggers:FlxGroup;
		public var _fairyCamera:FlxObject;
		public var _fairyCameraPath:FlxPath;
		public var _fairyCameraResetPath:FlxPath;
		public var _fairyCameraFollow:Boolean = false;
		
		[Embed(source="../data/sfx/puzzle2/P2-001.mp3"] static public var P2_001:Class;
		[Embed(source="../data/sfx/puzzle2/P2-002-alt.mp3"] static public var P2_002:Class;
		[Embed(source="../data/sfx/puzzle2/P2-003.mp3"] static public var P2_003:Class;
		[Embed(source="../data/sfx/puzzle2/P2-004.mp3"] static public var P2_004:Class;
		[Embed(source="../data/sfx/puzzle2/P2-005.mp3"] static public var P2_005:Class;
		[Embed(source="../data/sfx/puzzle2/P2-006.mp3"] static public var P2_006:Class;
		[Embed(source="../data/sfx/puzzle2/P2-007.mp3"] static public var P2_007:Class;
		[Embed(source="../data/sfx/puzzle2/P2-008.mp3"] static public var P2_008:Class;
		[Embed(source="../data/sfx/puzzle2/P2-009.mp3"] static public var P2_009:Class;
		[Embed(source="../data/sfx/puzzle2/P2-010.mp3"] static public var P2_010:Class;
		[Embed(source="../data/sfx/puzzle2/P2-011.mp3"] static public var P2_011:Class;
		[Embed(source="../data/sfx/puzzle2/P2-012-alt.mp3"] static public var P2_012a:Class;
		[Embed(source="../data/sfx/puzzle2/P2-012.mp3"] static public var P2_012:Class;
		[Embed(source="../data/sfx/puzzle2/P2-013.mp3"] static public var P2_013:Class;
		[Embed(source="../data/sfx/puzzle2/P2-014.mp3"] static public var P2_014:Class;
		
		[Embed(source="../data/Level02.mp3"] static public var Level02:Class;
		
		override public function create():void
		{
			FlxG.mouse.hide();
			FlxG.playMusic(Level02);
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
				FlxG.camera.bounds = new FlxRect(0, 0, map.width, map.height);
				FlxG.worldBounds = new FlxRect(-96, 0, map.width + 256, map.height);
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
				if(_intro && _player.position.x >= 96)
				{
					_intro = false;
					_player.position.velocity.x = 0;
					_player.position.acceleration.x = 0;
				}
				if(!_intro && _narrateCount == 0)
				{
					_narrateTimer += FlxG.elapsed;
				}
				if(_narrateTimer > 0 && !_nSound && _narrateCount == 0)
				{
					FlxG.play(P2_001);
					_nSound = true;
				}
				if(_narrateTimer >= 1.5 && _narrateTimer < 1.6 && _narrateCount == 0)
				{
					_narrator.timeToDisplay = 2.5;
					if(!_narrator.isNarrating)
						_narrator.narrate("The forest grew darker and twilight fell");
				}
				if(_narrateTimer >= 5 && _narrateTimer < 5.1 && _narrateCount == 0)
				{
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("...but a change of scene does not change one's character.");
					
				}
				if(_narrateTimer >= 9 && _narrateTimer < 9.1 && _narrateCount == 0)
				{
					_player.cutscene = false;
					_narrator.timeToDisplay = 3;
					if(!_narrator.isNarrating)
						_narrator.narrate("The girl continued without fear.")
				}
				if(_narrateTimer >= 13 && _narrateTimer < 13.1 && _narrateCount == 0)
				{
					_narrateCount++;
					_narrateTimer = 0;
					_nSound = false;
				}
				//narration shit
				if(_trapNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_003);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("She tumbled into a trap no doubt left by the fairy folk");
					}
					if(_narrateTimer >= 5 && _narrateTimer < 5.1)
					{
						_trapNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_headNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_004);
						_nSound = true;
					}
					if(_narrateTimer >= 0.5 && _narrateTimer < 0.6)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("The head of an axe... but where was its handle?");
					}
					if(_narrateTimer >= 5 && _narrateTimer < 5.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("Well, half a loaf is better than no bread at all.");
					}
					if(_narrateTimer >= 10 && _narrateTimer < 10.1)
					{
						_headNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_axNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_007);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 5.5;
						if(!_narrator.isNarrating)
							_narrator.narrate("She combined both halves of the broken axe, finding that in union there is strength.");
					}
					if(_narrateTimer >= 6 && _narrateTimer < 6.1)
					{
						_narrator.timeToDisplay = 5;
						if(!_narrator.isNarrating)
							_narrator.narrate("The girl then had the means to escape the trap and continue her journey.");
					}
					if(_narrateTimer >= 12 && _narrateTimer < 12.1)
					{
						_axNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_rabbitNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_008);
						_nSound = true;
					}
					if(_narrateTimer >= 1 && _narrateTimer < 1.1)
					{
						_narrator.timeToDisplay = 5;
						if(!_narrator.isNarrating)
							_narrator.narrate("We learn by the misfortunes of others. Best to head back...");
					}
					if(_narrateTimer >= 7 && _narrateTimer < 7.1)
					{
						_rabbitNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_dwarfNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						_player.cutscene = true;
						_player.position.velocity.x = 0;
						_player.position.acceleration.x = 0;
						FlxG.play(P2_005);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("At a dead end she found a dwarf who had befallen the same fate.");
					}
					if(_narrateTimer >= 5 && _narrateTimer < 5.1)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("His injuries were too severe to help her find a way out.");
					}
					if(_narrateTimer >= 9 && _narrateTimer < 9.1)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("There is always someone worse off than yourself.");
					}
					if(_narrateTimer >= 13 && _narrateTimer < 13.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("...but perhaps he knew the location of the missing axe handle?");
					}
					if(_narrateTimer >= 18 && _narrateTimer < 18.1)
					{
						_player.cutscene = false;
						_dwarfNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_kickNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						_player.cutscene = true;
						FlxG.play(P2_006);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 1;
						if(!_narrator.isNarrating)
							_narrator.narrate("What are you-?!");
					}
					if(_narrateTimer >= 2 && _narrateTimer < 2.1)
					{
						_narrator.timeToDisplay = 3.75;
						if(!_narrator.isNarrating)
							_narrator.narrate("...it's easy to kick a man who is down, is it?");
					}
					if(_narrateTimer >= 10 && _narrateTimer < 10.1)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("...The girl asked nicely for the second half of the dwarf's axe.");
					}
					if(_narrateTimer >= 14 && _narrateTimer < 14.1)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("He kindly gave it to her.");
					}
					if(_narrateTimer >= 18 && _narrateTimer < 18.1)
					{
						_player.cutscene = false;
						_kickNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_fairyNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						_player.cutscene = true;
						_player.position.velocity.x = 0;
						_player.position.acceleration.x = 0;
						FlxG.play(P2_009);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("A fairy appeared before her, warning her of the danger ahead.");
					}
					if(_narrateTimer >= 5 && _narrateTimer < 5.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("The monster that lurked in the darkness had an insatiable appetite -");
					}
					if(_narrateTimer >= 10 && _narrateTimer < 10.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("The only thing it liked to eat more than little girls was light itself.");
					}
					if(_narrateTimer >= 15 && _narrateTimer < 15.1)
					{
						_fairyCamera.x = _player.position.x;
						_fairyCamera.y = _player.position.y;
						if(!_fairyCameraFollow)
						{
							_fairyCameraFollow = true;
						}
						_fairyCamera.followPath(_fairyCameraPath, 200, FlxObject.PATH_FORWARD);
						
						_narrator.timeToDisplay = 2;
						if(!_narrator.isNarrating)
							_narrator.narrate("The fairy challenged her to a race up the trees.");
					}
					if(_fairyCameraFollow)
					{
						FlxG.camera.follow(_fairyCamera, FlxCamera.STYLE_PLATFORMER);
					}
					if(_narrateTimer >= 18 && _narrateTimer < 18.1)
					{						
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("If the girl won, the fairy would give to her one petal of a flower made of fire.");
					}
					if(_narrateTimer >= 23 && _narrateTimer < 23.1)
					{						
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("The glow would distract the creature long enough for her to pass safely.");
					}
					if(_narrateTimer >= 27 && _narrateTimer < 27.1)
					{
						_fairyCameraResetPath = new FlxPath();
						_fairyCameraResetPath.add(_player.position.x + _player.position.width / 2, _player.position.y + _player.position.height / 2);
						_fairyCamera.followPath(_fairyCameraResetPath, 1500, FlxObject.PATH_FORWARD);
						
						_narrator.timeToDisplay = 1.5;
						if(!_narrator.isNarrating)
							_narrator.narrate("The girl agreed, remembering that");
					}
					if(_narrateTimer >= 29 && _narrateTimer < 29.1)
					{						
						_narrator.timeToDisplay = 6;
						if(!_narrator.isNarrating)
							_narrator.narrate("Only fools fight to exhaustion while the rogue runs off with the dinner.");
					}
					if(_narrateTimer >= 36 && _narrateTimer < 36.1)
					{						
						FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
						_player.cutscene = false;
						_fairyNar = 2;
						_narrateTimer = 0;
						_nSound = false;
						
						if(_wispCheck == 0)
						{
							var s1:FlxObject = _wispSpawns.members[_wispCheck];
							_wispCheck = 1;
							_wisp.followPath(_wispPath1, 100);
						}
					}
				}
				if(_fairyGrabNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_011);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 1.75;
						if(!_narrator.isNarrating)
							_narrator.narrate("The girl grabbed the fairy and-");
					}
					if(_narrateTimer >= 2.75 && _narrateTimer < 2.85)
					{
						_narrator.timeToDisplay = 1.75;
						if(!_narrator.isNarrating)
							_narrator.narrate("Wait, what are you doing?!");
					}
					if(_narrateTimer >= 5 && _narrateTimer < 5.1)
					{
						_narrator.timeToDisplay = 2;
						if(!_narrator.isNarrating)
							_narrator.narrate("Let go at once!!");
					}
					if(_narrateTimer >= 8 && _narrateTimer < 8.1)
					{
						_fairyGrabNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				else if(_fairyGrabNar == 2)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_012);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("Where do you think you’re going with-");
					}
					if(_narrateTimer >= 4 && _narrateTimer < 4.1)
					{
						_fairyGrabNar = 3;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				else if(_fairyGrabNar == 3)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_013);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("This is NOT what the moral means!");
					}
					if(_narrateTimer >= 4 && _narrateTimer < 4.1)
					{
						_fairyGrabNar = 4;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				else if(_fairyGrabNar == 4)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_012a);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 5;
						if(!_narrator.isNarrating)
							_narrator.narrate("The rogue was meant to run away with DINNER, not run away with THE FOOL!!");
					}
					if(_narrateTimer >= 6 && _narrateTimer < 6.1)
					{
						_fairyGrabNar = 5;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_fairyWinNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						_player.cutscene = true;
						_player.position.velocity.x = 0;
						_player.position.acceleration.x = 0;
						FlxG.play(P2_010);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate('."I win!" the mischievous fairy exclaimed.');
					}
					if(_narrateTimer >= 4 && _narrateTimer < 4.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("The girl wasn't sure how fair it was to race a creature that could fly.");
					}
					if(_narrateTimer >= 9 && _narrateTimer < 9.1)
					{
						_player.cutscene = false;
						_fairyWinNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				if(_fairyEatNar == 1)
				{
					_narrateTimer += FlxG.elapsed;
					if(_narrateTimer > 0 && !_nSound)
					{
						FlxG.play(P2_014);
						_nSound = true;
					}
					if(_narrateTimer >= 0.1 && _narrateTimer < 0.2)
					{
						_narrator.timeToDisplay = 2;
						if(!_narrator.isNarrating)
							_narrator.narrate("How DARE you!");
					}
					if(_narrateTimer >= 3 && _narrateTimer < 3.1)
					{
						_narrator.timeToDisplay = 2;
						if(!_narrator.isNarrating)
							_narrator.narrate("Is that how you want to be?");
					}
					if(_narrateTimer >= 6 && _narrateTimer < 6.1)
					{
						_narrator.timeToDisplay = 1;
						if(!_narrator.isNarrating)
							_narrator.narrate("All right, then.");
					}
					if(_narrateTimer >= 8 && _narrateTimer < 8.1)
					{
						_narrator.timeToDisplay = 3;
						if(!_narrator.isNarrating)
							_narrator.narrate("Now that the darkness had been conquered...");
					}
					if(_narrateTimer >= 12 && _narrateTimer < 12.1)
					{
						_narrator.timeToDisplay = 4;
						if(!_narrator.isNarrating)
							_narrator.narrate("She would have to face the darkness inside herself!");
					}
					if(_narrateTimer >= 17 && _narrateTimer < 17.1)
					{
						_fairyEatNar = 2;
						_narrateTimer = 0;
						_nSound = false;
					}
				}
				//narration shit
				//change levels
				//change levels
				if(FlxG.keys.justPressed("ONE"))
				{
					FlxG.switchState(new IntroLevel_01State());
				}
				else if(FlxG.keys.justPressed("TWO"))
				{
					FlxG.switchState(new Level_01State());
				}
				else if(FlxG.keys.justPressed("FOUR"))
				{
					FlxG.switchState(new Level_03State());
				}
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
				//FlxG.collide(_critters, map, critter);
				FlxG.collide(_tentacleCritter, map, critter);
				FlxG.collide(_player.position, _startFloor);
				FlxG.collide(_player.position, _endFloor);
				FlxG.collide(_items, map, toggleItem);
				FlxG.collide(_petals, map, petalGround);
				//specific collision handling
				FlxG.overlap(_playerHead, _hangSensors, hang);
				//if(!_player.cutscene)
					//FlxG.overlap(_player.position, _petals, petal);
				FlxG.overlap(_player.position, narratorTriggers, narrator);
				FlxG.overlap(_player.position, _items, item);
				FlxG.overlap(_player.position, _dwarf, dwarf);
				FlxG.overlap(_player.position, _tentacleDeath, tentacle);
				FlxG.overlap(_tentacleCritter, _tentacleDeath, tentacle);
				FlxG.overlap(_player.position, _tentacleCameraTriggers, tentaclePan);
				FlxG.overlap(_player.position, _tentacleCameraResets, tentacleReset);
				FlxG.collide(_player.position, _rootWall, root);
				FlxG.overlap(_player.position, _crystal, mapDeath);
				FlxG.overlap(_player.position, _crystal2, mapDeath);
				
				if(!_hasWisp && _wispPickup)
				{
					FlxG.overlap(_player.position, _wisp, wispPickup);
				}
				if(_trap.alpha == 1)
				{
					FlxG.collide(_items, _trap, toggleItem);
					FlxG.collide(_player.position, _trap, trap);
				}
				if(_tentacleCamera.path == _tentacleResetCameraPath && _tentacleCamera.pathSpeed == 0)
				{
					_tentacleCameraFollow = false;
				}
				if(_fairyCamera.path == _fairyCameraResetPath && _fairyCamera.pathSpeed == 0)
				{
					_fairyCameraFollow = false;
				}
				if(!_player.isClimbing && !_tentacleCameraFollow && !_fairyCameraFollow)
				{
					FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
				}
				/*
				if(_tentacleCamera.pathSpeed == 0)
				{
					if(!_player.isClimbing && !_tentacleCameraFollow && !_fairyCameraFollow)
					{
						FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
					}
				}
				if(_fairyCamera.pathSpeed == 0)
				{
					if(!_player.isClimbing && !_fairyCameraFollow)
					{
						FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
					}
				}
				*/
				//petals
				_petals.x = FlxG.camera.scroll.x;
				_petals.y = FlxG.camera.scroll.y;
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
				
				//destroy trap
				if(_trapTimer >= 0.25)
				{
					_trap.alpha -= 0.05;
				}
				if(_trap.alpha <= 0)
				{
					_trap.kill();
					if(_trapNar == 0)
						_trapNar = 1;
				}
				//wisp trigger
				/*
				if(_player.position.x <= 1536 && FlxU.floor(_player.position.y) <= 1120 && FlxU.floor(_player.position.y) > 960)
				{
					FlxG.log("wisp start 1");
					if(_wispCheck == 0)
					{
						var s1:FlxObject = _wispSpawns.members[_wispCheck];
						_wispCheck = 1;
						_wisp.followPath(_wispPath1, 100);
					}
				}
				*/
				//first check
				if(!_hasWisp)
				{
					if(_wisp.path == _wispPath1 && _wisp.pathSpeed == 0)
					{
						FlxG.log("wisp end 1");
						if(_wisp.alpha > 0)
						{
							_wisp.alpha -= 0.05;
						}
						else if(_wisp.alpha <= 0)
						{
							var d1:FlxObject = _wispSpawns.members[_wispCheck];
							_wisp.x = d1.x;
							_wisp.y = d1.y;
							_wisp.alpha = 0;
							_wisp.path = null;
						}
					}
					if(_player.position.x >= 1728 && FlxU.floor(_player.position.y) <= 960 && FlxU.floor(_player.position.y) > 896)
					{
						FlxG.log("wisp start 2");
						if(_wispCheck == 1)
						{
							_wispCheck = 2;
						}
						if(_wisp.alpha <= 1)
						{
							_wisp.alpha += 0.05;
						}
						else if(_wisp.alpha >= 1)
						{
							//stuff
							//giggle?
						}
					}
					if(_player.position.x >= 2080 && FlxU.floor(_player.position.y) <= 896 && FlxU.floor(_player.position.y) > 480)
					{
						FlxG.log("wisp end 2");
						if(_wispCheck == 2)
						{
							if(_wisp.alpha > 0)
							{
								_wisp.alpha -= 0.05;
							}
							else if(_wisp.alpha <= 0)
							{
								var d2:FlxObject = _wispSpawns.members[_wispCheck];
								_wisp.x = d2.x;
								_wisp.y = d2.y;
								_wisp.alpha = 0;
								_wisp.path = null;
							}
						}
						
					}
					if(_player.position.x <= 2112 && _player.position.x > 1728 && FlxU.floor(_player.position.y) <= 480)
					{
						FlxG.log("wisp start 3");
						if(_wispCheck == 2)
						{
							_wispCheck = 3;
						}
						if(_wisp.alpha <= 1)
						{
							_wisp.alpha += 0.05;
						}
						else if(_wisp.alpha >= 1)
						{
							//stuff
							//giggle?
						}
					}
					if(_player.position.x <= 1728 && _player.position.x > 896 && FlxU.floor(_player.position.y) <= 480)
					{
						FlxG.log("wisp end 3");
						if(_wisp.alpha > 0)
						{
							_wisp.alpha -= 0.05;
						}
						else if(_wisp.alpha <= 0)
						{
							var d3:FlxObject = _wispSpawns.members[_wispCheck];
							_wisp.x = d3.x;
							_wisp.y = d3.y;
							_wisp.alpha = 0;
							_wisp.path = null;
						}
					}
					if(_player.position.x <= 896 && FlxU.floor(_player.position.y) <= 576 && FlxU.floor(_player.position.y) > 480)
					{
						FlxG.log("wisp start 4");
						if(_wispCheck == 3)
						{
							_wispCheck = 4;
						}
						if(_wisp.alpha <= 1)
						{
							_wisp.alpha += 0.05;
						}
						if(_wisp.alpha >= 1)
						{
							//stuff
							//giggle?
							if(_wispCheck == 4)
							{
								FlxG.log("why doesnt this fucking work");
								_wispCheck = 5;
								_wisp.followPath(_wispPath2);
							}
						}
						
					}
					//last check
					if(_wisp.path == _wispPath2 && _wisp.pathSpeed == 0)
					{
						FlxG.log("wisp end 4");
						
						if(!_hasWisp)
						{
							_wisp.alpha = 1;
							_wispPickup = true;
						}
						else
						{
							_wisp.alpha = 0;
						}
					}
				}
				
				
				//death
				if(!_player.alive)
				{
					_respawnTimer += FlxG.elapsed;
					FlxG.watch(this, "_respawnTimer", "spawn timer");
					if(_respawnTimer >= 2)
					{
						_respawnTimer = 0;
						_player.position.reset(_player.spawnPoint.x, _player.spawnPoint.y);
						_player.alive = true;
						_player.respawn();
						_tentacleCameraFollow = false;
						_fairyCameraFollow = false;
						FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
					}
				}
				//death
				//tentacle trigger
				//player
				if(_player.position.x >= 2442 && !_tentacleAttack && !_wispTaken)
				{
					_tentacle.play("swipe");
				}
				//critter
				if(_tentacleCritter.exists && _tentacleCritter.x >= 2442 && !_tentacleAttack)
				{
					_tentacle.play("swipe");
				}
				if(_tentacleAttack)
				{
				
					if(_player.position.x >= 2442 && FlxU.floor(_player.position.y) <= 1440 && FlxU.floor(_player.position.y) > 1000)
					{
						if(!_hasWisp)
						{
							_player.position.x = _tentacleDeath.x + _tentacleDeath.width / 2 - _player.position.width / 2;
							_player.position.y = _tentacleDeath.y;
							_player.cutscene = true;
							if(_tentacle.frame == 0)
							{
								_player.kill();
							}
						}
						else 
						{
							//_wisp.active = true;
							_wisp.alpha = 1;
							_wisp.x = _tentacleDeath.x + _tentacleDeath.width / 2 - _wisp.width / 2;
							_wisp.y = _tentacleDeath.y;
							//_player.cutscene = true;
							//_player.position.velocity.x = 0;
							if(_tentacle.frame == 2)
							{
								_player._heldItem.type = ItemType.EMPTY;
								inventory.type = _player._heldItem.type;
								inventory.checkType();
								FlxG.log(inventory.name);
							}
							if(_tentacle.frame == 0)
							{
								_wisp.kill();
								if(!_wisp.exists)
								{
									_tentacleAttack = false;
									_wispTaken = true;
									//_player.cutscene = false;
									if(_fairyEatNar == 0)
										_fairyEatNar = 1;
									
								}
							}
						}
					}
					else if(_tentacleCritter.x >= 2442)
					{
						FlxG.log("Critter death");
						_tentacleCritter.x = _tentacleDeath.x + _tentacleDeath.width / 2 - _tentacleCritter.width / 2;
						_tentacleCritter.y = _tentacleDeath.y;
						_tentacleCritter.active = false;
						if(_tentacle.frame == 0)
						{
							FlxG.log("Further Critter death");
							_tentacleCritter.kill();
							if(!_tentacleCritter.exists)
							{
								_player.cutscene = false;
								_tentacleAttack = false;
								if(_rabbitNar == 0)
									_rabbitNar = 1;
							}
						}
					}
				}
				//tentacle death
				switch(_tentacle.frame)
				{
					case 1:
						_tentacleDeath.x = 2432;
						_tentacleDeath.y = 1312;
						_tentacle.alpha = 1;
						break;
					case 2:
						_tentacleDeath.x = 2442;
						_tentacleDeath.y = 1440;
						_tentacle.alpha = 1;
						break;
					case 3:
						_tentacleDeath.x = 2464;
						_tentacleDeath.y = 1248;
						_tentacle.alpha = 1;
						break;
					case 4:
						_tentacleDeath.x = 2556;
						_tentacleDeath.y = 1296;
						_tentacle.alpha = 1;
						break;
					default:
						_tentacleDeath.x = _tentacle.x;
						_tentacleDeath.y = _tentacle.y;
						_tentacle.alpha = 0;
						break;
				}
				if(_player.position.x >= map.width + 64)
				{
					_player.cutscene = true;
					_player.position.acceleration.x = 0;
					_player.position.velocity.x = 0;
					nextLevel();
				}
			}
			if(_endGame)
			{
				FlxG.switchState(new Level_03State());
			}
			//update after changes
			super.update();
		}
		public function narrator(Object1:FlxObject, Object2:FlxObject):void
		{
			FlxG.watch(this, "_narrateCount", "Narrate Count");
			if(Object2.x == 448)
			{
				if(_dwarfNar == 0)
					_dwarfNar = 1;
			}
			else if(Object2.x == 1568)
			{
				if(_fairyNar == 0)
					_fairyNar = 1;
				_fairyCameraFollow
			}
			else if(Object2.x == 416)
			{
				if(_fairyWinNar == 0)
					_fairyWinNar = 1;
			}
			Object2.kill();
			
		}
		private function item(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object2 as Item;
			if(i.type == ItemType.AXEHEAD)
			{
				if(_headNar == 0)
					_headNar = 1;
			}
			else if(i.type == ItemType.AXEHANDLE)
			{
				if(_handleNar == 0)
					_handleNar = 1;
				_fairyCameraFollow = true;
			}
			if(!i.overlap && i.pickup)
			{
				//dumb trap wierdness
				i.y -= 1;
				//normal behavior
				i.velocity.y = -200;
				i.overlap = true;
				i.pickup = false;
				
				_player.pickupItem(i);
				FlxG.log("Picked up: " + i.name);
				FlxG.log(_player._heldItem.name);
				
				if(inventory.type == ItemType.AXEHEAD)
				{
					if(i.type == ItemType.AXEHANDLE)
					{
						var o:Item = new Item(0,0,ItemType.AXE)
						_player.pickupItem(o);
						FlxG.log("Picked up: " + o.name);
						FlxG.log(_player._heldItem.name);
						if(_axNar == 0)
							_axNar = 1;
					}
				}
				else if(inventory.type == ItemType.AXEHANDLE)
				{
					if(i.type == ItemType.AXEHEAD)
					{
						var o2:Item = new Item(0,0,ItemType.AXE)
						_player.pickupItem(o2);
						FlxG.log("Picked up: " + o2.name);
						FlxG.log(_player._heldItem.name);
						if(_axNar == 0)
							_axNar = 1;
					}
				}
				inventory.type = _player._heldItem.type;
				inventory.checkType();
				FlxG.log(inventory.name);
			}
		}
		private function petal(Object1:FlxObject, Object2:FlxObject):void
		{
			_player.kill();
		}
		private function petalGround(Object1:FlxObject, Object2:FlxObject):void
		{
			Object1.kill();
		}
		private function wispPickup(Object1:FlxObject, Object2:FlxObject):void
		{
			//_wisp.active = false;

			_hasWisp = true;
			_wispPickup = false;
			_wisp.alpha = 0;
			var i:Item = new Item(0,0,ItemType.FAIRY);
			_player.pickupItem(i);
			FlxG.log("Picked up: " + i.name);
			FlxG.log(_player._heldItem.name);
			inventory.type = _player._heldItem.type;
			inventory.checkType();
			FlxG.log(inventory.name);
			if(_fairyGrabNar == 0)
				_fairyGrabNar = 1;
		}
		private function toggleItem(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object1 as Item;
			i.velocity.x = 0;
			i.pickup = true;
		}
		private function tentacle(Object1:FlxObject, Object2:FlxObject):void
		{
			if(!_tentacleAttack)
				_tentacleAttack = true;
			//FlxG.watch(_tentacle, "frame", "tentacle frame");
		}
		public function tentaclePan(Object1:FlxObject, Object2:FlxObject):void
		{			
			if(_tentacleCritter.exists)
			{
				_tentacleCritter.wanderDirBool = true;
				_player.cutscene = true;
				_player.position.velocity.x = 0;
				_player.position.acceleration.x = 0;
			}
			if(!_tentacleCameraFollow)
			{
				//_tentacleCamera.stopFollowingPath(true);
				_tentacleCamera.x = _player.position.x;
				_tentacleCamera.y = _player.position.y;
				_tentacleCameraFollow = true;
				_player.cameraBool = true;
				FlxG.camera.follow(_tentacleCamera, FlxCamera.STYLE_PLATFORMER);
				_tentacleCamera.followPath(_tentacleCameraPath, _player.position.maxVelocity.x * 2, FlxObject.PATH_FORWARD);
			}
		}
		public function tentacleReset(Object1:FlxObject, Object2:FlxObject):void
		{
			if(_tentacleCameraFollow)
			{
				//_tentacleCamera.stopFollowingPath(true);
				
				_player.cameraBool = false;
				_tentacleResetCameraPath = new FlxPath();
				_tentacleResetCameraPath.add(_player.position.x + _player.position.width / 2, _player.position.y + _player.position.height / 2);
				_tentacleCamera.followPath(_tentacleResetCameraPath, 1500, FlxObject.PATH_FORWARD);
			}
		}
		public function critter(Object1:FlxObject, Object2:FlxObject):void
		{
			var c:Critter = Object1 as Critter;
			c.velocity.x = 0;
			if(c != _tentacleCritter)
				c.wanderBool = true;
		}
		public function root(Object1:FlxObject, Object2:FlxObject):void
		{
			if(inventory.type == ItemType.AXE)
			{
				_rootWall.kill();
				fg3.alpha = 0;
			}
		}
		public function dwarf(Object1:FlxObject, Object2:FlxObject):void
		{
			if(!_dwarfDead)
			{
				if(_player.position.velocity.y > 0)
				{
					FlxG.log("lsdkjhfsdl");
					_dwarfDead = true;
					var i:Item = new Item(_dwarf.x, _dwarf.y - 32, ItemType.AXEHANDLE);
					i.velocity.y = -100;
					i.velocity.x = 100;
					i.pickup = false;
					_items.add(i);
					_dwarf.loadGraphic(DataRegistry.dwarfDead, false, false, 118, 78);
					_dwarf.offset.y = 38;
					if(_kickNar == 0)
						_kickNar = 1;
				}
			}
		}
		public function trap(Object1:FlxObject, Object2:FlxObject):void
		{
			_trapTimer += FlxG.elapsed;
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
					map.loadMap(new DataRegistry.level02Hits, DataRegistry.testMapTiles);
					FlxG.log("map loaded!");
					//mg
					mg = new FlxSprite(0, 0);
					mg.loadGraphic(DataRegistry.mg0t, false, false, 3552, 2048);
					FlxG.log("mg loaded!");
					//bg
					bg = new FlxSprite(0, 0);
					bg.loadGraphic(DataRegistry.bg0t, false, false, 3552, 1380);
					bg.scrollFactor.x = 0.5;
					bg.scrollFactor.y = 0.5;	
					//fg1
					fg = new FlxSprite(310,1715);
					fg.loadGraphic(DataRegistry.fg10t, false, false, 950, 302);
					//fg2
					fg2 = new FlxSprite(1543,1723);
					fg2.loadGraphic(DataRegistry.fg20t, false, false, 279, 291);
					//fg3
					fg3 = new FlxSprite(1543,1723);
					fg3.loadGraphic(DataRegistry.fg30t, false, false, 279, 291);
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
					
					_player = new Player(-32, 1440, _playerGibs);
					_player._heldItem = new Item(0,0,0);
					_player.spawnPoint = new FlxPoint(96, 1440);
					_player.setLeftControl("LEFT");
					_player.setRightControl("RIGHT");
					_player.setUpControl("UP");
					_player.setDownControl("DOWN");
					_player.setAction1Control("SPACE");
					_player.setAction2Control("SHIFT");
					_playerHead = new FlxObject(_player.position.x, _player.position.y, 8, 3);
					FlxG.log("_player loaded!");
					_loadStep++;
					break;
				//sensors
				case 2:
					_loadingScreen.loadingPercentage = 40;
					//hang
					addSensors();
					FlxG.log("hang sensors loaded!");
					//narrator
					narratorTriggers = new FlxGroup();
					narratorTriggers.add(new FlxObject(448, 1824, 32, 96));
					narratorTriggers.add(new FlxObject(1568, 1120, 32, 96));
					narratorTriggers.add(new FlxObject(416, 384, 32, 96));
					//load misc crap
					_trap = new FlxSprite(1170, 1536, DataRegistry.trap);
					_trap.immovable = true;
					_trap.offset.y = 14;
					_loadStep++;
					//root
					_rootWall = new FlxObject(1664, 1888, 32, 192);
					_rootWall.immovable = true;
					//petals
					_petals = new FlxEmitter(0, 0);
					_petals.width = 800;
					var particles:int = 200;
					for(var i:int = 0; i < particles; i++)
					{
						var particle:FlxParticle = new FlxParticle();
						particle.loadGraphic(DataRegistry.petalsSheet, true, true, 25, 25);
						particle.addAnimation("drop", [0,1,2,3,4,5,6], 10, true);
						particle.play("drop");
						//particle.scrollFactor.x = particle.scrollFactor.y = 1.2;
						particle.exists = false;
						_petals.add(particle);
					}
					_petals.setYSpeed(5, 25);
					_petals.setXSpeed(-10, 10);
					_petals.setRotation(0, -720);
					_petals.gravity = 25;
					_petals.bounce = 0;
					_petals.start(false, 10, 2);
					//tentacle
					_tentacle = new FlxSprite(2624, 1344);
					_tentacle.loadGraphic(DataRegistry.tentacle, true, true, 350, 352);
					_tentacle.width = 96;
					_tentacle.height = 96;
					_tentacle.offset.x = 220;
					_tentacle.offset.y = 156;
					_tentacle.addAnimation("swipe", [0, 1, 2, 3, 4, 0], 8, false);
					_tentacle.alpha = 0;
					
					_tentacleDeath = new FlxObject(_tentacle.x, _tentacle.y, _tentacle.width, _tentacle.height);
					_tentacleCamera = new FlxObject(0, 0, 32, 96);
					
					_tentacleCameraTriggers = new FlxGroup();
					var trigger1:FlxObject = new FlxObject(2336, 1440, 8, 96);
					_tentacleCameraTriggers.add(trigger1);
					var trigger2:FlxObject = new FlxObject(3008, 1440, 8, 96);
					_tentacleCameraTriggers.add(trigger2);
					
					_tentacleCameraPath = new FlxPath();
					_tentacleCameraPath.add(_tentacle.x + _tentacle.width / 2, _tentacle.y - 64);
					
					_tentacleCameraResets = new FlxGroup();
					var reset1:FlxObject = new FlxObject(trigger1.x - 48, trigger1.y, 8, 96);
					_tentacleCameraResets.add(reset1);
					var reset2:FlxObject = new FlxObject(trigger2.x + 48, trigger2.y, 8, 96);
					_tentacleCameraResets.add(reset2);

					//critters
					//_critters = new FlxGroup();
					//var critter1:Critter = new Critter(192, 1300, CritterType.BUNNY1);
					//_critters.add(critter1);
					_tentacleCritter = new Critter(2368, 1440, CritterType.BUNNY1);
					_tentacleCritter.facing = FlxObject.RIGHT;
					
					
					//items
					_items = new FlxGroup();
					var i1:Item = new Item(1376, 1440, ItemType.AXEHEAD);
					_items.add(i1);
					
					//inventory
					inventory = new Item();
					inventory.type = ItemType.EMPTY;
					inventory.x = FlxG.width - inventory.width * 4;
					inventory.y = inventory.height / 2 + 8;
					inventory.acceleration.y = 0;
					inventory.scrollFactor.x = inventory.scrollFactor.y = 0;
					
					//dwarf
					_dwarf = new FlxSprite(360, 1894);
					_dwarf.loadGraphic(DataRegistry.dwarfAlive, false, false,  118, 78);
					_dwarf.immovable = true;
					_dwarf.width = 32;
					_dwarf.height = 32;
					_dwarf.offset.x = 40;
					_dwarf.offset.y = 40;
					
					
					/* useful
					FlxG.watch(_dwarf, "x", "Dwarf x");
					FlxG.watch(_dwarf, "y", "Dwarf y");
					
					FlxG.watch(_dwarf, "width", "Dwarf width");
					FlxG.watch(_dwarf, "height", "Dwarf height");
					
					FlxG.watch(_dwarf.offset, "x", "Dwarf offx");
					FlxG.watch(_dwarf.offset, "y", "Dwarf offy");
					*/
					//wisp
					_wisp = new FlxSprite(1472, 1120);
					_wisp.loadGraphic(DataRegistry.wisp, true, true, 203, 227);
					_wisp.width = 32;
					_wisp.height = 32;
					_wisp.offset.x = 92;
					_wisp.offset.y = 100;
					
					_wisp.addAnimation("idle", [0,1,2,3,4,5,6,7,8,9,10,
						11,12,13,14,15,16,17,18,19,20,
						21,22,23,24,25,26,27,28,29,30,
						31,32,33,34,35,36,37,38,39,40,
						41,42,43,44,45,46,47,48,49,50,
						51,52,53,54,55,56,57,58,59], 60, true);
					
					_wisp.play("idle");
					
					//set up wisp race spawns
					_wispSpawns = new FlxGroup();
					var s1:FlxObject = new FlxObject(1610, 1075, 32, 32);
					_wispSpawns.add(s1);
					var s2:FlxObject = new FlxObject(2228, 870, 32, 32);
					_wispSpawns.add(s2);
					var s3:FlxObject = new FlxObject(1563, 450, 32, 32);
					_wispSpawns.add(s3);
					var s4:FlxObject = new FlxObject(588, 443, 32, 32);
					_wispSpawns.add(s4);
					
					//paths
					_wispPath1 = new FlxPath();
					_wispPath1.add(s1.x + 16, s1.y + 16);
					_wispPath2 = new FlxPath();
					_wispPath2.add(256 + 16, 384 + 16); 
					
					_fairyCamera = new FlxObject(1536,1120,32, 96);
					_fairyCameraPath = new FlxPath();
					_fairyCameraPath.add(831, 405);
					
					_crystal = new FlxObject(736, 1504, 448, 32);
					_crystal2 = new FlxObject(736, 1456, 320, 80);
					
					_startFloor = new FlxObject(-96, 1536, 192, 32);
					_startFloor.immovable = true;
					
					_endFloor = new FlxObject(map.width - 32, 1536, 192, 32);
					_endFloor.immovable = true;

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
					_narrator = new Narrator(FlxG.camera.scroll.x + 16, FlxG.camera.scroll.y + FlxG.height - 50);
					FlxG.log("_narrator loaded!");
					_loadStep++;
					break;
				case 6:
					_loadingScreen.loadingPercentage = 100;
					FlxG.bgColor = 0xffEEEEEE;
					add(map);
					add(bg);
					add(mg);
					add(_trap);
					add(_dwarf);
					add(_wisp);
					add(_items);
					add(_player);
					add(_playerHead);
					add(_petals);
					add(_playerGibs);
					//add(_critters);
					add(_tentacleCritter);
					add(_tentacle);
					add(_tentacleDeath);
					add(_tentacleCamera);
					add(_tentacleCameraTriggers);
					add(_tentacleCameraResets);
					add(_wispSpawns);
					add(_fairyCamera);
					add(narratorTriggers);
					add(_crystal);
					add(_crystal2);
					add(_startFloor);
					add(_endFloor);
					add(fg);
					add(fg2);
					add(fg3);
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
					FlxG.log("slkdjfhdk");
					//_narrator.narrate("The wolf was sleeping.  That's all.");
					_endGame = true;
				}
			}
		}
		private function mapDeath(Object1:FlxObject, Object2:FlxObject):void
		{
			_player.kill();
		}
		private function addSensors():void
		{
			_hangSensors = new FlxGroup();
			var sensorsMapL:FlxTilemapExt = new FlxTilemapExt;
			var sensorsMapR:FlxTilemapExt = new FlxTilemapExt;
			sensorsMapL.loadMap(new DataRegistry.level02SensorsL, DataRegistry.testMapTiles, 32, 32);
			sensorsMapR.loadMap(new DataRegistry.level02SensorsR, DataRegistry.testMapTiles, 32, 32);
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