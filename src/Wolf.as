package
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class Wolf extends FlxSprite
	{
		public var isSleeping:Boolean = false;
		public var isSnarling:Boolean = false;
		public var _wag:Number = 0;
		private var _wagFlag:Boolean = false;
		private var _timer:Number = 0;
		
		public function Wolf(X:Number = 0, Y:Number = 0)
		{
			loadGraphic(DataRegistry.wolf, true, true, 348, 165);
			scale = new FlxPoint(0.5, 0.5);
			width = 96;
			height = 96;
			offset.x = 112;
			offset.y = 14;
			FlxG.watch(this, "x", "Wolf offx");
			FlxG.watch(this, "y", "Wolf offy");
			x = X;
			y = Y;
			immovable = true;

			addAnimation("idle", [21], 60, true);
			addAnimation("wag", [0,1,2,3,4,5,6,7,8,9,
								 10,11,12,13,14,15,16,17,1,19,
								 20,21,22,23,24,25,26,27,28,29,
								 30,31,32,33,34,35,36,37,38,39,
								 40,41,42,43,44,45,46,47,48,49], 120, false);
		}
		override public function update():void
		{
			_timer += FlxG.elapsed;
			if(_timer >= 1)
			{
				_timer = 0;
				_wag = Math.random() * 10;
			}
			if(FlxU.floor(_wag) > 4 && FlxU.floor(_wag) < 8)
			{
				if(!_wagFlag)
				{
					_wagFlag = true;
					play("wag");
				}
				
			}
			
			if(frame == 49)
			{
				if(_curAnim.name == "wag")
				{
					_wagFlag = false;
					play("idle");
				}
				
			}
			
			
			
			super.update();
		}
	}
}