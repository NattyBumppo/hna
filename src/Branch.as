package
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class Branch extends FlxGroup
	{
		public var broken:Boolean = false;
		public var sprite:FlxSprite;
		public var type:Number = 0;
		
		public var solid:Number = 0;
		
		public function Branch(X:Number = 0, Y:Number = 0, Type:Number = 0)
		{
			sprite = new FlxSprite(X, Y);
			type = Type;
			if(type == 0)
			{
				sprite.loadGraphic(DataRegistry.branch, false, false);
				sprite.height = 48;
				sprite.offset.y = 6;
			}
			else if (type == 3)
			{
				sprite.loadGraphic(DataRegistry.branch3, false, false, 114, 63);
				sprite.height = 48;
				sprite.width = 64;
				sprite.offset.y = 14;
				sprite.offset.x = 11;
			}
			sprite.immovable = !broken;
			sprite.solid = !broken;
			sprite.maxVelocity.y = 400;
			sprite.velocity.y = 0;
			sprite.acceleration.y = 0;
			add(sprite);
			//branch pieces
		}
		override public function update():void
		{
			if(broken)
			{
				if(type != 0)
				{
					solid += FlxG.elapsed;
					if(solid >= 0.3)
					{
						sprite.immovable = !broken;
						sprite.acceleration.y = 420;
						if(type != 2)
						{
							sprite.angle = -22.5;
						}
						else if(type == 2)
						{
							sprite.angle = 22.5;
						}
					}
				}
				else
				{
					sprite.immovable = !broken;
					sprite.acceleration.y = 420;
					sprite.angle = -22.5;
				}
				
			}
			super.update();
		}
		public function snap():void
		{
			//fall
			broken = true;
		}
	}
}