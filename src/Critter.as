package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Critter extends FlxSprite
	{
		public var type:Number = 0;
		public var timer:Number = 0;
		public var wanderBool:Boolean = false;
		public var wanderDirBool:Boolean = false;
		
		public function Critter(X:Number = 0, Y:Number = 0, Type:Number = 0)
		{
			super();
			x = X;
			y = Y;
			type = Type;
			acceleration.y = 420;
			maxVelocity.y = 420;
			facing = RIGHT;
			switch(type)
			{
				case CritterType.BUNNY1:
					loadGraphic(DataRegistry.bunny1, false, true, 65, 51);
					break;
			}
			FlxG.watch(this, "timer", "Critter Timer");
		}
		override public function update():void
		{
			super.update();
			if(wanderBool)
				wander();
			if(wanderDirBool)
				wanderDir(facing);
		}
		public function wander():void
		{
			timer += FlxG.elapsed;
			if(timer >= 1)
			{
				var i:Number = Math.floor(Math.random() * (2 - 1 + 1)) + 1;
				FlxG.log(i);
				if(i == 1)
					facing = LEFT;
				else
					facing = RIGHT;
				timer = 2;
				if(facing == LEFT)
				{
					timer = 0;
					velocity.y = -100;
					velocity.x = -100;
				}
				if(facing == RIGHT)
				{
					timer = 0;
					velocity.y = -100;
					velocity.x = 100;
				}
			}
		}
		public function wanderDir(Direction:uint):void
		{
			timer += FlxG.elapsed;
			if(timer >= 1)
			{
				timer = 2;
				if(Direction == LEFT)
				{
					timer = 0;
					velocity.y = -100;
					velocity.x = -100;
				}
				if(Direction == RIGHT)
				{
					timer = 0;
					velocity.y = -100;
					velocity.x = 100;
				}
			}
		}
	}
}