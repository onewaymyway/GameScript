package com.tg.load
{ 	
	import com.game.loader.TGLoader;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	/**
	 * @author Hdz
	 * 创建时间：2013-12-16 上午9:32:44
	 * 
	 */
	public class MyLoader
	{
		private var loadArr:Array;
		
		private var onCom:Function;
	
		
		private var json:String;
		private var btm:Bitmap;
		
		public var data:String = "";
		
		private var tgload:TGLoader;
		
		/**
		 * 加载txt和bitmap 
		 *  
		 * @param arr [json，bitmap]
		 * @param fun 加载成功回调
		 * 
		 */		
		public function MyLoader(arr:Array,fun:Function)
		{
			loadArr = arr;
			onCom = fun;
			
			if(arr.length >=3)
				data = arr[2];
			tgload = new TGLoader();
			
			tgload.add(loadArr[0],{id:"json"});
			tgload.add(loadArr[1],{id:"png"});
			
			tgload.addEventListener(BulkLoader.COMPLETE,complete);
			tgload.addEventListener(BulkLoader.PROGRESS,progress);
			tgload.start();

		}
		private function complete(e:Event):void
		{
			json = tgload.getText("json");
			btm  = tgload.getBitmap("png");
			onCom([json,btm,data]);
			 
			
		}
		private function progress(e : BulkProgressEvent):void
		{
		}
		
		public function clear():void
		{
			tgload.clear();
			tgload = null;
			btm.bitmapData.dispose();
			btm = null;
		}
	}
}