package
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class Unicorn extends FlxGroup
	{
		public var facing:uint;
		public var main:FlxSprite;
		public var graze:FlxSprite;
		public var run:FlxSprite;
		public var shot:FlxSprite;
		public var gold:FlxSprite;
		public var lasers:FlxGroup;
		
		public var laserShock:FlxGroup;
		public var emitter:FlxEmitter;
		public var win:FlxObject;
		public var fight:Boolean = false;
		
		public var isIdle:Boolean = true;
		public var isWandering:Boolean = false;
		public var isGrazing:Boolean = false;
		public var isShooting:Boolean = false;
		public var isChasing:Boolean = false;
		public var isRodeo:Boolean = false;
		public var isLaser:Boolean = false;
		public var isGold:Boolean = false;
		public var _lTimer:Number = 0;
		private var _wTimer:Number = 0;
		private var _wDir:Number = 0;
		public var _windup:Number = 4;
		public var _wait:Number = 0;
		private var _canAttack:Boolean = false;
		private var _attackTimer:Number = 0;
		private var _player:Player;
		
		private var _burst:FlxSprite;
		
		public function Unicorn(X:Number, Y:Number, Player:Player)
		{
			facing = FlxObject.RIGHT;
			main = new FlxSprite(X, Y);
			main.loadGraphic(DataRegistry.unicornIdle, true, true, 356, 325);
			main.scale = new FlxPoint(0.5, 0.5);
			main.width = 96;
			main.height = 96;
			main.offset.x = 134;
			main.offset.y = 130;
			main.facing = facing;
			win = new FlxObject(X, Y, main.width, 8);
			graze = new FlxSprite(X, Y);
			graze.loadGraphic(DataRegistry.unicornGraze, true, true, 372, 194);
			graze.scale = new FlxPoint(0.6, 0.6);
			graze.width = 96;
			graze.height = 96;
			graze.offset.x = 120;
			graze.offset.y = 40;
			graze.facing = facing;
			run = new FlxSprite(X, Y);
			run.loadGraphic(DataRegistry.unicornRun, true, true, 384, 268);
			run.scale = new FlxPoint(0.6, 0.6);
			run.width = 96;
			run.height = 96;
			run.offset.x = 148;
			run.offset.y = 106;
			run.drag.x = 750;
			run.maxVelocity.x = 600;
			run.facing = facing;
			shot = new FlxSprite(X, Y);
			shot.loadGraphic(DataRegistry.unicornShoot, true, true, 501, 307);
			shot.scale = new FlxPoint(0.5, 0.5);
			shot.width = 96;
			shot.height = 96;
			//shot.offset.x = 204;
			//shot.offset.y = 114;
			shot.offset.x = 148;
			shot.offset.y = 106;
			shot.facing = facing;
			gold = new FlxSprite(X, Y);
			gold.loadGraphic(DataRegistry.unicornGold, true, true, 356, 325);
			gold.scale = new FlxPoint(0.5, 0.5);
			gold.width = 96;
			gold.height = 96;
			gold.offset.x = 134;
			gold.offset.y = 130;
			gold.facing = facing;
			_player = Player;
			lasers = new FlxGroup(3);
			lasers.add(new Beam(0,0));
			lasers.add(new Beam(0,0));
			lasers.add(new Beam(0,0));
			laserShock = new FlxGroup(3);
			laserShock.add(new FlxObject());
			
			emitter = new FlxEmitter();
			var particles:int = 100;
			for(var n:int = 0; n < particles; n++)
			{
				var particle:FlxParticle = new FlxParticle();
				var graphic:int = (Math.floor(Math.random() * (6 - 1 + 1)) + 1);
				switch(graphic)
				{
					case 1:
						particle.loadGraphic(DataRegistry.catte, false, true, 69, 43);
						particle.exists = false;
						emitter.add(particle);
						break;
					case 2:
						particle.loadGraphic(DataRegistry.cupcake, false, true, 41, 49);
						particle.exists = false;
						emitter.add(particle);
						break;
					case 3:
						particle.loadGraphic(DataRegistry.heart, false, true, 44, 47);
						particle.exists = false;
						emitter.add(particle);
						break;
					case 4:
						particle.loadGraphic(DataRegistry.horseshoe, false, true, 31, 35);
						particle.exists = false;
						emitter.add(particle);
						break;
					case 5:
						particle.loadGraphic(DataRegistry.ribbon, false, true, 61, 67);
						particle.exists = false;
						emitter.add(particle);
						break;
					case 6:
						particle.loadGraphic(DataRegistry.rose, false, true, 36, 39);
						particle.exists = false;
						emitter.add(particle);
						break;
				}
			}
			emitter.setYSpeed(50, 200);
			emitter.setRotation(-720, -720);
			emitter.gravity = 420;
			emitter.bounce = 0;
			emitter.start(false, 3, 0.05);
			add(emitter);
			add(main);
			add(lasers);
			add(win);
			
			main.addAnimation("idle", [0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31,32,33,34,35,36,37,38,39,40,
				41,42,43,44,45,46,47,48,49,50,
				51,52,53,54,55,56,57,58,59,60,
				61,62,63,64,65,66,67,68,69,70,
				71,72,73,74,75,76,77,78,79,80,
				81,82,83,84,85,86,87,88,89,90,
				91,92,93,94,95,96,97,98,99], 
				60, true);
			main.play("idle");
			graze.addAnimation("graze", [0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31,32,33,34,35,36,37,38,39,40,
				41,42,43,44,45,46,47,48,49,50,
				51,52,53,54,55,56,57,58,59,60,
				61,62,63,64,65,66,67,68,69,70,
				71,72,73,74,75,76,77,78,79,80,
				81,82,83,84,85,86,87,88,89,90,
				91,92,93,94,95], 60, true);
			graze.play("graze");
			run.addAnimation("run", [0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24], 60, true);
			run.play("run");
			shot.addAnimation("shoot", [0,1,2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,
				21,22,23,24,25,26,27,28,29,30,
				31], 30, true);
			shot.play("shoot");
		}
		override public function update():void
		{
			if(fight)
			{
				//player check
				if(FlxU.floor(_player.position.y) <= 672 && FlxU.floor(_player.position.y) > 542
					&& FlxU.floor(_player.position.x) < 896 && FlxU.floor(_player.position.x) > 352)
				{
					chase();
				}
				else if(FlxU.floor(_player.position.y) > 704)
				{
					//_windup = 0;
					if(_windup >= 0 && _windup < 6)
					{
						_windup += FlxG.elapsed;
						wander();
						FlxG.watch(this, "_windup", "Windup");
					}
					if(_windup >= 6)
					{
						_windup = 6;
						_canAttack = true;
						rodeo();
					}
					//rodeo();
				}
				else if(FlxU.floor(_player.position.y) < 542)
				{
					if(_windup >= 0 && _windup < 1)
					{
						_windup += FlxG.elapsed;
						wander();
						FlxG.watch(this, "_windup", "Windup");
					}
					if(_windup >= 1)
					{
						_windup = 1;
						_canAttack = true;
						zap();
					}
				}
				else
				{
					_windup = 0;
					_lTimer = 0;
					wander();
				}
			}
			
			main.x = run.x;
			main.y = run.y;
			shot.x = run.x;
			shot.y = run.y;
			win.x = run.x;
			win.y = run.y;
			
			if(isRodeo || isWandering || isChasing)
			{
				if(!isRodeo)
				{
					emitter.on = false;
				}
				else
				{
					emitter.on = true;
				}
				remove(main);
				remove(graze);
				remove(shot);
				remove(gold);
				add(run);
				isIdle = false;
				isGold = false;
			}
			else if(isShooting || isLaser)
			{
				emitter.on = false;
				remove(main);
				remove(graze);
				remove(run);
				remove(gold);
				add(shot);
				isIdle = false;
				isGold = false;
			}
			else if(isGrazing)
			{
				emitter.on = false;
				remove(main);
				remove(run);
				remove(shot);
				remove(gold);
				add(graze);
				eat();
				isIdle = false;
				isGold = false;
			}
			else if (isIdle)
			{
				emitter.on = false;
				remove(run);
				remove(graze);
				remove(shot);
				remove(gold);
				add(main);
				main.facing = facing;
				isGold = false;
			}
			else if (isGold)
			{
				emitter.on = false;
				remove(run);
				remove(graze);
				remove(shot);
				remove(main);
				add(gold);
				gold.facing = facing;
				isIdle = false;
			}
			
		super.update();
		}
		//behavior
		public function wander():void
		{
			run.acceleration.x = 0;
			isWandering = true;
			isGrazing = false;
			isChasing = false
			isRodeo = false;
			isShooting = false;
			isLaser = false;
			
			_wTimer += FlxG.elapsed;
			if (_wTimer >= 2.5)
			{
				_wTimer = 0;
				_wDir = Math.random() * 10;
				if(_wDir >= 0.5)
				{
					_wDir = 1;
				}
				else if(_wDir < 0.5)
				{
					_wDir = 0;
				}
			}
			switch(_wDir)
			{
				case 0:
					if(run.x < 896 - run.width)
					{
						run.facing = FlxObject.RIGHT;
						facing = FlxObject.RIGHT;
						if(run.velocity.x < 100)
						{
							run.acceleration.x += run.drag.x;
						}
						else
						{
							run.velocity.x = 100;
						}
					}
					else
					{
						_wDir = 1;
						break;
					}
					break;
				case 1:
					if(run.x > 352)
					{
						run.facing = FlxObject.LEFT;
						facing = FlxObject.LEFT;
						if(run.velocity.x > -100)
						{
							run.acceleration.x -= run.drag.x;
						}
						else
						{
							run.velocity.x = -100;
						}
					}
					else
					{
						_wDir = 0;
						break;
					}
					break;
			}
		}
		public function eat():void
		{
			if(!isGrazing)
			{
				isWandering = false;
				isGrazing = true;
				isChasing = false
				isRodeo = false;
				isShooting = false;
				isLaser = false;
				graze.velocity.x = 0;
				graze.facing = facing;
			}
		}
		public function prepare():void
		{
			isWandering = false;
			isGrazing = false;
			isChasing = false
			isRodeo = false;
			isLaser = false;
			FlxG.watch(this, "_wait", "Wait time");
			//play neigh sound
			if(_wait >= 0 && _wait < 1.5)
			{
				_wait += FlxG.elapsed;
				isShooting = true;
				shot.facing = facing;
			}
			else if (_wait >= 1.5)
			{
				_wait = 1.5;
				return;
			}
		}
		public function zap():void
		{
			if(_canAttack)
			{
				isWandering = false;
				isGrazing = false;
				isChasing = false
				isRodeo = false;
				isShooting = false;
				isLaser = true;
				shot.acceleration.x = 0;
				shot.velocity.x = 0;
				shot.frame = 1;
				_lTimer += FlxG.elapsed;
				FlxG.watch(this, "_lTimer", "Laser Timer");
				if ((_lTimer >= 2))
				{
					//_lTimer = 0;
					lasers.members[0].active = true;
					lasers.members[0].solid = true;
					lasers.members[0].alpha = 1;
					lasers.members[0].x = 400;
					lasers.members[0].y = 448;
					lasers.members[1].active = true;
					lasers.members[1].solid = true;
					lasers.members[1].alpha = 1;
					lasers.members[1].x = 624;
					lasers.members[1].y = 352;
					lasers.members[2].active = true;
					lasers.members[2].solid = true;
					lasers.members[2].alpha = 1;
					lasers.members[2].x = 848;
					lasers.members[2].y = 448;
					FlxG.camera.flash(0xffFFFFFF, 0.5);
				}
				_attackTimer += FlxG.elapsed;
				if(_attackTimer >= 2)
				{
					_wait = 0;
					_windup = 0;
					_canAttack = false;
					_attackTimer = 0;
					_lTimer = 0;
					lasers.members[0].solid = false;
					lasers.members[1].solid = false;
					lasers.members[2].solid = false;
				}
			}
			
		}
		public function chase():void
		{
			run.acceleration.x = 0;
			isWandering = false;
			isGrazing = false;
			isChasing = true
			isRodeo = false;
			isShooting = false;
			isLaser = false;
			if((_player.position.x + _player.position.width / 2 > run.x + run.width / 2))
			{
				run.facing = FlxObject.RIGHT;
				facing = FlxObject.RIGHT;
				if(run.velocity.x < 200)
				{
					run.acceleration.x += run.drag.x;
				}
				else
				{
					run.velocity.x = 200;
				}
			}
			else if((_player.position.x + _player.position.width / 2  < run.x + run.width / 2))
			{
				run.facing = FlxObject.LEFT;
				facing = FlxObject.LEFT;
				if(run.velocity.x > -200)
				{
					run.acceleration.x -= run.drag.x;
				}
				else
				{
					run.velocity.x = -200;
				}
			}
			_attackTimer += FlxG.elapsed;
		}
		public function rodeo():void
		{
			if(_canAttack)
			{
				if(_wait < 1.5)
					prepare();
				else if(_wait >= 1.5)
				{
					run.acceleration.x = 0;
					if(!isRodeo)
					{
						isWandering = false;
						isGrazing = false;
						isChasing = false
						isRodeo = true;
						isShooting = false;
						isLaser = false;
						if(_player.position.x + _player.position.width / 2 > run.x + run.width / 2)
						{
							run.facing = FlxObject.RIGHT;
							facing = FlxObject.RIGHT;
						}
						else
						{
							run.facing = FlxObject.LEFT;
							facing = FlxObject.LEFT;
						}
					}
					//rampage to screen edges
					if(isRodeo)
					{
						FlxG.camera.shake(0.01);
						if(run.facing == FlxObject.RIGHT)
						{
							//emitter
							emitter.x = run.x;
							emitter.y = run.y + run.height / 2;
							if(run.x < 896 - run.width)
							{
								run.acceleration.x += run.drag.x;
							}
							else
							{
								run.velocity.x = -200;
								run.facing = FlxObject.LEFT;
							}
						}
						if(run.facing == FlxObject.LEFT)
						{
							emitter.x = run.x + run.width;
							emitter.y = run.y + run.height / 2;
							if(run.x > 352)
							{
								run.acceleration.x -= run.drag.x;
							}
							else
							{
								run.velocity.x = 200;
								run.facing = FlxObject.RIGHT;
							}
						}
					}
					_attackTimer += FlxG.elapsed;
					if(_attackTimer >= 4)
					{
						_wait = 0;
						_windup = 0;
						_canAttack = false;
						_attackTimer = 0;
						
					}
				}
			}
		}
	}
}