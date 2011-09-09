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
package org.foomo.as3.debug
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	/**
	 * Growl like messaging display
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 */
	public class Growl extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		protected var _textfield:TextField;

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function Growl()
		{
			super();

			var style:TextFormat = new TextFormat();
			style.color = 0xffffff;
			style.align = 'left';
			style.font = 'Myriad Pro';
			style.leading = 0;
			style.size = 12;

			this._textfield = new TextField();
			this._textfield.x = 10;
			this._textfield.y = 10;
			this._textfield.width = 400;
			this._textfield.wordWrap = true;
			this._textfield.selectable = false;
			this._textfield.mouseEnabled = false;
			this._textfield.condenseWhite = true;
			this._textfield.defaultTextFormat = style;

			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public function set text(value:String):void
		{
			this._textfield.text = value;
			this._textfield.autoSize = TextFieldAutoSize.LEFT;
			this.update();
		}

		//-----------------------------------------------------------------------------------------
		// ~ Protected eventhandler
		//-----------------------------------------------------------------------------------------

		protected function addedToStageHandler(event:Event):void
		{
			this.addChild(this._textfield);
		}

		protected function removedFromStageHandler(event:Event):void
		{
			this.removeChild(this._textfield);
			this._textfield = null;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Protected methods
		//-----------------------------------------------------------------------------------------

		protected function update():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.7);
			this.graphics.drawRect(0, 0, this._textfield.width + 20, this._textfield.height +20);
			this.graphics.endFill();
		}
	}
}