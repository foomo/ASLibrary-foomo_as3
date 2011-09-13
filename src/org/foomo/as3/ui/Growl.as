package org.foomo.as3.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setTimeout;

	import org.foomo.as3.logging.GrowlTarget;
	import org.foomo.logging.LogLevel;
	import org.foomo.managers.LogManager;
	import org.foomo.managers.MemoryMananager;

	public class Growl
	{
		//-----------------------------------------------------------------------------------------
		// ~ Static variables
		//-----------------------------------------------------------------------------------------

		private static var _stage:Stage;

		private static var _loggingTarget:GrowlTarget;

		private static var _display:Sprite;

		private static var _items:Array = [];

		public static var itemRenderer:Class = GrowlMessage;

		//-----------------------------------------------------------------------------------------
		// ~ Public static methods
		//-----------------------------------------------------------------------------------------

		public static function init(stage:Stage, logLevel:int=4):void
		{
			Growl._stage = stage;
			Growl._loggingTarget = new GrowlTarget(logLevel);

			LogManager.addLoggingTarget(Growl._loggingTarget);

			Growl._display = new Sprite;
			Growl._stage.addChild(Growl._display);

			Growl._stage.addEventListener(Event.RESIZE, Growl.stage_resizeHandler);
		}

		public static function set logLevel(value:int):void
		{
			Growl._loggingTarget.logLevel = value;
		}

		public static function notify(title:String, message:String):void
		{
			var item:Sprite = new Growl.itemRenderer(title, message);
			item.x = (Growl._stage.stageWidth - item.width - 10);
			item.y = (Growl._items.length == 0) ? 20 : (Growl._items[Growl._items.length -1].y + Growl._items[Growl._items.length -1].height + 10);
			Growl._items.push(item);
			Growl._display.addChild(item);
			setTimeout(Growl.removeItem, 3000, item);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private static methods
		//-----------------------------------------------------------------------------------------

		private static function removeItem(item:Sprite):void
		{
			Growl._items.splice(Growl._items.indexOf(item), 1);
			MemoryMananager.unload(Growl._display.removeChild(item));
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private static eventhandler
		//-----------------------------------------------------------------------------------------

		private static function stage_resizeHandler(event:Event):void
		{
			for each (var item:Sprite in Growl._items) item.x = (Growl._stage.stageWidth - item.width - 10);
		}
	}
}