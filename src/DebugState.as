package
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	public class DebugState extends FlxState
	{
		public var map:FlxTilemapExt;
		public var inventory:Item;
		public var overlay:FlxSprite;
		public var border:FlxSprite;
		
		private var _player:Player;
		private var _playerHead:FlxObject;
		private var _playerGibs:FlxEmitter;
		private var _items:FlxGroup;
		private var _meat:FlxGroup;
		private var _itemSpawns:Array;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffEEEEEE;
			
			//map
			map = new FlxTilemapExt;
			map.loadMap(new DataRegistry.TestHits, DataRegistry.testMapTiles);
			FlxG.log("map loaded!");
			add(map);
			//gibs
			_playerGibs = new FlxEmitter();
			_playerGibs.setXSpeed(-150, 150);
			_playerGibs.setYSpeed(-200, 200);
			_playerGibs.setRotation(-720, -720);
			_playerGibs.gravity = 420;
			_playerGibs.bounce = 0;
			_playerGibs.makeParticles(DataRegistry.blood, 50, 16, true, 0.8);
			for each(var p:FlxParticle in _playerGibs.members)
			{
				p.alpha = 0.75;
			}
			FlxG.log("_playerGibs loaded!");
			add(_playerGibs);
			//player
			_player = new Player(32, 64, _playerGibs);
			_player.setLeftControl("LEFT");
			_player.setRightControl("RIGHT");
			_player.setUpControl("UP");
			_player.setDownControl("DOWN");
			_player.setAction1Control("SPACE");
			_player.setAction2Control("SHIFT");
			FlxG.log("_player loaded!");
			add(_player);
			//hang 2.0
			_playerHead = new FlxObject(_player.position.x, _player.position.y, 32, 1);
			add(_playerHead);
			//items
			_items = new FlxGroup();
			_meat = new FlxGroup();
			var i:Item = new Item(300, 200, ItemType.CHOCOLATE);
			var o:Item = new Item(200, 200, ItemType.BONE);
			var t:Item = new Item(600, 200, ItemType.MEAT);
			_itemSpawns = new Array();
			_itemSpawns.push(new FlxPoint(i.x, i.y));
			_itemSpawns.push(new FlxPoint(o.x, o.y));
			_items.add(i);
			_items.add(o);
			_meat.add(t);
			add(_items);
			add(_meat);
			FlxG.watch(_items, "length", "Items Array");
			//inventory
			inventory = new Item();
			inventory.type = ItemType.EMPTY;
			inventory.acceleration.y = 0;
			inventory.scrollFactor.x = inventory.scrollFactor.y = 0;
			add(inventory);
		}
		override public function update():void
		{
			_playerHead.x = _player.position.x;
			_playerHead.y = _player.position.y;
			
			FlxG.camera.bounds = new FlxRect(0, 0, map.width, map.height);
			FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height);
			FlxG.camera.follow(_player.position, FlxCamera.STYLE_PLATFORMER);
			
			//enable collision checking
			FlxG.collide(_player.position, map);
			FlxG.collide(_items, map, toggleItem);
			FlxG.collide(_meat, map);
			//specific collision handling
			FlxG.overlap(_player.position, _items, item);
			FlxG.overlap(_player.position, _meat, meat);
			//Position inventory overlay
			inventory.x = FlxG.width - inventory.width * 2;
			inventory.y = inventory.height / 2;
			//Death test
			if(FlxG.keys.justPressed("K"))
			{
				_player.kill();
			}
			for each(var i:Item in _items)
			{
				if(i.alpha <= 0)
				{
					_items.remove(i);
				}
			}
			//update after changes
			super.update();
		}
		private function item(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object2 as Item;
			if(!i.overlap && i.pickup)
			{
				i.velocity.y = -200;
				i.overlap = true;
				i.pickup = false;
				if(_player._heldItem != null)
				{
					var o:Item = new Item(_player.position.x, _player.position.y, _player._heldItem.type);
					for each(var p:Item in _items.members)
					{
						FlxG.log(p.type);
						FlxG.log(o.type);
						if(p.type == o.type)
						{
							_items.replace(p, o);
						}
					}
					if(_player.facing == FlxObject.LEFT)
					{
						o.velocity.x = 100;
					}
					else if(_player.facing == FlxObject.RIGHT)
					{
						o.velocity.x = -100;
					}
					o.pickup = false;
				}
				_player.pickupItem(i);
				FlxG.log("Picked up: " + i.name);
			}
			inventory.type = _player._heldItem.type;
			inventory.checkType();
			inventory.alpha = 1;
		}
		private function meat(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object2 as Item;
			var count:Number = _items.members.length;
			if(!i.overlap && i.pickup)
			{
				FlxG.log("Picked up: " + i.name);
				i.overlap = true;
				i.pickup = false;
				i.velocity.y = -200;
				_player._heldItem = null;
				for(var n:Number = 0; n < count; n++)
				{
					var p:FlxPoint = _itemSpawns[n];
					var it:Item = _items.members[n];
					var o:Item = new Item(p.x, p.y, it.type);
					_items.replace(it, o);
				}
			}
			inventory.alpha = 0;
		}
		private function toggleItem(Object1:FlxObject, Object2:FlxObject):void
		{
			var i:Item = Object1 as Item;
			i.velocity.x = 0;
			i.pickup = true;
		}
	}
}