package com.tg.Tools 
{
	import com.game.loader.TGLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class LoadMusic
	{
		
		/*** 是否处于静音状态 */
		public static var isJing:Boolean = false;
		
		private var Play:Sound = new Sound();
		
		private var channel:SoundChannel = new SoundChannel(); 
		private var cishu:int = 0;                             
		private var bofang:Boolean = false;                    
		
		private var MusicControl:SoundTransform; 
		public var Vomule:Number= 1;           
		
		private static var me:LoadMusic;
		
		public function LoadMusic()
		{
			
		}
		public static function Play(id:String):void
		{
			if(isJing) return;
			me = new LoadMusic();
			me.loadA(TGLoader.getUrl("music/effect/"+id+".mp3"),1,true);
				 
		}
		/**
		 * 参数
		 * @param ID  路径
		 * @param Num 播放次数
		 * @param bool 加载完毕是否立即播放
		 * @param _vomule 声音大小1-100 
		 * @return 
		 * 
		 */		
		public function loadA(ID:String,Num:int = 1,bool:Boolean = false,_vomule:Number = 100):void
		{
			bofang = bool;     
			Vomule = _vomule/100;
			cishu = Num;       
			try{
				Play.load(new URLRequest(ID));
				Play.addEventListener(IOErrorEvent.IO_ERROR,TGLoader.onIoError);
				Play.addEventListener(Event.COMPLETE,OK);
			}catch(e:Error){
				
			}
		}
		public function OK(e:Event):void
		{
			Play.removeEventListener(Event.COMPLETE,OK);
			//
			if(bofang)
			{
				 playA(Vomule,cishu); 
			}
		}
		/**
		 * 
		 *
		 * @param num2 播放次数
		 *  @param num 是音效的音量
		 * @return 
		 * 
		 */		
		public function playA(num2:int = 1,num:Number = 1) :void
		{
			channel = new SoundChannel()
			
			var pausePosition:int = channel.position
			MusicControl = new SoundTransform(num);
			try{
				channel = Play.play(pausePosition,num2,MusicControl);
				if(!channel)
					return;
				channel.addEventListener(Event.SOUND_COMPLETE,over);
			}catch(e:Error){
				
			}
			
		}
		private function over(e:Event):void
		{
			me = null;
		}
		/**
		 * 停止播放音乐 
		 * @return 
		 * 
		 */		
		public function stop()  :void
		{
			try{
				channel.stop();
			}catch(e:Error){
				
			}
		}
		public function setVom(_num:Number):void
		{
			if(MusicControl)
			{
				MusicControl.volume = _num;
				channel.soundTransform = MusicControl;
			}
		}
	}
	
}
