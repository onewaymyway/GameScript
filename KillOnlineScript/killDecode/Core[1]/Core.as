package 
{
    import Core.*;
    import Core.model.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.ui.*;
    import uas.*;

    public class Core extends Sprite
    {
        private var myFacade:MyFacade;
        private var netproxy:NetProxy;
        public var frameOBJ0:Object;
        public var frameOBJ1:Object;
        public var frameOBJ2:Object;
        public var frameOBJ3:Object;
        public var frameOBJ4:Object;
        public var frameOBJ5:Object;
        public var frameOBJ6:Object;
        public static var MAIN:Core;

        public function Core()
        {
            new mcFunc();
            new UStr();
            new LoadURL();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function CoreLoaded(event:Event) : void
        {
            this.myFacade = MyFacade.getInstance();
            this.myFacade.LoadBaseView(this);
            return;
        }// end function

        public function load0() : void
        {
            var _loc_1:* = new URLoader();
            _loc_1.addEventListener(Event.COMPLETE, this.CoreLoaded);
            _loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.onERR0Handler);
            _loc_1.load(new URLRequest("/swf/LinesBox.swf"));
            return;
        }// end function

        private function onLoaded0Handler(event:Event) : void
        {
            this.init(null);
            return;
        }// end function

        private function onERR0Handler(event:Event) : void
        {
            return;
        }// end function

        private function init(event:Event) : void
        {
            if (stage.loaderInfo.parameters["swf"])
            {
                Resource.ChangeHTTP(stage.loaderInfo.parameters["swf"]);
            }
            else
            {
                Resource.ChangeHTTP("/swf/");
            }
            MainData.LoginInfo.uservalues = stage.loaderInfo.parameters["uservalues"];
            MainData.LoginInfo.userip = stage.loaderInfo.parameters["userip"];
            if (stage.loaderInfo.parameters["v"])
            {
                Resource.V = stage.loaderInfo.parameters["v"];
                Resource.ChildV = stage.loaderInfo.parameters;
            }
            this.tabChildren = false;
            var _loc_2:* = new ContextMenu();
            _loc_2.hideBuiltInItems();
            this.contextMenu = _loc_2;
            MAIN = this;
            this.frameOBJ6 = this.addChild(new Sprite());
            this.frameOBJ5 = this.addChild(new Sprite());
            this.frameOBJ4 = this.addChild(new Sprite());
            this.frameOBJ3 = this.addChild(new Sprite());
            this.frameOBJ3.mouseChildren = false;
            this.frameOBJ3.mouseEnabled = false;
            this.frameOBJ2 = this.addChild(new Sprite());
            this.frameOBJ1 = this.addChild(new Sprite());
            this.load0();
            return;
        }// end function

        public function action(param1:Object, ... args) : void
        {
            if (this.netproxy == null)
            {
                this.netproxy = this.myFacade.retrieveProxy(NetProxy.NAME) as NetProxy;
            }
            this.netproxy.SendCmd(param1);
            return;
        }// end function

    }
}
