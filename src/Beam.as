package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class Beam extends FlxSprite
	{		
		public function Beam(X:Number, Y:Number)
		{
			loadGraphic(DataRegistry.beamY, false, false, 30, 886);
			x = X;
			y = Y;
			width = 32;
			height = 96;
			offset.x = 0;
			offset.y = 800;
		}
		override public function update():void
		{
			if(alpha > 0)
			{
				alpha -= 0.02;
			}
			else
			{
				active = false;
			}
			super.update();
		}
	}
}