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
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	import org.foomo.foomo_internal;

	import spark.primitives.Rect;

	use namespace foomo_internal;

	/**
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @license http://www.opensource.org/licenses/mit-license.php
	 * @author  franklin <franklin@weareinteractive.com>
	 * @see		https://github.com/mrdoob/Hi-ReS-Stats
	 */
	public class Memory extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// ~ Constants
		//-----------------------------------------------------------------------------------------

		public static const WIDTH:int = 55;

		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		protected var _upper:TextField;
		protected var _lower:TextField;

		protected var _mem:Number = 0;
		protected var _mem_max:Number = 0;
		protected var _mem_pixel:uint;

		protected var _time:uint;

		protected var _graph:BitmapData;
		protected var _rectangle:Rectangle;

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function Memory()
		{
			super();


			this._upper = Toolbar.getDefaultTextField();
			this._upper.x = 30;
			this._upper.width = WIDTH;

			this._lower = Toolbar.getDefaultTextField();
			this._lower.x = 30;
			this._lower.y = 10;
			this._lower.width = WIDTH;

			this._rectangle = new Rectangle(29, 0, 1, 18);

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

			this._graph = new BitmapData(30, 18, false, 0x525252);
			this.graphics.beginBitmapFill(this._graph, new Matrix(1, 0, 0, 1, 0, 3));
			this.graphics.drawRect(0, 3, 30, 18);

			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this.addEventListener(MouseEvent.CLICK, this.clickHandler);
		}

		protected function removedFromStageHandler(event:Event):void
		{
			this.removeChild(this._upper);
			this.removeChild(this._lower);

			this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this.removeEventListener(MouseEvent.CLICK, this.clickHandler);
		}

		protected function enterFrameHandler(event:Event):void
		{
			var time:uint = getTimer();

			if (time - 1000 > this._time) {
				this._mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				this._mem_max = Math.max(this._mem_max, this._mem);

				var mem_gr:uint = this._mem_max / 18;

				var mem_pixel:uint = this._mem_max / 18;
				var mem_pixel_diff:uint = mem_pixel - this._mem_pixel;
				this._mem_pixel = mem_pixel;

				var mem_max_graph:uint = 18;
				var mem_graph:uint = mem_max_graph / this._mem_max  * this._mem;

				this._graph.scroll(-1, mem_pixel_diff);
				this._graph.fillRect(this._rectangle, 0x525252);
				this._graph.setPixel(this._graph.width - 1, this._graph.height - mem_graph, 0xffffff);
				this._graph.setPixel(this._graph.width - 1, this._graph.height - mem_max_graph, 0xff00ff);

				this._upper.text = this._mem_max.toFixed(2) + ' MB';
				this._lower.text = this._mem.toFixed(2) + ' MB';
				this._time = time;
			}
		}

		private function clickHandler(event:MouseEvent):void
		{
			System.gc();
		}
	}
}