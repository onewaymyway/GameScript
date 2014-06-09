package com.tg.Tools.display.interfaces
{
	/**
	 * 显示长度限制的对象，例如LimitLabel和LabelButton
	 * @author luli&ww
	 */
	public interface ILimitItem
	{
		/**
		 * 判断当前是否超出长度限制
		 */
		function get isExceed():Boolean;
		/**
		 * 获取完整显示对象，目前都是字符串
		 */
		function get originLabel():String;
	}
}
