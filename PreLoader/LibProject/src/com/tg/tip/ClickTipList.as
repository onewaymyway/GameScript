package com.tg.tip
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

    public class ClickTipList extends Sprite
    {
		public var onTextClick:Function;
		public var onRemoveStage:Function;
		
		private var maxW:int=0;
		private var datas:Array;
		private var tfList:Array;
		
        public function ClickTipList(tipLabels:Array, tipKeys:Array = null, labelClickCallback:Function=null)
        {
			this.datas = tipKeys || tipLabels;
            this.tfList = new Array();
			
            this.onTextClick = labelClickCallback;
            
			this.maxW = 30;
            var index:int = 0;
            for each (var label:String in tipLabels) 
            {
				var labelText:TextField = new TextField();
				labelText.selectable = false;
				
				// 保存索引值，点击后利用索引值进行数据查找
				labelText.name = index.toString();
                labelText.htmlText = "<P ALIGN=\"center\"><font color=\"#fffffff\">" 
								   + label 
								   + "</font></P>";
				
				labelText.width = 100;
				labelText.height = 18;
				labelText.x = 0;
                labelText.y = index * 19;
				
                labelText.addEventListener(MouseEvent.CLICK, this.textClick);
                labelText.addEventListener(MouseEvent.MOUSE_OVER, this.onTextMouseOver);
				
                this.addChild(labelText);
				
                if (this.maxW < labelText.textWidth + 3) 
                    this.maxW = labelText.textWidth + 3;
				
                this.tfList.push(labelText);
                index++;
            }
			
            for each (var text:TextField in tfList) 
            {
				text.width = this.maxW;
            }
			
            this.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.removeStageHandler);
        }

		private function removeStageHandler(ev:Event):void
        {
			if(onRemoveStage != null)
			{
				onRemoveStage();
			}
        }

		private function textClick(ev:Event):void
        {
			if(onTextClick != null)
			{
				var index:int = int(ev.currentTarget.name);
				onTextClick(this.datas[index]);
			}
        }

		private function onTextMouseOver(ev:Event):void
        {
            this.graphics.clear();
            this.graphics.beginFill(0x5D482C, 1);
            this.graphics.drawRect(0, ev.currentTarget.y + 1, this.maxW, 18);
        }

        private function onTextMouseOut(ev:Event):void
        {
            this.graphics.clear();
        }
    }
}
