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
package org.foomo.as3.logging
{
	import org.foomo.as3.debug.Toolbar;
	import org.foomo.logging.ILoggingTarget;
	import org.foomo.logging.LogLevel;

	/**
	 * Sends log messages to the toolbar
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 */
	public class ToolbarTarget implements ILoggingTarget
	{
		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		private var _toolbar:Toolbar;

		private var _level:int;

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function ToolbarTarget(toolbar:Toolbar, level:int=-1)
		{
			this._toolbar = toolbar;
			this._level = level;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public function format(category:String, message:String, level:int):String
		{
			return LogLevel.getLevelString(level) + '\n\n' + message;
		}

		public function output(message:String, level:int):void
		{
			if (this._level == -1 || this._level > level) return;
			this._toolbar.growl(message);
		}
	}
}