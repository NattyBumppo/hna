package
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	[SWF(frameRate="60", width="800", height="500", backgroundColor="0x263A3B")]
	//[SWF(frameRate="60", width="800", height="500", backgroundColor="0xFFFFFF")]
	public class Preloader extends Sprite
	{
		// Private
		private var _preloaderBackground:Shape
		private var _preloaderPercent:Shape;
		private var _checkForCacheFlag:Boolean = true;
		// Constants
		private static const MAIN_CLASS_NAME:String = "Main";
		
		public function Preloader()
		{
			trace("Preloader: Initialized.")
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function dispose():void
		{
			trace("Preloader: Disposing.")
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (_preloaderBackground)
			{
				removeChild(_preloaderBackground);
				_preloaderBackground = null;
			}
			if (_preloaderPercent)
			{
				removeChild(_preloaderPercent);
				_preloaderPercent = null;
			}
		}
		
		// Private functions
		
		private function onAddedToStage(e:Event):void
		{
			trace("Preloader: Added to stage.");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_checkForCacheFlag == true)
			{
				_checkForCacheFlag = false;
				if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
				{
					trace("Preloader: No need to load, all " + root.loaderInfo.bytesTotal + " bytes are cached.");
					finishedLoading();
				}
				else
					beginLoading();
			}
			else
			{
				if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
				{
					trace("Preloader: Finished loading all " + root.loaderInfo.bytesTotal + " bytes.");
					finishedLoading();
				}
				else
				{
					var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
					updateGraphic(percent);
					trace("Preloader: " + (percent * 100) + " %");
				}
			}
		}
		
		private function beginLoading():void
		{
			// Might not be called if cached.
			// ------------------------------
			trace("Preloader: Beginning loading.")
			_preloaderBackground = new Shape()
			_preloaderBackground.graphics.beginFill(0x333333)
			_preloaderBackground.graphics.lineStyle(2,0x000000)
			_preloaderBackground.graphics.drawRect(0,0,200,20)
			_preloaderBackground.graphics.endFill()
			
			_preloaderPercent = new Shape()
			_preloaderPercent.graphics.beginFill(0xFFFFFFF)
			_preloaderPercent.graphics.drawRect(0,0,200,20)
			_preloaderPercent.graphics.endFill()
			
			addChild(_preloaderBackground)
			addChild(_preloaderPercent)
			_preloaderBackground.x = _preloaderBackground.y = 10
			_preloaderPercent.x = _preloaderPercent.y = 10
			_preloaderPercent.scaleX = 0
		}
		
		private function updateGraphic(percent:Number):void
		{
			// Might not be called if cached.
			// ------------------------------
			_preloaderPercent.scaleX = percent
		}
		
		private function finishedLoading():void
		{
			var MainClass:Class = getDefinitionByName(MAIN_CLASS_NAME) as Class;
			
			if (MainClass == null)
				throw new Error("Preloader: There is no class \"" + MAIN_CLASS_NAME + "\".");
			
			var main:DisplayObject = new MainClass() as DisplayObject;
			if (main == null)
				throw new Error("Preloader: The class \"" + MAIN_CLASS_NAME + "\" is not a Sprite or MovieClip.");
			
			addChild(main);
			dispose();
		}
	}
}