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
	import flash.external.ExternalInterface;
	
	import org.foomo.utils.UIDUtil;

	/**
	 * Base object to find a reference in the html document
	 * Usage: window.foomo.browserUtil.getInstance();
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 * @todo	I might wanna move the js namespace to a more specific flash one
	 */
	public class BrowserUtil
	{
		//-----------------------------------------------------------------------------------------
		// ~ Static variables
		//-----------------------------------------------------------------------------------------

		private static var _scriptInitialized:Boolean = false;
		private static var _confirmClosure:Boolean = false;
		private static var _uid:String;

		//-----------------------------------------------------------------------------------------
		// ~ Public static methods
		//-----------------------------------------------------------------------------------------

		/**
		 * Writes the base js object
		 */
		public static function init():void
		{
			if (!ExternalInterface.available || _scriptInitialized) return;
			_uid = UIDUtil.create();
			ExternalInterface.addCallback(_uid, function():void{});
			ExternalInterface.call(BrowserUtil_JavaScript.CODE);
			ExternalInterface.call("window.foomo.browserUtil.init", _uid);
			_scriptInitialized = true;
		}

		/**
		 * @param message to show before closing the window
		 */
		public static function confirmClosusure(message:String='Do you really want to leave this page?'):void
		{
			if (BrowserUtil._confirmClosure) return;
			BrowserUtil.init();
			ExternalInterface.call("window.foomo.browserUtil.confirmMessage", message);
			BrowserUtil._confirmClosure = true;
		}
		
		public static function bind(event:String, callback:Function):void
		{
			BrowserUtil.init();
			var callbackId:String = UIDUtil.create();
			ExternalInterface.call("window.foomo.browserUtil.bind", _uid, event, callbackId);
			ExternalInterface.addCallback(callbackId, callback);
		}
		
		public static function trigger(event:String, data:Object=null):void
		{
			BrowserUtil.init();
			ExternalInterface.call("window.foomo.browserUtil.trigger", _uid, event, data);
		}
	}
}

/**
 *
 */
[ExcludeClass]
class BrowserUtil_JavaScript
{
	public static const CODE:XML =
		<script><![CDATA[
		function() {

			Foomo = {} || Foomo;

			Foomo.BrowserUtil = function() {};

			Foomo.BrowserUtil.prototype = {
				instances: {},

				init: function(id)
				{
					this.instances[id] = this.findSwf(id);
				},

				getInstance: function(id)
				{
					return this.instances[id];
				},

				findSwf: function(id)
				{
					var objects = document.getElementsByTagName("object");
					for (var i = 0; i < objects.length; i++) {
						if (typeof objects[i][id] != "undefined") return objects[i];
					}

					var embeds = document.getElementsByTagName("embed");

					for (var j = 0; j < embeds.length; j++) {
						if (typeof embeds[j][id] != "undefined") return embeds[j];
					}

					return null;
				},

				bind: function(id, event, callback)
				{
					var instance = this.getInstance(id);
					var $target = $(instance).parent();
					$target.bind(event, function(event, data) {
						instance[callback](data);
					});
				},

				trigger: function(id, event, data)
				{
					var instance = this.getInstance(id)
					var $target = $(instance).parent();
					$target.trigger(event, [data]);
				}
			}

			window.foomo = {} || window.foomo;
			window.foomo.browserUtil = window.foomo.browserUtil || new Foomo.BrowserUtil;
		}
		]]></script>
	;
}