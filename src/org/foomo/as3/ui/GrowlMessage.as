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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.foomo.foomo_internal;

	use namespace foomo_internal;

	/**
	 * Growl like messaging display
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 */
	public class GrowlMessage extends Sprite
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

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function GrowlMessage(title:String, message:String)
		{
			super();

			var format:TextFormat = Toolbar.defaultTextFormat;
			format.align = TextFormatAlign.LEFT;

			this._title = Toolbar.getDefaultTextField();
			this._title.defaultTextFormat = format;
			this._title.text = title;
			this._title.autoSize = TextFieldAutoSize.LEFT;
			this._title.width = WIDTH;
			this.addChild(this._title);

			this._message= Toolbar.getDefaultTextField();
			this._message.defaultTextFormat = format;
			this._message.y = 15;
			this._message.text = message;
			this._message.autoSize = TextFieldAutoSize.LEFT;
			this._message.width = WIDTH;
			this.addChild(this._message);

			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.7);
			this.graphics.drawRect(-10, -10, this.width + 10, this.height + 10);
			this.graphics.endFill();
		}
	}
}