package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import killonline.*;

    public class killonline extends Sprite
    {
        private var loading_mc:loadingMc;

        public function killonline()
        {
            this.loading_mc = new loadingMc();
            addChild(this.loading_mc);
            this.loading_mc.visible = false;
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function init(event:Event) : void
        {
            if (stage.loaderInfo.parameters["swf"])
            {
                this.loadSwf(stage.loaderInfo.parameters["swf"] + "Core.swf?v=" + stage.loaderInfo.parameters["v"] + "." + uint(stage.loaderInfo.parameters["Core"]));
            }
            else
            {
                this.loadSwf("swf/Core.swf?v=" + stage.loaderInfo.parameters["v"] + "." + uint(stage.loaderInfo.parameters["Core"]));
            }
            return;
        }// end function

        private function loadSwf(url:String) : void
        {
            var _loc_2:* = new Loader();
            _loc_2.load(new URLRequest(url));
            this.configureListeners(_loc_2.contentLoaderInfo);
            return;
        }// end function

        private function configureListeners(dispacther:IEventDispatcher) : void
        {
            dispacther.addEventListener(Event.COMPLETE, this.loadedHandler);
            dispacther.addEventListener(ProgressEvent.PROGRESS, this.loadingHandler);
            dispacther.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }// end function

        private function loadingHandler(event:ProgressEvent) : void
        {
            this.loading_mc.visible = true;
            this.loading_mc._bg.width = this.stage.stageWidth;
            this.loading_mc._bg.height = this.stage.stageHeight;
            this.loading_mc._mc._txt.text = "初始化中...";
            this.loading_mc._mc._p.text = "";
            this.loading_mc._mc.loading_bar._bar.scaleX = event.bytesLoaded / event.bytesTotal;
            this.loading_mc._mc.x = this.stage.stageWidth / 2;
            this.loading_mc._mc.y = this.stage.stageHeight / 2;
            return;
        }// end function

        private function loadedHandler(event:Event) : void
        {
            addChild(event.target.content);
            this.removeChild(this.loading_mc);
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            this.loading_mc.visible = true;
            this.loading_mc._bg.width = this.stage.stageWidth;
            this.loading_mc._bg.height = this.stage.stageHeight;
            this.loading_mc._mc._p.text = "";
            this.loading_mc._mc.loading_bar._bar.scaleX = 0;
            this.loading_mc._mc.x = this.stage.stageWidth / 2;
            this.loading_mc._mc.y = this.stage.stageHeight / 2;
            this.loading_mc._mc._txt.text = "初始化失败！";
            return;
        }// end function

    }
}
