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
	import org.foomo.as3.ui.Grawl;
	import org.foomo.logging.ILoggingTarget;
	import org.foomo.logging.LogLevel;

	/**
	 * Sends log messages to the toolbar
	 *
	 * @link    http://www.foomo.org
	 * @license http://www.gnu.org/licenses/lgpl.txt
	 * @author  franklin <franklin@weareinteractive.com>
	 */
	public class GrawlTarget implements ILoggingTarget
	{
		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		public var logLevel:int;

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function GrawlTarget(logLevel:int=-1)
		{
			this.logLevel = logLevel;
		}

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public function format(category:String, message:String, level:int):String
		{
			return message;
		}

		public function output(message:String, level:int):void
		{
			if (this.logLevel == -1 || this.logLevel > level) return;
			Grawl.notify(LogLevel.getLevelString(level), message);
		}
	}
}