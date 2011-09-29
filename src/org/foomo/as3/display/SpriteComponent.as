package org.foomo.as3.display
{
	import flash.display.Sprite;

	import org.foomo.foomo_internal;
	import org.foomo.utils.CallLaterUtil;

	use namespace foomo_internal;

	public class SpriteComponent extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// ~ Variables
		//-----------------------------------------------------------------------------------------

		foomo_internal var _invalidDisplayList:Boolean = false

		//-----------------------------------------------------------------------------------------
		// ~ Constructor
		//-----------------------------------------------------------------------------------------

		public function SpriteComponent()
		{
			super();
		}

		//-----------------------------------------------------------------------------------------
		// ~ Public methods
		//-----------------------------------------------------------------------------------------

		public function invalidateDisplayList():void
		{
			this._invalidDisplayList = true;
			CallLaterUtil.addCallback(this.validateProperties);
		}

		//-----------------------------------------------------------------------------------------
		// ~ Protected methods
		//-----------------------------------------------------------------------------------------

		protected function updateDisplayList():void
		{
		}

		//-----------------------------------------------------------------------------------------
		// ~ Internal methods
		//-----------------------------------------------------------------------------------------

		foomo_internal function validateProperties():void
		{
			if (this._invalidDisplayList) {
				this.updateDisplayList();
				this._invalidDisplayList = false;
			}
		}
	}
}