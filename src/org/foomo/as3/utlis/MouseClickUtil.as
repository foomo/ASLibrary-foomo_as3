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
package org.foomo.as3.utlis
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.system.System;

	import org.foomo.managers.LogManager;

	/**
	 * Prevents the default flash right mouse click behavior and simulates a right & middle click
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 */
	public class MouseClickUtil
	{
		//-----------------------------------------------------------------------------------------
		// ~ Static variables
		//-----------------------------------------------------------------------------------------

		/**
		 *
		 */
		private static var _scriptInitialized:Boolean = false;
		/**
		 *
		 */
		private static var _stage:Stage;

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public static function init(stage:Stage):void
		{
			if (!ExternalInterface.available || _scriptInitialized) return;
			BrowserUtil.init();
			ExternalInterface.call(MouseClickUtil_JavaScript.CODE);
			ExternalInterface.call("window.foomo.mouseClickUtil.register", 'external_mouseCallback');
			ExternalInterface.addCallback('external_mouseCallback', external_mouseCallback);
			_scriptInitialized = true;
			_stage = stage;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Private methods
		//-----------------------------------------------------------------------------------------

		private static function external_mouseCallback(type:String, ctrlKey:Boolean, altKey:Boolean, shiftKey:Boolean, buttonDown:Boolean):void
		{
			var dojs:Array =  _stage.getObjectsUnderPoint(new Point(_stage.mouseX, _stage.mouseY));
			if (dojs.length == 0) return;
			var doj:DisplayObject = dojs[dojs.length - 1];
			while (doj != null && doj.parent != null) {
				if (doj is InteractiveObject) {
					doj.dispatchEvent(new MouseEvent(type, true, false, doj.mouseX, doj.mouseY, InteractiveObject(doj), ctrlKey, altKey, shiftKey, buttonDown));
					if (type == 'rightMouseUp') doj.dispatchEvent(new MouseEvent('rightClick', true, false, doj.mouseX, doj.mouseY, InteractiveObject(doj), ctrlKey, altKey, shiftKey, buttonDown));
					if (type == 'middleMouseUp') doj.dispatchEvent(new MouseEvent('middleClick', true, false, doj.mouseX, doj.mouseY, InteractiveObject(doj), ctrlKey, altKey, shiftKey, buttonDown));
					break;
				}
				doj = doj.parent;
			}
		}
	}
}

/**
 *
 */
[ExcludeClass]
class MouseClickUtil_JavaScript
{
	public static const CODE:XML =
		<script><![CDATA[
		function() {

			Foomo = {} || Foomo;

			Foomo.MouseClickUtil = function() {
				this.instance = window.foomo.browserUtil.getInstance();
			};

			Foomo.MouseClickUtil.prototype = {
				instance:null,

				register: function(callback)
				{
					var self = this;
					window.addEventListener("mousedown", function(event) {return self.mouseEventHandler(event, callback, 1, 'middleMouseDown', true)}, true);
					window.addEventListener("mouseup", function(event) {return self.mouseEventHandler(event, callback, 1, 'middleMouseUp', false)}, true);
					window.addEventListener("mousedown", function(event) {return self.mouseEventHandler(event, callback, 2, 'rightMouseDown', true)}, true);
					window.addEventListener("mouseup", function(event) {return self.mouseEventHandler(event, callback, 2, 'rightMouseUp', false)}, true);
				},

				mouseEventHandler: function(event, callback, button, type, buttonDown)
				{
					if (event.button != button) return true;
					event.preventDefault();
					event.stopPropagation();
					this.instance[callback](type, event.ctrlKey, event.altKey, event.shiftKey, buttonDown);
					return false;
				},
			}

			window.foomo.mouseClickUtil = new Foomo.MouseClickUtil;
		}
		]]></script>
		;
}