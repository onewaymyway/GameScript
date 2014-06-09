package com.tg.text
{
	public class NumberUtil
	{
		/**
		 * 阿拉伯数码转换为中国数码
		 * @param digit	from 0 - 10
		 * @return 		零、一、二、三、四、五、六、七、八、九、十
		 */
		public static function arabiaToChinese(digit:int):String
		{
			if(digit == 0)
				return "零";
			else if(digit == 1)
				return "一";
			else if(digit == 2)
				return "二";
			else if(digit == 3)
				return "三";
			else if(digit == 4)
				return "四";
			else if(digit == 5)
				return "五";
			else if(digit == 6)
				return "六";
			else if(digit == 7)
				return "七";
			else if(digit == 8)
				return "八";
			else if(digit == 9)
				return "九";
			else if(digit == 10)
				return "十";
			
			return "";
		}
	}
}