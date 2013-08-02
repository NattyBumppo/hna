package
{
	import org.flixel.*;
	
	public class LoadingScreen extends FlxGroup
	{
		//embedded fonts
		[Embed(source="../data/ttf/squarecaps.ttf", fontFamily="SquareCaps", embedAsCFF="false")] private var squarecaps:String;
		[Embed(source="../data/ttf/sylfaen.ttf", fontFamily="Sylfaen", embedAsCFF="false")] private var sylfaen:String;
		
		//public variables - visual
		public var bg:FlxSprite;
		public var loadingTextCaps:FlxText;
		public var loadingText:FlxText;
		public var loadingBar:FlxSprite;

		public var loadingPercentage:int = 0;
		public var loadingComplete:Boolean = false;
		
		private var _loadingTextContainer:FlxObject;
		private var _groupAlpha:Number = 1;
		
		public function LoadingScreen()
		{
			FlxG.bgColor = 0x263A3B;
			
			bg = new FlxSprite(0, 0);
			//bg.makeGraphic(FlxG.width, FlxG.height, 0xff263A3B);
			bg.loadGraphic(DataRegistry.load, false, false, 800, 500);
			
			loadingTextCaps = new FlxText(0, 0, 64);
			loadingTextCaps.setFormat("SquareCaps", 64, 0xffFFFFFF, "left");
			loadingTextCaps.text = "L";
			loadingTextCaps.width = loadingTextCaps.realWidth;
			loadingText = new FlxText(0, 0, 256);
			loadingText.setFormat("Sylfaen", 48, 0xffFFFFFF, "left");
			loadingText.text = "oading...";
			loadingText.width = loadingText.realWidth;
			
			_loadingTextContainer = new FlxObject();
			_loadingTextContainer.width = loadingTextCaps.width + loadingText.width;
			_loadingTextContainer.height = loadingTextCaps.height;
			_loadingTextContainer.x = 516;
			_loadingTextContainer.y =  198;
			
			loadingTextCaps.x = _loadingTextContainer.x;
			loadingTextCaps.y = _loadingTextContainer.y;
			loadingText.x = _loadingTextContainer.x + loadingTextCaps.width;
			loadingText.y = _loadingTextContainer.y + 2;
			
			loadingBar = new FlxSprite();
			loadingBar.makeGraphic(_loadingTextContainer.width, 8);
			loadingBar.x = _loadingTextContainer.x;
			loadingBar.y = _loadingTextContainer.y + _loadingTextContainer.height + loadingBar.height + 4;
			loadingBar.scale.x = 0;
			
			setAll("scrollFactor", new FlxPoint(0, 0));
			
			add(bg);
			add(_loadingTextContainer);
			add(loadingTextCaps);
			add(loadingText);
			add(loadingBar);
			
			//FlxG.mouse.show(DataRegistry.cursor, 1, 50, 53);
		}
		override public function update():void
		{
			if(loadingPercentage >= 100)
			{
				loadingPercentage = 100;
				loadingComplete = true;
			}
			else
			{
				loadingComplete = false;
				if(loadingPercentage < 0)
				{
					loadingPercentage = 0;
				}
			}
			if(!loadingComplete)
			{
				
				loadingBar.scale.x = loadingPercentage/100;
			}
			else
			{
				loadingBar.scale.x = 1;
				if(_groupAlpha > 0)
				{
					_groupAlpha -= 0.01;
				}
				//bg.alpha = _groupAlpha;
				loadingTextCaps.alpha = 0;
				loadingText.alpha = 0;
				loadingBar.alpha = 0;
			}
			super.update();
		}
	}
}