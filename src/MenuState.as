package
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MenuState extends FlxState
	{
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		public var title:FlxText;
		public var version:FlxText;
		public var playButton:FlxButton;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffEEEEEE;
			FlxG.mouse.show();
			//FlxG.visualDebug = true;
			
			//border
			border = new FlxSprite(0, 0);
			border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
			border.scrollFactor.x = 0;
			border.scrollFactor.y = 0;
			add(border);
			
			//title text
			title = new FlxText(0, 0, 240, "Paseo");
			title.setFormat(null, 64, 0xffDED29E, "center");
			title.x = FlxG.width / 2 - title.width / 2;
			title.y = FlxG.height / 2 - title.height;
			title.antialiasing = true;
			add(title);
			
			//play button
			playButton = new FlxButton(0, 0, "Play", onPlay);
			playButton.x = FlxG.width / 2 - playButton.width / 2;
			playButton.y = title.y + title.height + playButton.height;
			playButton.color = 0xffB7C68B;
			playButton.label.color = 0xffF4F0CB;
			add(playButton);
			
			//painterly overlay
			overlay = new FlxSprite(0, 0);
			overlay.loadGraphic(DataRegistry.multiplyTexture, false, false, 800, 500);
			overlay.scrollFactor.x = 0;
			overlay.scrollFactor.y = 0;
			overlay.blend = "multiply";
			add(overlay);
			
			//border
			border = new FlxSprite(0, 0);
			border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
			border.scrollFactor.x = 0;
			border.scrollFactor.y = 0;
			add(border);
			
			//version info
			version = new FlxText(0, 0, 120, Main.version);
			version.setFormat(null, 16, 0xffDED29E, "center");
			version.x = FlxG.width - version.width;
			version.y = FlxG.height - version.height;
			version.antialiasing = true;
			add(version);	
		}
		override public function update():void
		{
			super.update();
		}
		private function onPlay():void
		{
			//reset button status
			playButton.status = FlxButton.NORMAL;
			//switch active state
			FlxG.switchState(new IntroLevel_01State());
		}
	}
}