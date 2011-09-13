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

		//-----------------------------------------------------------------------------------------
		// ~ Public static methods
		//-----------------------------------------------------------------------------------------

		/**
		 * Writes the base js object
		 */
		public static function init():void
		{
			if (!ExternalInterface.available || _scriptInitialized) return;
			var uid:String = UIDUtil.create();
			ExternalInterface.addCallback(uid, function():void{});
			ExternalInterface.call(BrowserUtil_JavaScript.CODE);
			ExternalInterface.call("window.foomo.browserUtil.init", uid);
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
				instance: null,

				init: function(id)
				{
					this.instance = this.findSwf(id);
				},

				getInstance: function()
				{
					return this.instance;
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

				confirmClosure: function(message)
				{
					$(window).bind('beforeunload', function() {
						return message;
					});
				}
			}

			window.foomo = {} || window.foomo;
			window.foomo.browserUtil = new Foomo.BrowserUtil;
		}
		]]></script>
	;
}