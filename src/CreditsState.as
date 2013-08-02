package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class CreditsState extends FlxState
	{
		[Embed(source="../data/ttf/sylfaen.ttf", fontFamily="Sylfaen", embedAsCFF="false")] private var sylfaen:String;
		
		[Embed(source="../data/Happy_Ending.mp3"] static public var Happy:Class;
		
		public var timer:Number = 0;
		public var paseo:FlxSprite;
		public var rainbow:FlxSprite;
		public var rainbow2:FlxSprite;
		public var rainbow3:FlxSprite;
		public var bgRect:FlxSprite;
		public var glow:FlxSprite;
		public var trees1:FlxSprite;
		public var trees2:FlxSprite;
		public var trees3:FlxSprite;
		public var stars1:FlxSprite;
		public var stars2:FlxSprite;
		public var stars3:FlxSprite;
		public var stars4:FlxSprite;
		public var path:FlxPath;
		public var end:FlxSprite;
		
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		
		public var text1:FlxText;
		public var text2:FlxText;
		
		override public function create():void
		{
			//FlxG.visualDebug = true;
			
			FlxG.playMusic(Happy);
			FlxG.bgColor = 0xff0F2028;
			
			paseo = new FlxSprite(0, 64);
			paseo.loadGraphic(DataRegistry.paseo_sheet, true, false, 437, 303);
			paseo.x = FlxG.width - paseo.width - 64;
			paseo.addAnimation("ride", [0,1], 4, true);
			paseo.play("ride");
			
			glow = new FlxSprite(0,0, DataRegistry.glow);
			glow.y = FlxG.height - glow.height + 24;
			add(glow);
			
			rainbow = new FlxSprite(0,0);
			rainbow.loadGraphic(DataRegistry.rainbow, false, false, 342, 109);
			add(rainbow);
			rainbow2 = new FlxSprite(rainbow.x + rainbow.width,0);
			rainbow2.loadGraphic(DataRegistry.rainbow, false, false, 342, 109);
			add(rainbow2);
			rainbow3 = new FlxSprite(rainbow2.x + rainbow2.width,0);
			rainbow3.loadGraphic(DataRegistry.rainbow, false, false, 342, 109);
			add(rainbow3);
			
			bgRect = new FlxSprite(paseo.x + paseo.width / 2, 0);
			bgRect.makeGraphic(paseo.width, FlxG.height, 0xff0F2028);
			add(bgRect);
			
			stars1 = new FlxSprite(0, 0, DataRegistry.stars);
			add(stars1);
			stars2 = new FlxSprite(stars1.x + stars1.width, 0, DataRegistry.stars);
			add(stars2);
			
			trees1 = new FlxSprite(0, 0, DataRegistry.trees);
			trees1.y = FlxG.height - trees1.height;
			add(trees1);
			trees2 = new FlxSprite(trees1.x + trees1.width, 0, DataRegistry.trees);
			trees2.y = FlxG.height - trees2.height;
			add(trees2);
			trees3 = new FlxSprite(trees2.x + trees2.width, 0, DataRegistry.trees);
			trees3.y = FlxG.height - trees3.height;
			add(trees3);
			
			path = new FlxPath();
			path.add(paseo.x + paseo.width / 2 , paseo.y + paseo.height / 2);
			path.add(paseo.x + paseo.width / 2, (paseo.y + paseo.height / 2) - 32);
			
			add(paseo);
			
			end = new FlxSprite(0, 0, DataRegistry.theEnd);
			end.x = FlxG.width / 2 - end.width / 2;
			end.y = FlxG.height / 2 - end.height / 2 - 57;
			add(end);
			end.alpha = 0;
			
			text1 = new FlxText(48, 40, 256);
			text1.setFormat("Sylfaen", 20, 0xff59717C);
			text1.text = "Producer, Artist, Animator";
			text1.width = text1.realWidth;
			add(text1);
			text2 = new FlxText(80, text1.x + text1.height + 12 - 24, 256);
			text2.setFormat("Sylfaen", 30, 0xffB2C7C9);
			text2.text = "Alice Fox";
			text2.width = text2.realWidth;
			add(text2);
			
			text1.alpha = 0;
			text2.alpha = 0;
			
			overlay = new FlxSprite(0, 0);
			overlay.loadGraphic(DataRegistry.multiplyTexture, false, false, 800, 500);
			overlay.blend = "multiply";
			add(overlay);
			
			border = new FlxSprite(0, 0);
			border.loadGraphic(DataRegistry.gameBorder, false, false, 800, 500);
			add(border);
			
			paseo.followPath(path, 60, FlxObject.PATH_LOOP_FORWARD);
			FlxG.watch(this, "timer", "Timer");
			
		}
		override public function update():void
		{
			timer += FlxG.elapsed;
			if(timer >= 4 && timer < 8)
			{
				if(text1.alpha >= 0)
				{
					text1.alpha += 0.01;
					text2.alpha += 0.01;
				}
			}
			if(timer >= 8 && timer < 12)
			{
				if(text1.alpha <= 1)
				{
					text1.alpha -= 0.01;
					text2.alpha -= 0.01;
				}
			}
			if(timer >= 12 && timer < 16)
			{
				text1.text = "Programmer";
				text2.width = 512;
				text2.text = "Kiersten Redmyer";
				if(text1.alpha >= 0)
				{
					text1.alpha += 0.01;
					text2.alpha += 0.01;
				}
			}
			if(timer >= 16 && timer < 20)
			{
				if(text1.alpha <= 1)
				{
					text1.alpha -= 0.01;
					text2.alpha -= 0.01;
				}
			}
			if(timer >= 20 && timer < 24)
			{
				text1.text = "Composer, Level Designer";
				text2.width = 512;
				text2.text = "Mark Reichwein";
				if(text1.alpha >= 0)
				{
					text1.alpha += 0.01;
					text2.alpha += 0.01;
				}
			}
			if(timer >= 24 && timer < 28)
			{
				if(text1.alpha <= 1)
				{
					text1.alpha -= 0.01;
					text2.alpha -= 0.01;
				}
			}
			if(timer >= 28 && timer < 32)
			{
				text1.text = "Writer, Narrator";
				text2.width = 512;
				text2.text = "Michael McCaskill";
				if(text1.alpha >= 0)
				{
					text1.alpha += 0.01;
					text2.alpha += 0.01;
				}
			}
			if(timer >= 32 && timer < 34)
			{
				if(text1.alpha <= 1)
				{
					text1.alpha -= 0.01;
					text2.alpha -= 0.01;
				}
			}
			if(timer >= 34 && timer < 38)
			{
				bgRect.velocity.x = 100;
				rainbow.velocity.x = -250;
				rainbow2.velocity.x = -250;
				rainbow3.velocity.x = -250;
				paseo.stopFollowingPath(false);
				paseo.velocity.x = 100;
				paseo.velocity.y = -100;

			}
			if(timer >= 38)
			{
				if(end.alpha <= 1)
				{
					end.alpha += 0.01;
					trees1.velocity.x = 0;
					trees2.velocity.x = 0;
					trees3.velocity.x = 0;
					
					stars1.velocity.x = 0;
					stars2.velocity.x = 0;
				}
			}
			
			if(timer < 34)
			{
				rainbow.velocity.x = -350;
				rainbow2.velocity.x = -350;
				rainbow3.velocity.x = -350;
			}
			
			
			rainbow.blend = "difference";
			rainbow2.blend = "difference";
			rainbow3.blend = "difference";
			
			if(timer < 38)
			{
				trees1.velocity.x = -50;
				trees2.velocity.x = -50;
				trees3.velocity.x = -50;
				
				stars1.velocity.x = -15;
				stars2.velocity.x = -15;
			}
			
			
			if(stars1.x <= -stars1.width)
			{
				stars1.x = stars2.x + stars1.width;
			}
			if(stars2.x <= -stars2.width)
			{
				stars2.x = stars1.x + stars2.width;
			}
			
			if(trees1.x <= -trees1.width)
			{
				trees1.x = trees3.x + trees1.width;
			}
			
			if(trees2.x <= -trees2.width)
			{
				trees2.x = trees1.x + trees2.width;
			}
			
			if(trees3.x <= -trees3.width)
			{
				trees3.x = trees2.x + trees3.width;
			}
			
			rainbow.y = paseo.y + paseo.height / 2 - rainbow.height / 2 + 36;
			rainbow2.y = rainbow.y;
			rainbow3.y = rainbow.y;
			
			if(rainbow.x <= -rainbow.width)
			{
				rainbow.x = rainbow3.x + rainbow.width;
			}
			
			if(rainbow2.x <= -rainbow2.width)
			{
				rainbow2.x = rainbow.x + rainbow2.width;
			}
			
			if(rainbow3.x <= -rainbow3.width)
			{
				rainbow3.x = rainbow2.x + rainbow3.width;
			}

			super.update();
		}
	}
}