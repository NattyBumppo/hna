package
{
	import org.flixel.*;
	
	public class Petals extends FlxSprite
	{
		private var _timer:Number = 0;
		public function Petals()
		{
			super();
			loadGraphic(DataRegistry.petalsSheet, true, true, 25, 25);
			addAnimation("drop", [0,1,2,3,4,5,6], 10, true);
			reposition();
		}
		override public function update():void
		{
			if(y > FlxG.worldBounds.height)
				reposition();
			_timer += FlxG.elapsed;
			if(_timer >= 0.5)
			{
				_timer = 0;
				randomFrame();
			}
		}
		public function reposition():void
		{
			x = -width / 2 + FlxG.random() * FlxG.worldBounds.width;
			y = -height;
			velocity.x = -10 + FlxG.random() * 100;
			velocity.y = 25 + FlxG.random() * 100;
		}
	}
}