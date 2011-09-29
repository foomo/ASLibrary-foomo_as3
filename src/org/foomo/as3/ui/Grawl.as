package org.foomo.as3.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setTimeout;

	import org.foomo.managers.MemoryMananager;
	import org.foomo.utils.EventHandlerUtil;

	public class Grawl
	{
		//-----------------------------------------------------------------------------------------
		// ~ Static variables
		//-----------------------------------------------------------------------------------------

		private static var _stage:Stage;

		private static var _display:Sprite;

		private static var _items:Array = [];

		public static var itemRendererClass:Class = GrawlMessage;

		public static var displayTime:uint = 3000;

		//-----------------------------------------------------------------------------------------
		// ~ Public static methods
		//-----------------------------------------------------------------------------------------

		public static function init(stage:Stage):void
		{
			Grawl._stage = stage;

			Grawl._display = new Sprite;
			Grawl._stage.addChild(Grawl._display);

			Grawl._stage.addEventListener(Event.RESIZE, Grawl.stage_resizeHandler);
		}

		public static function notify(title:String, message:String, sticky:Boolean=false):IGrawlMessage
		{
			var item:IGrawlMessage = new Grawl.itemRendererClass(title, message, sticky);

			DisplayObject(item).x = (Grawl._stage.stageWidth - DisplayObject(item).width - 10);
			DisplayObject(item).y = (Grawl._items.length == 0) ? 20 : (Grawl._items[Grawl._items.length -1].y + Grawl._items[Grawl._items.length -1].height + 10);
			Grawl._items.push(item);
			Grawl._display.addChild(DisplayObject(item));

			// auto remove if not sticky
			if (!sticky) setTimeout(Grawl.removeItem, Grawl.displayTime, item);
			// listen for remove event
			item.addEventListener(Event.CLOSE, EventHandlerUtil.addCallback(Grawl.removeItem, null, item));

			return item as IGrawlMessage;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private static methods
		//-----------------------------------------------------------------------------------------

		private static function removeItem(item:Sprite):void
		{
			Grawl._items.splice(Grawl._items.indexOf(item), 1);
			MemoryMananager.unload(Grawl._display.removeChild(item));
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private static eventhandler
		//-----------------------------------------------------------------------------------------

		private static function stage_resizeHandler(event:Event):void
		{
			for each (var item:Sprite in Grawl._items) item.x = (Grawl._stage.stageWidth - item.width - 10);
		}
	}
}