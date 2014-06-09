package com.tg.avatar.war.load
{

	public final class PlayerAnimationData
	{
		public var sign:String;
		
		public var hasStuntState:Boolean = false;
		public var hasDieState:Boolean = false;
		public var hasWinState:Boolean=false;
		
		public var shadowX:int;
		public var shadowY:int;
		
		public var nameX:int;
		public var nameY:int;
		
		public var troughX:int;
		public var troughY:int;
		
		public var standby:AnimationData;
		public var attack:AnimationData;
		public var attacked:AnimationData;
		public var stunt:AnimationData;
		public var die:AnimationData;
		public var win:AnimationData;
		
		public function PlayerAnimationData()
		{
		}
		
		public function dispose():void
		{
			standby.dispose();
			attack.dispose();
			attacked.dispose();
			if (stunt)
				stunt.dispose();
			if (die)
				die.dispose();
			standby = null;
			attack = null;
			attacked = null;
			stunt = null;
			die = null;
		}
	}
}