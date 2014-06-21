package com.sociodox.theminer.manager
{
    import com.sociodox.theminer.*;
    import com.sociodox.theminer.window.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.sampler.*;
    import flash.system.*;
    import flash.text.*;

    public class Launcher extends Sprite
    {
        private var mLoader:Loader;
        private var mMiner:TheMiner;
        private var mtext:TextField;

        public function Launcher()
        {
            if (stage)
            {
                this.Init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.Init);
            }
            return;
        }// end function

        private function Init(event:Event = null) : void
        {
            var _loc_2:* = undefined;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;
            removeEventListener(Event.ADDED_TO_STAGE, this.Init);
            Configuration.ANALYTICS_ENABLED = true;
            Configuration.PROFILE_MEMORY = true;
            Configuration.PROFILE_FUNCTION = true;
            Configuration.PROFILE_INTERNAL_EVENTS = true;
            Configuration.PROFILE_LOADERS = true;
            Configuration.PROFILE_MEMGRAPH = true;
            if (this.loaderInfo.parameters["FileToLaunch"] != undefined)
            {
                startSampling();
                this.mLoader = new Loader();
                this.mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.OnFileLoaded);
                addChild(this.mLoader);
                this.mLoader.load(new URLRequest(this.loaderInfo.parameters["FileToLaunch"]), new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
                _loc_2 = getSamples();
                trace(_loc_2);
            }
            else
            {
                trace("unable to find file to launch");
            }
            return;
        }// end function

        private function OnFileLoaded(event:Event) : void
        {
            Analytics.Track("Process", "Launch", "Launch/" + "1.4.01" + "/T");
            var _loc_2:* = event.target.content;
            _loc_2.x = this.stage.stageWidth / 2 - _loc_2.loaderInfo.width / 2;
            _loc_2.y = this.stage.stageHeight / 2 - _loc_2.loaderInfo.height / 2;
            this.mMiner = new TheMiner();
            event.target.content.addChild(this.mMiner);
            return;
        }// end function

    }
}
