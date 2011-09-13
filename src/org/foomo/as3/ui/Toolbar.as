/*
 * This file is part of the foomo Opensource Framework.
 *
 * The foomo Opensource Framework is free software: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public License as
 * published  by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * The foomo Opensource Framework is distributed in the hope that it will
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along with
 * the foomo Opensource Framework. If not, see <http://www.gnu.org/licenses/>.
 */
package org.foomo.as3.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	import org.foomo.foomo_internal;
	import org.foomo.utils.ArrayUtil;
	import org.foomo.utils.CallLaterUtil;

	use namespace foomo_internal;

	/**
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 * @todo	optimize
	 */
	public class Toolbar extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// ~ Static initialization
		//-----------------------------------------------------------------------------------------

		private static var _initializationObject:Object
		{
			Toolbar.defaultTextFormat = new TextFormat();
			Toolbar.defaultTextFormat.color = 0xffffff;
			Toolbar.defaultTextFormat.align = 'right';
			Toolbar.defaultTextFormat.font = 'Myriad Pro';
			Toolbar.defaultTextFormat.leading = 0;
			Toolbar.defaultTextFormat.size = 10;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Static variables
		//-----------------------------------------------------------------------------------------

		private static var _stage:Stage;

		private static var _display:Sprite;

		private static var _items:Array = [];

		public static var positionFunction:Function = Toolbar.positionItem;

		public static var backgroundFunction:Function = Toolbar.drawBackground;

		foomo_internal static var defaultTextFormat:TextFormat;

		//-----------------------------------------------------------------------------------------
		// ~ Public static methods
		//-----------------------------------------------------------------------------------------

		public static function init(stage:Stage, visible:Boolean=true):void
		{
			Toolbar._stage = stage;

			Toolbar._display = new Sprite;
			Toolbar._display.visible = visible;
			Toolbar._stage.addChild(Toolbar._display);

			Toolbar.addItem(new Fps);
			Toolbar.addItem(new Memory);
			Toolbar.addItem(new Memory2);

			Toolbar._stage.addEventListener(Event.RESIZE, Toolbar.stage_resizeHandler);
			Toolbar._stage.addEventListener(KeyboardEvent.KEY_DOWN, Toolbar.stage_keyDownHandler);
		}

		public static function addItem(item:Sprite):void
		{
			Toolbar._items.push(item);
			Toolbar._display.addChild(item);
			CallLaterUtil.addCallback(Toolbar.update);
		}

		public static function removeItem(item:Sprite):void
		{
			ArrayUtil.remove(item, Toolbar._items);
			Toolbar._display.removeChild(item);
			CallLaterUtil.addCallback(Toolbar.update);
		}

		public static function set visible(value:Boolean):void
		{
			Toolbar._display.visible = !Toolbar._display.visible;
		}

		public static function get visible():Boolean
		{
			return Toolbar._display.visible;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Internal methods
		//-----------------------------------------------------------------------------------------

		foomo_internal static function getDefaultTextField():TextField
		{
			var textField:TextField = new TextField();
			textField.wordWrap = true;
			textField.multiline = false;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.condenseWhite = true;
			textField.defaultTextFormat = Toolbar.defaultTextFormat;
			return textField;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private eventhandler
		//-----------------------------------------------------------------------------------------

		private static function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.F12) Toolbar.visible = !Toolbar.visible;
		}

		private static function stage_resizeHandler(event:Event):void
		{
			CallLaterUtil.addCallback(Toolbar.update);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private static methods
		//-----------------------------------------------------------------------------------------

		private static function update():void
		{
			Toolbar.backgroundFunction.apply(null, [Toolbar._display, Toolbar._stage.stageWidth, Toolbar._stage.stageHeight]);
			Toolbar.positionFunction.apply(null, [Toolbar._display, Toolbar._items, Toolbar._stage.stageWidth, Toolbar._stage.stageHeight]);
		}

		private static function positionItem(display:Sprite, items:Array, stageWidth:int, stageHeight:int):void
		{
			var offset:int = 0;
			for each (var item:Sprite in items) {
				item.x = stageWidth - item.width - offset - 10;
				offset = stageWidth - item.x;
			}
		}

		private static function drawBackground(display:Sprite, stageWidth:int, stageHeight:int):void
		{
			display.graphics.clear();
			display.graphics.beginFill(0x000000, 0.9);
			display.graphics.drawRect(0, 0, stageWidth, 24);
			display.graphics.endFill();
		}
	}
}