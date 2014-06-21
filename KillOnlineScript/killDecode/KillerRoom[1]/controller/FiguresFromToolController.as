package controller
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import uas.*;

    public class FiguresFromToolController extends FiguresController
    {
        private var figureSprite:Object;
        private var isTimer:Boolean = false;

        public function FiguresFromToolController(param1:MovieClip)
        {
            super(param1);
            theViewer = param1;
            theViewer.addEventListener(Event.ADDED_TO_STAGE, this.init);
            timer = new Timer(1500, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.timerHandler);
            return;
        }// end function

        override public function init(event:Event = null) : void
        {
            theViewer.stop();
            theViewer.figure_mc.visible = true;
            if (!this.isTimer)
            {
                theViewer.gotoAndStop("default");
                if (this.figureSprite)
                {
                    this.figureSprite.gotoAndStop("default");
                }
            }
            return;
        }// end function

        override public function set figure(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(theViewer.figure_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadfigure);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(theViewer.figure_mc);
                this.figureSprite = null;
            }
            return;
        }// end function

        private function loadfigure(event:Event) : void
        {
            this.figureSprite = theViewer.figure_mc.addChild(event.target.content);
            if (theViewer.currentLabel == "death")
            {
                this.figureSprite.gotoAndStop(theViewer.currentLabel);
            }
            else if (this.figureSprite.init)
            {
                this.figureSprite.init();
            }
            return;
        }// end function

        override public function set hat(param1:String) : void
        {
            return;
        }// end function

        override public function set face(param1:String) : void
        {
            return;
        }// end function

        override public function set wing(param1:String) : void
        {
            return;
        }// end function

        override public function set halo(param1:String) : void
        {
            return;
        }// end function

        override public function set head(param1:String) : void
        {
            return;
        }// end function

        override public function set cloth(param1:String) : void
        {
            return;
        }// end function

        override public function set ku(param1:String) : void
        {
            return;
        }// end function

        override public function isView() : void
        {
            theViewer.figure_mc.visible = false;
            theViewer.gotoAndStop("isview");
            timer.stop();
            return;
        }// end function

        override public function isOffline() : void
        {
            theViewer.figure_mc.visible = false;
            theViewer.gotoAndStop("offline");
            timer.stop();
            return;
        }// end function

        override public function setFace(param1:String) : void
        {
            if (param1 != "kill1" && param1 != "kill2" && param1 != "kill3" && param1 != "kill7" && param1 != "kill10" && param1 != "offline" && param1 != "isview")
            {
                if (param1 != "death")
                {
                    timer.start();
                    this.isTimer = true;
                }
                else
                {
                    timer.stop();
                }
                theViewer.gotoAndStop(param1);
                if (this.figureSprite)
                {
                    this.figureSprite.gotoAndStop(param1);
                }
            }
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            this.isTimer = false;
            theViewer.gotoAndStop("default");
            if (this.figureSprite)
            {
                this.figureSprite.gotoAndStop("default");
            }
            return;
        }// end function

        override public function clear() : void
        {
            mcFunc.removeAllMc(theViewer.figure_mc);
            this.figureSprite = null;
            return;
        }// end function

    }
}
