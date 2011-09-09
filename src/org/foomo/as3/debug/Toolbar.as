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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	import org.foomo.utils.CallLaterUtil;

	/**
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 * @todo	optimize
	 */
	public class Toolbar extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		private var _fps:Fps;
		private var _memory:Memory;
		private var _memory2:Memory2;
		private var _growls:Array = [];

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function Toolbar()
		{
			super();

			this.init();

			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public function growl(message:String):void
		{
			var growl:Growl = new Growl;
			growl.text = message;
			growl.x = (this.width - 430);
			growl.y = (this._growls.length == 0) ? ((this.visible) ? 30 : 10) : (this._growls[this._growls.length -1].y + this._growls[this._growls.length -1].height + 10);
			setTimeout(this.removeGrowl, 3000, growl);
			this._growls.push(growl);
			this.addChild(growl);

			CallLaterUtil.addCallback(this.update);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Protected methods
		//-----------------------------------------------------------------------------------------

		protected function init():void
		{
			this._fps = new Fps;
			this._memory = new Memory;
			this._memory2 = new Memory2;
		}

		protected function update():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.9);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, 24);
			this.graphics.endFill();

			this._fps.x = this.width - this._fps.width - 10;
			this._memory.x = this._fps.x - this._memory.width - 10;
			this._memory2.x = this._memory.x - this._memory2.width - 10;
			for each (var growl:Growl in this._growls) growl.x = (this.width - 430);
		}

		protected function removeGrowl(growl:Growl):void
		{
			this._growls.splice(this._growls.indexOf(growl), 1);
			this.removeChild(growl);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private eventhandler
		//-----------------------------------------------------------------------------------------

		private function addedToStageHandler(event:Event):void
		{
			this.addChild(this._fps);
			this.addChild(this._memory);
			this.addChild(this._memory2);

			CallLaterUtil.addCallback(this.update);

			this.stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.removeChild(this._fps);
			this.removeChild(this._memory);
			this.removeChild(this._memory2);
			this.stage.removeEventListener(Event.RESIZE, this.stage_resizeHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		}

		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.F12) this.visible = !this.visible;
		}

		private function stage_resizeHandler(event:Event):void
		{
			CallLaterUtil.addCallback(this.update);
		}
	}
}