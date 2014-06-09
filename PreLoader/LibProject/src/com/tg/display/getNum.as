package  com.tg.display
{
	
	import com.tg.display.PublicSkin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/** 获取一串数字 美术字体
	 * @author hdz
	 *
	 * @date 2014-1-10
	 **/
	
	public class getNum
	{
		public function getNum()
		{
		}
		
		/**
		 * 获取一串数字 美术字体 
		 * @param type 数字类型
		 * @param num 要获取的数字
		 * @return  返回sprite数字
		 * 
		 */		
		public static function getNumMc(type:int,num:int):Sprite
		{
			var sp:Sprite = new Sprite();
			var str:String = num.toString();
			for(var i:int = 0; i < str.length;i++)
			{
				var mc:MovieClip = PublicSkin.instance.getSkin(type + "_" + str.charAt(i));//GetRewardRes.instance.getSkin(str.charAt(i));
				mc.x = sp.width;
				sp.addChild(mc);
			}
			return sp;
		}
		/**
		 *  获取一个字符图片  上升100像素自动渐变消失
		 * @param type 1 是暴击
		 * @param num 数字
		 * 
		 */		
		public static  function getNumMc2(type:int,num:int):DongHua
		{
			var sp:Sprite = new Sprite();
			
			var str:String = Math.abs(num).toString();
			var mc:MovieClip;
			
			switch(type)
			{
				case 1: // 暴击
					mc = PublicSkin.instance.getSkin("type_7");
					mc.x = sp.width;
					sp.addChild(mc);
	 				break;
				case 2:
					break;
				
			}
			if(num > 0 )
			{
				//加
				mc = PublicSkin.instance.getSkin("+");
				mc.x = sp.width;
				sp.addChild(mc);
			}
			else
			{
				//减
				mc = PublicSkin.instance.getSkin("-");
				mc.x = sp.width;
				sp.addChild(mc);
			}
			for(var i:int = 0; i < str.length;i++)
			{
				mc = PublicSkin.instance.getSkin(1 + "_" + str.charAt(i));//GetRewardRes.instance.getSkin(str.charAt(i));
				mc.x = sp.width;
				sp.addChild(mc);
			}
			var dh:DongHua = new DongHua();
			dh.addChild(sp);
			return dh;
//			return sp;
		}
		
	}
	
}