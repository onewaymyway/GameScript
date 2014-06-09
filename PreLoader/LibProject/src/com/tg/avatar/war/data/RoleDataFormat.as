package com.tg.avatar.war.data
{

	public class RoleDataFormat extends MovieDataFormat
	{
		/** 帧间隔时间（毫秒）, 如未设置则启用frameRate */
		public var frameInterval:int;
		/** 帧率, frameInterval为0时启用 */
		public var frameRate:Number;
		
		/** 击中目标对象帧号，由1开始*/
		public var targetActionFrame:int = 0;
	}
}