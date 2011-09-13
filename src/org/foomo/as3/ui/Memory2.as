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
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	import org.foomo.foomo_internal;

	use namespace foomo_internal;

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
		// ~ Constants
		//-----------------------------------------------------------------------------------------

		public static const WIDTH:int = 50;

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

			this._upper = Toolbar.getDefaultTextField();
			this._upper.width = WIDTH;

			this._lower = Toolbar.getDefaultTextField();
			this._lower.y = 10;
			this._lower.width = WIDTH;

			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
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

		protected function removedFromStageHandler(event:Event):void
		{
			this.removeChild(this._upper);
			this.removeChild(this._lower);

			this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
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