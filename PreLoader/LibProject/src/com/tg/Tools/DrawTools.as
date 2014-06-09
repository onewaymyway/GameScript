package com.tg.Tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	public class DrawTools
	{
		public function DrawTools()
		{
		}
		public static function drawRec(target:Sprite,rec:Rectangle,color:Number=0x000000,alpha:Number=1):void
		{
			target.graphics.beginFill(color,alpha);
			target.graphics.drawRect(rec.x,rec.y,rec.width,rec.height);
			trace(rec)
			target.graphics.endFill();
		}
		
		public static function getRandomColor():Number
		{
			var co:ColorTransform;
			co=new ColorTransform;
			co.blueOffset=20+255*Math.random();
			co.redOffset=20+255*Math.random();
			co.greenOffset=20+255*Math.random();
			return co.color;
		}
		
		public static function drawCircle(target:Sprite,x:int,y:int,r:Number,color:Number):void
		{
			target.graphics.beginFill(color);
			target.graphics.drawCircle(x,y,r);
			target.graphics.endFill();
		}
	}
}