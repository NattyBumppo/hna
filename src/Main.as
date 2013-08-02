package
{
	import org.flixel.FlxGame;
	[SWF(width="800", height="500", backgroundColor="0xFFFFFF")]
	
	public class Main extends FlxGame
	{
		//version info
		static public var version:String = "a10.6.16.13";
		
		//constructor
		public function Main()
		{
			super(800, 500, IntroLevel_01State, 1, 60, 60);
			forceDebugger = true;
		}
	}
}