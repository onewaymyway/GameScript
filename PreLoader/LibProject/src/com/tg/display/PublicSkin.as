package com.tg.display
{ 	
	import com.tg.messagebox.ButtonType;
	import com.tg.messagebox.MessageBox;
	
	import flash.display.MovieClip;

	/**轻量级公共皮肤获取类
	 * 
	 * @author Hdz
	 * 创建时间：2013-8-7 下午2:39:08
	 * 
	 */
	public class PublicSkin
	{
		private static var _publicskin:PublicSkin;
		
		
		private var mc:PublicSkinBase;
		
		public function PublicSkin()
		{
//			mc = PreloadAsset.findComp("PublicSkin","instance");
			
		}
		public static function init(_mc:PublicSkinBase):void
		{
			instance.mc = _mc;
		}
		public function getSkin(name:String):MovieClip
		{
			var mc2:MovieClip = MovieClip(mc.getSkin(name));
			
			if(!mc2)
			{
				MessageBox.show(ButtonType.OK,"获取-》"+name+"失败，请确认该资源是否存在！");
				return null;
			}
			return mc2;
		}
		public static function get instance():PublicSkin
		{
			if(!_publicskin)
				_publicskin = new PublicSkin();
			return _publicskin;
		}
	}
}