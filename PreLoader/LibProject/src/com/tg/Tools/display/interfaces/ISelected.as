package com.tg.Tools.display.interfaces
{
	/**
	 * @author luli&ww
	 */
	public interface ISelected
	{
		/**
		 * 获取当前选中状态
		 */
		function get selected():Boolean;
		/**
		 * 设置选中状态
		 * @param value true为选中，false为未选中
		 */
		function set selected(value:Boolean):void;
	}
}
