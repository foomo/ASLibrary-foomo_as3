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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.foomo.as3.display.SpriteComponent;
	import org.foomo.foomo_internal;

	use namespace foomo_internal;

	[Event(name="close", type="flash.events.Event")]

	/**
	 * Growl like messaging display
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 */
	public class GrawlMessage extends SpriteComponent implements IGrawlMessage
	{
		//-----------------------------------------------------------------------------------------
		// ~ Constants
		//-----------------------------------------------------------------------------------------

		public static const WIDTH:int = 400;

		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		protected var _title:TextField;

		protected var _message:TextField;

		protected var _sticky:Boolean;

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function GrawlMessage(title:String, message:String, sticky:Boolean)
		{
			super();

			var format:TextFormat = Toolbar.defaultTextFormat;
			format.align = TextFormatAlign.LEFT;

			this._title = Toolbar.getDefaultTextField();
			format.bold = true;
			this._title.defaultTextFormat = format;
			this._title.width = WIDTH;
			this.addChild(this._title);
			this.title = title;

			this._message = Toolbar.getDefaultTextField();
			format.bold = false;
			this._message.defaultTextFormat = format;
			this._message.y = 12;
			this._message.width = WIDTH;
			this.addChild(this._message);
			this.message = message;

			this._sticky = sticky;
			if (this._sticky) this.addEventListener(MouseEvent.CLICK, this.clickHandler);

			this.updateDisplayList();
		}

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public function get title():String
		{
			return this._title.text;
		}
		public function set title(value:String):void
		{
			this._title.text = value;
			this._title.autoSize = TextFieldAutoSize.LEFT;
			this.invalidateDisplayList();
		}

		public function get message():String
		{
			return this._message.text;
		}
		public function set message(value:String):void
		{
			this._message.text = value;
			this._message.autoSize = TextFieldAutoSize.LEFT;
			this.invalidateDisplayList();
		}

		public function remove():void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		//-----------------------------------------------------------------------------------------
		// ~ Overriden methods
		//-----------------------------------------------------------------------------------------

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.7);
			this.graphics.drawRect(-10, -7, this.width + 10, this.height + 12);
			this.graphics.endFill();

			if (this._sticky) {
				this.graphics.lineStyle(1, 0xffffff, 1);
				this.graphics.moveTo(-7, -4);
				this.graphics.lineTo(-2, 1);
				this.graphics.moveTo(-7, 1);
				this.graphics.lineTo(-2, -4);
			}
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private eventhandler
		//-----------------------------------------------------------------------------------------

		private function clickHandler(event:MouseEvent):void
		{
			this.remove();
		}
	}
}