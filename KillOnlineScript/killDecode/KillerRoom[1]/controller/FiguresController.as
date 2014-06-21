package controller
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import uas.*;

    public class FiguresController extends Object
    {
        private var headSprite:Object;
        private var clothSprite:Object;
        private var kuSprite:Object;
        private var petSprite:Object;
        private var hatSprite:Object;
        private var faceSprite:Object;
        private var wingSprite:Object;
        private var haloSprite:Object;
        public var timer:Timer;
        private var isTimer:Boolean = false;
        private var head_mc_Y:Number = 0;
        public var theViewer:MovieClip;

        public function FiguresController(param1:MovieClip)
        {
            this.theViewer = param1;
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.init);
            this.timer = new Timer(1500, 1);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.timerHandler);
            return;
        }// end function

        public function init(event:Event = null) : void
        {
            this.head_mc_Y = this.theViewer.head_mc.y;
            this.theViewer.stop();
            if (this.theViewer.wing_mc == null)
            {
                this.theViewer.wing_mc = this.theViewer.addChild(new MovieClip());
            }
            this.theViewer.head_mc.y = this.head_mc_Y;
            this.theViewer.head_mc.visible = true;
            this.theViewer.cloth_mc.visible = true;
            this.theViewer.ku_mc.visible = true;
            this.theViewer.hat_mc.visible = true;
            this.theViewer.face_mc.visible = true;
            this.theViewer.wing_mc.visible = true;
            this.theViewer.halo_mc.visible = true;
            if (!this.isTimer)
            {
                this.theViewer.gotoAndStop("default");
                if (this.headSprite)
                {
                    this.headSprite.gotoAndStop("default");
                }
                if (this.clothSprite)
                {
                    this.clothSprite.gotoAndStop("default");
                }
                if (this.kuSprite)
                {
                    this.kuSprite.gotoAndStop("default");
                }
                if (this.hatSprite)
                {
                    this.hatSprite.gotoAndStop("default");
                }
                if (this.faceSprite)
                {
                    this.faceSprite.gotoAndStop("default");
                }
                if (this.wingSprite)
                {
                    this.wingSprite.gotoAndStop("default");
                }
                if (this.haloSprite)
                {
                    this.haloSprite.gotoAndStop("default");
                }
            }
            return;
        }// end function

        public function set hat(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.hat_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadHat);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.hat_mc);
                this.hatSprite = null;
            }
            return;
        }// end function

        private function loadHat(event:Event) : void
        {
            this.hatSprite = this.theViewer.hat_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.hatSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        public function set face(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.face_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadFace);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.face_mc);
                this.faceSprite = null;
            }
            return;
        }// end function

        private function loadFace(event:Event) : void
        {
            this.faceSprite = this.theViewer.face_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.faceSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        public function set wing(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.wing_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadWing);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.wing_mc);
                this.wingSprite = null;
            }
            return;
        }// end function

        private function loadWing(event:Event) : void
        {
            this.wingSprite = this.theViewer.wing_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.wingSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        public function set halo(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.halo_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadHalo);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.halo_mc);
                this.haloSprite = null;
            }
            return;
        }// end function

        private function loadHalo(event:Event) : void
        {
            this.haloSprite = this.theViewer.halo_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.haloSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        private function loadHead(event:Event) : void
        {
            this.headSprite = this.theViewer.head_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.headSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        private function loadCloth(event:Event) : void
        {
            this.clothSprite = this.theViewer.cloth_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.clothSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        private function loadKu(event:Event) : void
        {
            this.kuSprite = this.theViewer.ku_mc.addChild(event.target.content);
            if (this.theViewer.currentLabel == "death")
            {
                this.kuSprite.gotoAndStop(this.theViewer.currentLabel);
            }
            return;
        }// end function

        public function set head(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.head_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadHead);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.head_mc);
                this.headSprite = null;
            }
            return;
        }// end function

        public function set cloth(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.cloth_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadCloth);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.cloth_mc);
                this.clothSprite = null;
            }
            return;
        }// end function

        public function set ku(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.ku_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadKu);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.ku_mc);
                this.kuSprite = null;
            }
            return;
        }// end function

        public function isView() : void
        {
            this.theViewer.wing_mc.visible = false;
            this.theViewer.head_mc.visible = false;
            this.theViewer.cloth_mc.visible = false;
            this.theViewer.ku_mc.visible = false;
            this.theViewer.hat_mc.visible = false;
            this.theViewer.face_mc.visible = false;
            this.theViewer.wing_mc.visible = false;
            this.theViewer.halo_mc.visible = false;
            this.theViewer.gotoAndStop("isview");
            this.timer.stop();
            return;
        }// end function

        public function isOffline() : void
        {
            this.theViewer.wing_mc.visible = false;
            this.theViewer.head_mc.visible = false;
            this.theViewer.cloth_mc.visible = false;
            this.theViewer.ku_mc.visible = false;
            this.theViewer.hat_mc.visible = false;
            this.theViewer.face_mc.visible = false;
            this.theViewer.wing_mc.visible = false;
            this.theViewer.halo_mc.visible = false;
            this.theViewer.gotoAndStop("offline");
            this.timer.stop();
            return;
        }// end function

        public function setFace(param1:String) : void
        {
            this.theViewer.head_mc.y = this.head_mc_Y;
            if (param1 != "kill1" && param1 != "kill2" && param1 != "kill3" && param1 != "kill7" && param1 != "kill10" && param1 != "offline" && param1 != "isview")
            {
                if (param1 != "death")
                {
                    this.timer.start();
                    this.isTimer = true;
                }
                else
                {
                    this.timer.stop();
                }
                this.theViewer.gotoAndStop(param1);
                if (this.headSprite)
                {
                    this.headSprite.gotoAndStop(param1);
                }
                if (this.clothSprite)
                {
                    this.clothSprite.gotoAndStop(param1);
                }
                if (this.kuSprite)
                {
                    this.kuSprite.gotoAndStop(param1);
                }
                if (this.hatSprite)
                {
                    this.hatSprite.gotoAndStop(param1);
                }
                if (this.faceSprite)
                {
                    this.faceSprite.gotoAndStop(param1);
                }
                if (this.wingSprite)
                {
                    this.wingSprite.gotoAndStop(param1);
                }
                if (this.haloSprite)
                {
                    this.haloSprite.gotoAndStop(param1);
                }
            }
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            this.isTimer = false;
            this.theViewer.gotoAndStop("default");
            this.theViewer.head_mc.y = this.head_mc_Y;
            if (this.headSprite)
            {
                this.headSprite.gotoAndStop("default");
            }
            if (this.clothSprite)
            {
                this.clothSprite.gotoAndStop("default");
            }
            if (this.kuSprite)
            {
                this.kuSprite.gotoAndStop("default");
            }
            if (this.hatSprite)
            {
                this.hatSprite.gotoAndStop("default");
            }
            if (this.faceSprite)
            {
                this.faceSprite.gotoAndStop("default");
            }
            if (this.wingSprite)
            {
                this.wingSprite.gotoAndStop("default");
            }
            if (this.haloSprite)
            {
                this.haloSprite.gotoAndStop("default");
            }
            return;
        }// end function

        public function clear() : void
        {
            mcFunc.removeAllMc(this.theViewer.head_mc);
            mcFunc.removeAllMc(this.theViewer.cloth_mc);
            mcFunc.removeAllMc(this.theViewer.ku_mc);
            mcFunc.removeAllMc(this.theViewer.hat_mc);
            mcFunc.removeAllMc(this.theViewer.face_mc);
            mcFunc.removeAllMc(this.theViewer.wing_mc);
            mcFunc.removeAllMc(this.theViewer.halo_mc);
            this.headSprite = null;
            this.clothSprite = null;
            this.kuSprite = null;
            this.hatSprite = null;
            this.faceSprite = null;
            this.wingSprite = null;
            this.haloSprite = null;
            return;
        }// end function

        public function set figure(param1:String) : void
        {
            return;
        }// end function

    }
}
