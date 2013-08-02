package
{
	import org.flixel.*;
	
	public class Item extends FlxSprite
	{
		public var name:String;
		public var type:Number;
		public var overlap:Boolean = false;
		public var pickup:Boolean = true;
		
		public function Item(X:Number = 0, Y:Number = 0, Type:Number = 0)
		{
			x = X;
			y = Y;
			type = Type;
			//gravity
			acceleration.y = 400;
			checkType();
		}
		override public function update():void
		{
			
			//fade away when picked up
			if(overlap)
			{
				if(alpha > 0)
				{
					alpha -= 0.025;
				}
				else
				{
					if(type == ItemType.MEAT)
						kill();
					//kill();
					//alpha = 0;
				}
			}
			//update after changes
			super.update();
			
		}
		public function checkType():void
		{
			//load/change graphic
			switch(type)
			{
				case ItemType.EMPTY:
					name = "Empty"
					alpha = 0;
					//fill(0xFFFFFFFF);
					break;
				case ItemType.MEAT:
					name = "Meat";
					loadGraphic(DataRegistry.meat, false, false, 95, 47);
					//scale.x = 0.75;
					//scale.y = 0.75;
					alpha = 1;
					break;
				case ItemType.CHOCOLATE:
					name = "Chocolate";
					loadGraphic(DataRegistry.chocolate, false, false, 42, 59);
					//scale.x = 0.75;
					//scale.y = 0.75;
					alpha = 1;
					break;
				case ItemType.BONE:
					name = "Bone";
					loadGraphic(DataRegistry.bone, false, false, 73, 32);
					//scale.x = 0.75;
					//scale.y = 0.75;
					alpha = 1;
					break;
				case ItemType.PLANT:
					name = "Plant";
					loadGraphic(DataRegistry.plant, false, false, 104, 98);
					//width = 32;
					//offset.x = 42;
					alpha = 1;
					break;
				case ItemType.LEAVES:
					name = "Leaves";
					loadGraphic(DataRegistry.leaves, false, false, 56, 22);
					alpha = 1;
					break;
				case ItemType.AXEHEAD:
					name = "Axe Head"
					loadGraphic(DataRegistry.axehead, false, false, 48, 59);
					alpha = 1;
					break;
				case ItemType.AXEHANDLE:
					name = "Axe Handle"
					loadGraphic(DataRegistry.axehandle, false, false, 206, 25);
					alpha = 1;
					break;
				case ItemType.AXE:
					name = "Axe"
					loadGraphic(DataRegistry.ax, false, false, 230, 59);
					alpha = 1;
					break;
				case ItemType.FAIRY:
					name = "Fairy"
					loadGraphic(DataRegistry.wisp, true, true, 203, 227);
					width = 32;
					height = 32;
					offset.x = 92;
					offset.y = 92;
					
					addAnimation("idle", [0,1,2,3,4,5,6,7,8,9,10,
						11,12,13,14,15,16,17,18,19,20,
						21,22,23,24,25,26,27,28,29,30,
						31,32,33,34,35,36,37,38,39,40,
						41,42,43,44,45,46,47,48,49,50,
						51,52,53,54,55,56,57,58,59], 60, true);
					
					play("idle");
					alpha = 1;
					break;
			}
		}
	}
}