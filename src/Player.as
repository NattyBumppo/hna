package
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxGroup
	{
		//generic properties
		public var spawnPoint:FlxPoint;
		public var facing:uint;
		public var cutscene:Boolean = false;
		public var isJumping:Boolean;
		public var isHanging:Boolean;
		public var isClimbing:Boolean;
		public var isSlowFalling:Boolean;
		public var isSitting:Boolean = false;
		//camera bugfix
		public var cameraBool:Boolean;
		//modifications to _position affect entire group
		public var position:FlxObject;
		//key controls
		protected var _left:String;
		protected var _right:String;
		protected var _up:String;
		protected var _down:String;
		protected var _action1:String;
		protected var _action2:String;
		//all individual animations
		private var _idleSprite:FlxSprite;
		private var _runningSprite:FlxSprite;
		private var _jumpSprite:FlxSprite;
		private var _fallSprite:FlxSprite;
		private var _slowIdleSprite:FlxSprite;
		private var _slowSprite:FlxSprite;
		private var _hangSprite:FlxSprite;
		private var _climbSprite:FlxSprite;
		private var _sitSprite:FlxSprite;
		//physics properties
		private var _gravity:Number;
		private var _jump:Number;
		private var _slow:Number;
		//camera scroll fix when climbing
		private var _cameraFix:Boolean;
		private var _cameraObject:FlxObject;
		private var _cameraPath:FlxPath;
		//misc properties
		private var _gibs:FlxEmitter;
		public var _heldItem:Item;
		//debug
		private var _freeMove:Boolean;
		private var _freeSquare:FlxSprite;
		
		
		public function Player(X:Number, Y:Number, Gibs:FlxEmitter = null)
		{
			super();
			//position
			facing = FlxObject.RIGHT;
			position = new FlxObject(X, Y, 32, 96);
			//load graphics
			loadGraphics(X, Y);
			spawnPoint = new FlxPoint(X, Y);
			//camera fix when climbing
			_cameraFix = false;
			cameraBool = false;
			//basic player physics
			_gravity = 800;
			_jump = 333;
			_slow = 0;
			position.acceleration.y = _gravity;
			position.drag.x = 750;
			position.drag.y = 1200;
			position.maxVelocity.x = 200;
			position.maxVelocity.y = _gravity;
			//add up all the group pieces
			add(position);
			_gibs = Gibs;
			//debug
			FlxG.watch(position, "x", "X Position:");
			FlxG.watch(position, "y", "Y Position:");
			_freeSquare = new FlxSprite(X, Y);
			_freeSquare.makeGraphic(32, 96, 0xffFFFFFF);
		}
		override public function update():void
		{
			if(!cutscene)
			{
				//MOVEMENT
				//left and right
				position.acceleration.x = 0;
				//if(FlxG.keys.justPressed("D"))
					//_freeMove = !_freeMove;
				if(!_freeMove)
				{
					remove(_freeSquare);
					position.acceleration.y = _gravity;
					if(FlxG.keys.pressed(_left) && !isHanging && !isClimbing)
					{
						facing = FlxObject.LEFT;
						position.acceleration.x -= position.drag.x;
					}
					else if(FlxG.keys.pressed(_right) && !isHanging && !isClimbing)
					{
						facing = FlxObject.RIGHT;
						position.acceleration.x += position.drag.x;
					}
					//jumping
					if(FlxG.keys.justPressed(_action1))
					{
						if(position.isTouching(FlxObject.FLOOR))
						{
							isJumping = true;
							position.velocity.y = -_jump;
						}
						//if player jumps from hanging
						if(isHanging && !isClimbing)
						{
							isHanging = false;
							isJumping = true;
							position.acceleration.y = _gravity;
							position.velocity.y = -_jump;
						}
					}
					if(FlxG.keys.justReleased(_action1) && position.velocity.y < 0)
					{
						if(isJumping)
						{
							isJumping = false;
							position.velocity.y = position.velocity.y / 2;
						}
					}
					if(position.velocity.y > 0 && !isHanging && !isClimbing)
					{
						if(FlxG.keys.pressed(_action1))
						{
							_slow += FlxG.elapsed;
							if(_slow >= 0.5)
							{
								isSlowFalling = true;
								position.velocity.y = 50 * _slow;
							}
						}
						else if(FlxG.keys.justReleased(_action1))
						{
							_slow = 0;
							position.acceleration.y = _gravity;
							isSlowFalling = false;
						}
					}
					if(isHanging)
					{
						position.velocity.y = 0;
						position.acceleration.y = 0;
						if(FlxG.keys.justPressed(_up))
						{
							//isHanging = false;
							isClimbing = true;
						}
						if(FlxG.keys.pressed(_down))
						{
							isHanging = false;
							position.acceleration.y = _gravity;
							position.y += 2;
						}
					}
					if(position.isTouching(FlxObject.FLOOR))
					{
						_slow = 0;
						isSlowFalling = false;
					}
				}
				else
				{
					add(_freeSquare);
					position.acceleration.y = 0;
					if(FlxG.keys.pressed(_left))
					{
						facing = FlxObject.LEFT;
						position.x -= 15;
					}
					if(FlxG.keys.pressed(_right))
					{
						facing = FlxObject.RIGHT;
						position.x += 15;
					}
					if(FlxG.keys.pressed(_up))
						position.y -= 15;
					if(FlxG.keys.pressed(_down))
						position.y += 15;
				}
			}
			_freeSquare.x = position.x;
			_freeSquare.y = position.y;
			if(alive)
			{
				updateAnimations();
			}
			
			//path bullshit
			if(_cameraFix && _cameraObject.pathSpeed == 0)
			{
				_cameraObject.velocity = new FlxPoint(0,0);
				_cameraObject.stopFollowingPath(true);
				_cameraObject.kill();
				_cameraFix = false;
			}
			else if(_cameraFix && _cameraObject.pathSpeed != 0)
			{
				FlxG.camera.follow(_cameraObject, FlxCamera.STYLE_PLATFORMER);
			}
			
			if(position.isTouching(FlxObject.FLOOR))
			{
				isHanging = false;
				isClimbing = false;
				isSlowFalling = false
			}
			//update after changes
			super.update();
		}
		public function respawn():void
		{
			_idleSprite.reset(spawnPoint.x, spawnPoint.y);
			_runningSprite.reset(spawnPoint.x, spawnPoint.y);
			_jumpSprite.reset(spawnPoint.x, spawnPoint.y);
			_fallSprite.reset(spawnPoint.x, spawnPoint.y);
			_slowIdleSprite.reset(spawnPoint.x, spawnPoint.y);
			_slowSprite.reset(spawnPoint.x, spawnPoint.y);
			_hangSprite.reset(spawnPoint.x, spawnPoint.y);
			_climbSprite.reset(spawnPoint.x, spawnPoint.y);
		}
		override public function kill():void
		{
			if(!alive)
				return;
			//position.solid = false;
			super.kill();
			exists = true;
			//visible = false;
			position.velocity.make();
			position.acceleration.make();
			FlxG.camera.shake(0.005, 0.35);
			FlxG.camera.flash(0xCC0000, 0.35);
			if(_gibs != null)
			{
				_gibs.at(position);
				_gibs.start(true, 5, 0, 50);
			}
		}
		public function pickupItem(I:Item):void
		{
			_heldItem = I;
		}
		public function setLeftControl(Key:String):void
		{
			_left = Key;
		}
		public function setRightControl(Key:String):void
		{
			_right = Key;
		}
		public function setUpControl(Key:String):void
		{
			_up = Key;
		}
		public function setDownControl(Key:String):void
		{
			_down = Key;
		}
		public function setAction1Control(Key:String):void
		{
			_action1 = Key;
		}
		public function setAction2Control(Key:String):void
		{
			_action2 = Key;
		}
		
		
		
		///////////////////////
		//////Stupid Shit//////
		///////////////////////
		private function loadGraphics(X:Number, Y:Number):void
		{
			//idle
			_idleSprite = new FlxSprite(X, Y);
			_idleSprite.offset.x = 63;
			_idleSprite.offset.y = 72;
			_idleSprite.scale.x = 0.5;
			_idleSprite.scale.y = 0.5;
			_idleSprite.solid = false;
			_idleSprite.loadGraphic(DataRegistry.playerIdle, true, true, 126, 226);
			_idleSprite.addAnimation("idle", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24], 
				25, true);
			//running
			_runningSprite = new FlxSprite(X, Y);
			_runningSprite.offset.x = 88;
			_runningSprite.offset.y = 80;
			_runningSprite.scale.x = 0.5;
			_runningSprite.scale.y = 0.5;
			_runningSprite.loadGraphic(DataRegistry.playerRunning, true, true, 221, 236);
			_runningSprite.addAnimation("running", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31], 
				60, true);
			//jump
			_jumpSprite = new FlxSprite(X, Y);
			_jumpSprite.offset.x = 128;
			_jumpSprite.offset.y = 80;
			_jumpSprite.scale.x = 0.5;
			_jumpSprite.scale.y = 0.5;
			_jumpSprite.loadGraphic(DataRegistry.playerJump, true, true, 251, 241);
			_jumpSprite.addAnimation("jump", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18], 
				60, false);
			_jumpSprite.addAnimation("fall", 
				[19,20,
				21,22,23,24,25,26,27,28,
				29,30,31,32,33,34,35,36,37,38,39], 
				60, false);
			//fall
			_fallSprite = new FlxSprite(X, Y);
			_fallSprite.offset.x = 108;
			_fallSprite.offset.y = 72;
			_fallSprite.scale.x = 0.5;
			_fallSprite.scale.y = 0.5;
			_fallSprite.loadGraphic(DataRegistry.playerFall, true, true, 200, 233);
			_fallSprite.addAnimation("fall", 
				[0,1,2,3,4,5,6,7,8,9,
				10,11,12,13,14,15,16,17,18,19,
				20,21,22,23,24], 
				60, true);
			//slow fall
			_slowSprite = new FlxSprite(X, Y);
			_slowSprite.scale.x = 0.5;
			_slowSprite.scale.y = 0.5;
			_slowSprite.loadGraphic(DataRegistry.playerSlow, true, true, 275, 345);
			_slowSprite.addAnimation("slow", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31,32,33,34,35,36,37,38,39,40], 
				60, false);
			//slow fall idle
			_slowIdleSprite = new FlxSprite(X, Y);
			_slowIdleSprite.scale.x = 0.5;
			_slowIdleSprite.scale.y = 0.5;
			_slowIdleSprite.loadGraphic(DataRegistry.playerSlowIdle, true, true, 189, 346);
			_slowIdleSprite.addAnimation("idle", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31,32,33,34,35,36,37,38,39,40,
				41,42,43,44,45,46,47,48,49], 
				60, true);
			//hang
			_hangSprite = new FlxSprite(X, Y);
			_hangSprite.offset.x = 60;
			_hangSprite.offset.y = 74;
			_hangSprite.scale.x = 0.5;
			_hangSprite.scale.y = 0.5;
			_hangSprite.loadGraphic(DataRegistry.playerClimbIdle, true, true, 134, 286);
			_hangSprite.addAnimation("hang", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31,32,33,34], 
				60, true);
			//climb
			_climbSprite = new FlxSprite(X, Y);
			_climbSprite.offset.x = 106;
			_climbSprite.offset.y = 236;
			_climbSprite.scale.x = 0.5;
			_climbSprite.scale.y = 0.5;
			_climbSprite.loadGraphic(DataRegistry.playerClimb, true, true, 228, 503);
			_climbSprite.addAnimation("climb", 
				[0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31,32,33,34,35,36,37,38,39,40,
				41,42,43,44,45,46,47,48,49,50,
				51,52,53,54,55,56,57,58,59,60,
				61,62,63,64,65,66,67,68,69,70,
				71,72,73,74,75,76,77,78,79,80,
				81,82,83,84,85,86,87,88,89,90,
				91,92,93,94,95,96,97,98,99], 
				60, false);
			//sitting
			_sitSprite = new FlxSprite(X, Y);
			_sitSprite.offset.x = 12;
			_sitSprite.offset.y = 56;
			_sitSprite.scale.x = 0.5;
			_sitSprite.scale.y = 0.5;
			_sitSprite.loadGraphic(DataRegistry.playerSitting, false, true, 86, 186);
			FlxG.watch(_sitSprite.offset, "x", "Sitt GFX offX");
			FlxG.watch(_sitSprite.offset, "y", "Sitt GFX offY");
		}
		private function updateAnimations():void
		{
			//animations
			//idle
			if(position.velocity.x == 0 && position.isTouching(FlxObject.FLOOR))
			{
				add(_idleSprite);
				remove(_runningSprite);
				remove(_jumpSprite);
				remove(_fallSprite);
				remove(_slowSprite);
				remove(_slowIdleSprite);
				remove(_hangSprite);
				remove(_climbSprite);
				remove(_sitSprite);
				_runningSprite.frame = 1;
				_jumpSprite.frame = 1;
				_slowSprite.frame = 1;
				_slowIdleSprite.frame = 1;
				_fallSprite.frame = 1;
				_hangSprite.frame = 1;
				_climbSprite.frame = 1;
				_idleSprite.play("idle");
				_idleSprite.facing = facing;
				if(facing == FlxObject.LEFT)
				{
					//adjust image offsets
					_idleSprite.offset.x = 30;
					_idleSprite.offset.y = 72;
					//position image
					_idleSprite.x = position.x;
					_idleSprite.y = position.y;	
				}
				else if(facing == FlxObject.RIGHT)
				{
					//adjust image offsets
					_idleSprite.offset.x = 64;
					_idleSprite.offset.y = 72;
					//position image
					_idleSprite.x = position.x;
					_idleSprite.y = position.y;	
				}	
			}
				//running
			else if(position.velocity.x != 0 && position.isTouching(FlxObject.FLOOR))
			{
				add(_runningSprite);
				remove(_idleSprite);
				remove(_jumpSprite);
				remove(_fallSprite);
				remove(_slowSprite);
				remove(_slowIdleSprite);
				remove(_hangSprite);
				remove(_climbSprite);
				remove(_sitSprite);
				_idleSprite.frame = 1;
				_jumpSprite.frame = 1;
				_fallSprite.frame = 1;
				_slowSprite.frame = 1;
				_slowIdleSprite.frame = 1;
				_hangSprite.frame = 1;
				_climbSprite.frame = 1;
				_runningSprite.play("running");
				_runningSprite.facing = facing;
				if(facing == FlxObject.LEFT)
				{
					//adjust image offsets
					_runningSprite.offset.x = 88;
					_runningSprite.offset.y = 80;
					//position image
					_runningSprite.x = position.x;
					_runningSprite.y = position.y;	
				}
				else if(facing == FlxObject.RIGHT)
				{
					//adjust image offsets
					_runningSprite.offset.x = 104;
					_runningSprite.offset.y = 80;
					//position image
					_runningSprite.x = position.x;
					_runningSprite.y = position.y;	
				}
			}
				//jump
			else if(position.velocity.y != 0 && !isSlowFalling)
			{
				add(_jumpSprite);
				remove(_fallSprite);
				remove(_idleSprite);
				remove(_runningSprite);
				remove(_slowSprite);
				remove(_slowIdleSprite);
				remove(_hangSprite);
				remove(_climbSprite);
				remove(_sitSprite);
				_idleSprite.frame = 1;
				_runningSprite.frame = 1;
				_slowSprite.frame = 1;
				_slowIdleSprite.frame = 1;
				_hangSprite.frame = 1;
				_climbSprite.frame = 1;
				_jumpSprite.facing = facing;
				if(position.velocity.y < 0)
				{
					if(_jumpSprite.frame != 18)
						_jumpSprite.play("jump");
				}
				else if(position.velocity.y > 0)
				{
					if(_jumpSprite.frame != 39)
						_jumpSprite.play("fall");
					else if(_jumpSprite.frame == 39)
					{
						//FlxG.log("ldslkjf");
						add(_fallSprite);
						_fallSprite.play("fall");
						_fallSprite.facing = facing;
						remove(_jumpSprite);
					}
				}
				if(facing == FlxObject.LEFT)
				{
					//adjust image offsets
					_fallSprite.offset.x = 62;
					_fallSprite.offset.y = 72;
					_jumpSprite.offset.x = 92;
					_jumpSprite.offset.y = 80;
					//position image
					_fallSprite.x = position.x;
					_fallSprite.y = position.y;
					_jumpSprite.x = position.x;
					_jumpSprite.y = position.y;	
				}
				else if(facing == FlxObject.RIGHT)
				{
					//adjust image offsets
					_fallSprite.offset.x = 108;
					_fallSprite.offset.y = 72;
					_jumpSprite.offset.x = 128;
					_jumpSprite.offset.y = 80;
					//position image
					_fallSprite.x = position.x;
					_fallSprite.y = position.y;
					_jumpSprite.x = position.x;
					_jumpSprite.y = position.y;	
				}
			}
				//hanging
			else if(isHanging && !isClimbing)
			{
				add(_hangSprite);
				_hangSprite.play("hang");
				_hangSprite.facing = facing;
				remove(_idleSprite);
				remove(_runningSprite);
				remove(_fallSprite);
				remove(_slowSprite);
				remove(_slowIdleSprite);
				remove(_jumpSprite);
				remove(_climbSprite);
				remove(_sitSprite);
				_idleSprite.frame = 1;
				_runningSprite.frame = 1;
				_jumpSprite.frame = 1;
				_fallSprite.frame = 1;
				_slowSprite.frame = 1;
				_slowIdleSprite.frame = 1;
				_climbSprite.frame = 1;
				if(facing == FlxObject.LEFT)
				{
					//adjust image offsets
					_hangSprite.offset.x = 42;
					_hangSprite.offset.y = 74;
					//position image
					_hangSprite.x = position.x;
					_hangSprite.y = position.y;	
				}
				else if(facing == FlxObject.RIGHT)
				{
					//adjust image offsets
					_hangSprite.offset.x = 60;
					_hangSprite.offset.y = 74;
					//position image
					_hangSprite.x = position.x;
					_hangSprite.y = position.y;	
				}
			}
				//climbing
			else if(isClimbing)
			{
				//camera shit
				//
				if(!_cameraFix && !cameraBool)
				{
					_cameraFix = true;
					_cameraObject = new FlxObject(position.x, position.y, 32, 96);
					add(_cameraObject);
					_cameraPath = new FlxPath();
					_cameraPath.add(position.x + position.width / 2, position.y + position.height / 2);
					_cameraPath.add(position.x + position.width / 2, position.y + position.height / 2 - 96);
					if(facing == FlxObject.RIGHT)
						_cameraPath.add(position.x + position.width / 2 + 16, position.y + position.height / 2 - 96);
					else
						_cameraPath.add(position.x + position.width / 2 - 16, position.y + position.height / 2 - 96);
					_cameraObject.followPath(_cameraPath, 67, FlxObject.PATH_FORWARD);
					
				}
				//
				add(_climbSprite);
				remove(_idleSprite);
				remove(_runningSprite);
				remove(_jumpSprite);
				remove(_fallSprite);
				remove(_slowSprite);
				remove(_slowIdleSprite);
				remove(_hangSprite);
				remove(_sitSprite);
				_idleSprite.frame = 1;
				_runningSprite.frame = 1;
				_jumpSprite.frame = 1;
				_fallSprite.frame = 1;
				_slowSprite.frame = 1;
				_slowIdleSprite.frame = 1;
				_hangSprite.frame = 1;
				_climbSprite.play("climb");
				_climbSprite.facing = facing;
				if(facing == FlxObject.LEFT)
				{
					//adjust image offsets
					_climbSprite.offset.x = 90;
					_climbSprite.offset.y = 236;
					//position image
					_climbSprite.x = position.x;
					_climbSprite.y = position.y;	
				}
				else if(facing == FlxObject.RIGHT)
				{
					//adjust image offsets
					_climbSprite.offset.x = 106;
					_climbSprite.offset.y = 236;
					//position image
					_climbSprite.x = position.x;
					_climbSprite.y = position.y;
				}
				if(_climbSprite.frame == 99)
				{
					//climb code
					//do this after animations
					position.y -= 96;
					if(facing == FlxObject.LEFT)
						position.x -= 16;
					else if(facing == FlxObject.RIGHT)
						position.x += 16;
					position.acceleration.y = _gravity;
					isClimbing = false;
					isHanging = false;
				}
			}
			//slow-falling
			else if(isSlowFalling)
			{
				add(_slowSprite);
				remove(_idleSprite);
				remove(_runningSprite);
				remove(_jumpSprite);
				remove(_fallSprite);
				remove(_slowIdleSprite);
				remove(_hangSprite);
				remove(_climbSprite);
				remove(_sitSprite);
				_idleSprite.frame = 1;
				_runningSprite.frame = 1;
				_jumpSprite.frame = 1;
				_fallSprite.frame = 1;
				_hangSprite.frame = 1;
				_climbSprite.frame = 1;
				_slowSprite.facing = facing;
				if(_slowSprite.frame != 40)
					_slowSprite.play("slow");
				else if(_slowSprite.frame == 40)
				{
					add(_slowIdleSprite);
					_slowIdleSprite.play("idle");
					_slowIdleSprite.facing = facing;
					remove(_slowSprite);
				}
				if(facing == FlxObject.LEFT)
				{
					//adjust image offsets
					_slowIdleSprite.offset.x = 64;
					_slowIdleSprite.offset.y = 144;
					_slowSprite.offset.x = 116;
					_slowSprite.offset.y = 144;
					//position image
					_slowIdleSprite.x = position.x;
					_slowIdleSprite.y = position.y;
					_slowSprite.x = position.x;
					_slowSprite.y = position.y;	
				}
				else if(facing == FlxObject.RIGHT)
				{
					//adjust image offsets
					_slowIdleSprite.offset.x = 88;
					_slowIdleSprite.offset.y = 144;
					_slowSprite.offset.x = 116;
					_slowSprite.offset.y = 144;
					//position image
					_slowIdleSprite.x = position.x;
					_slowIdleSprite.y = position.y;
					_slowSprite.x = position.x;
					_slowSprite.y = position.y;	
				}
			}
			else if(isSitting)
			{
				add(_sitSprite);
				remove(_idleSprite);
				remove(_runningSprite);
				remove(_jumpSprite);
				remove(_fallSprite);
				remove(_slowSprite);
				remove(_slowIdleSprite);
				remove(_hangSprite);
				remove(_climbSprite);
				_idleSprite.frame = 1;
				_runningSprite.frame = 1;
				_jumpSprite.frame = 1;
				_slowSprite.frame = 1;
				_slowIdleSprite.frame = 1;
				_fallSprite.frame = 1;
				_hangSprite.frame = 1;
				_climbSprite.frame = 1;
				_sitSprite.facing = facing;
				if(facing == FlxObject.RIGHT)
				{
					_sitSprite.offset.x = 20;
					_sitSprite.offset.y = 56;
					_sitSprite.x = position.x;
					_sitSprite.y = position.y;
				}
				else if(facing == FlxObject.LEFT)
				{
					_sitSprite.offset.x = 40;
					_sitSprite.offset.y = 56;
					_sitSprite.x = position.x;
					_sitSprite.y = position.y;
				}
			}
		}
	}
}