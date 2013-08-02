package
{	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxText;
	
	public class Narrator extends FlxGroup
	{
		[Embed(source="../data/ttf/squarecaps.ttf", fontFamily="SquareCaps", embedAsCFF="false")] private var squarecaps:String;
		[Embed(source="../data/ttf/sylfaen.ttf", fontFamily="Sylfaen", embedAsCFF="false")] private var sylfaen:String;
		
		//text
		private var _fullText:String;
		private var _firstLetter:FlxText;
		private var _lastLetters:FlxText;
		private var _position:FlxObject;
		private var _combined:FlxGroup;

		//misc
		public var isNarrating:Boolean = false;
		public var _display:Boolean;
		public var _timer:Number;
		public var timeToDisplay:Number = 3;
		
		public function Narrator(X:Number, Y:Number)
		{
			_display = false;
			_timer = 0;
			FlxG.watch(this, "_timer", "Internal Timer");
			//initialization and positioning
			
		}
		public function stop():void
		{
			_firstLetter.kill();
			_lastLetters.kill();
			_position.kill();
			_timer = 0;
			isNarrating = false;
		}
		override public function update():void
		{
			//update after changes
			super.update();
			//start timer when on-screen
			if(_display)
			{
				//fadein
				fadeIn();
				_timer += FlxG.elapsed;
				if(_timer >= timeToDisplay)
				{
					_display = false;
				}
			}
			else
			{
				if(_position)
					//fadeout
					fadeOut();
			}
		}
		public function narrate(s:String = null):void
		{
			_position = new FlxObject(0, 0);
			_position.scrollFactor.x = _position.scrollFactor.y = 0;
			_combined = new FlxGroup();
			_firstLetter = new FlxText(0, 0, 48);
			_firstLetter.alpha = 0;
			_firstLetter.setFormat("SquareCaps", 32, 0xffFFFFFF, "left");
			_firstLetter.scrollFactor.x = _firstLetter.scrollFactor.y = 0;
			_lastLetters = new FlxText(0 + 46, 0 + 6, FlxG.width - 66);
			_lastLetters.alpha = 0;
			_lastLetters.setFormat("Sylfaen", 20, 0xffFFFFFF, "left");
			_lastLetters.scrollFactor.x = _lastLetters.scrollFactor.y = 0;
			
			_fullText = s;
			_firstLetter.text = _fullText.substr(0,1);
			_lastLetters.text = _fullText.substr(1);
			//adjust width of objects for center positioning
			_firstLetter.width = _firstLetter.realWidth;
			_lastLetters.width = _lastLetters.realWidth;
			//set up placeholder
			_position.width = _firstLetter.width + _lastLetters.width;
			_position.height = _firstLetter.height;
			_position.x = (FlxG.width / 2 - _position.width / 2);
			_position.y =  (FlxG.height - _position.height) - 6;
			//reposition texts
			_firstLetter.x = _position.x;
			_firstLetter.y = _position.y;
			_lastLetters.x = _position.x + _firstLetter.width;
			_lastLetters.y = _position.y + 4;
			
			add(_position);
			add(_firstLetter);
			add(_lastLetters);
			_display = true;
			isNarrating = true;
		}
		private function fadeIn():void
		{
			//fadin
			if(_firstLetter.alpha <= 1)
			{
				_firstLetter.alpha += 0.05;
				_lastLetters.alpha += 0.05;
			}
		}
		private function fadeOut():void
		{
			//fadeout
			if(_firstLetter.alpha > 0)
			{
				_firstLetter.alpha -= 0.05;
				_lastLetters.alpha -= 0.05;
				_timer = 0;
				isNarrating = false;
			}
			else if (_firstLetter.alpha <= 0)
			{
				_firstLetter.kill();
				_lastLetters.kill();
				_position.kill();
				//remove(_firstLetter);
				//remove(_lastLetters);
				//remove(_position);
			}
		}
	}
}