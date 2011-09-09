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
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @license http://www.opensource.org/licenses/mit-license.php
	 * @author  franklin <franklin@weareinteractive.com>
	 * @see		https://github.com/mrdoob/Hi-ReS-Stats
	 */
	public class Memory2 extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		/**
		 *
		 */
		protected var _upper:TextField;
		/**
		 *
		 */
		protected var _lower:TextField;
		/**
		 *
		 */
		protected var _time:uint;

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function Memory2()
		{
			super();

			var style:TextFormat = new TextFormat();
			style.color = 0xffffff;
			style.align = 'right';
			style.font = 'Myriad Pro';
			style.leading = 0;
			style.size = 10;

			this._upper = new TextField();
			this._upper.width = 50;
			this._upper.wordWrap = false;
			this._upper.selectable = false;
			this._upper.mouseEnabled = false;
			this._upper.condenseWhite = true;
			this._upper.defaultTextFormat = style;

			this._lower = new TextField();
			this._lower.y = 10;
			this._lower.width = 50;
			this._lower.wordWrap = false;
			this._lower.selectable = false;
			this._lower.mouseEnabled = false;
			this._lower.condenseWhite = true;
			this._lower.defaultTextFormat = style;

			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Protected eventhandler
		//-----------------------------------------------------------------------------------------

		protected function addedToStageHandler(event:Event):void
		{
			this.addChild(this._upper);
			this.addChild(this._lower);

			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		}

		protected function enterFrameHandler(event:Event):void
		{
			var time:uint = getTimer();

			if (time - 1000 > this._time) {
				this._upper.text = Number(System.privateMemory * 0.000000954).toFixed(2) + ' MB'
				this._lower.text = Number(System.freeMemory * 0.000000954).toFixed(2) + ' MB';
				this._time = time;
			}
		}
	}
}