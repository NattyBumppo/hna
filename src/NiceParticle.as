package
{
	import org.flixel.FlxParticle;
	
	public class NiceParticle extends FlxParticle
	{
		private var _dead:Boolean = false;
		public function NiceParticle()
		{
			super();
		}
		override public function update():void
		{
			if(_dead)
			{
				if(alpha > 0)
				{
					alpha -= 0.01;
				}
				else
				{
					super.kill();
				}
			}
			
		}
		override public function kill():void
		{
			_dead = true;
		}
	}
}