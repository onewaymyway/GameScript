package com.tg.Tools.display.interfaces
{
	/**
	 * @author luli&ww
	 */
	public interface IDisabled
	{
		/**
		 * 获取当前是禁用状态
		 */
		function get disabled():Boolean;
		/**
		 * 设置禁用状态
		 * @param value true为禁用，false为未禁用
		 */
		function set disabled(value:Boolean):void;
	}
}
