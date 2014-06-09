package com.tg.avatar.war.data
{
	import flash.display.BitmapData;
	import flash.geom.Point;

    public class MovieDataFormat
    {
		/** 总帧数 */
		public var frameCount:int;
		/** 帧序列 */
		public var frames:Vector.<BitmapData>;
		
		/** 帧宽 */
        public var smallWidth:Number;
		/** 帧高 */
        public var smallHeight:Number;
		/** 资源总宽 */
        public var bigWidth:int;
		/** 资源总高 */
        public var bigHeight:int;
		
		/** 资源截时，偏移量 */
        public var offset:Point;
		public var regPoint:Point;
		
		/** 水平翻转 */
        public var isFilpH:Boolean = false;
		/** 垂直翻转 */
        public var isFilpV:Boolean = false;
		
        public function MovieDataFormat()
        {
            this.regPoint = new Point(0, 0);
        }
    }
}
