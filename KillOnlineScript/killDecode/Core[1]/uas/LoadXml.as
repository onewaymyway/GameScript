package uas
{
    import flash.events.*;
    import flash.net.*;

    public class LoadXml extends EventDispatcher
    {
        private var _XML:XML;
        private var myLoader:URLLoader;
        private var myXMLURL:URLRequest;

        public function LoadXml() : void
        {
            this._XML = new XML();
            return;
        }// end function

        private function init() : void
        {
            return;
        }// end function

        public function load(param1:String) : void
        {
            this.myXMLURL = new URLRequest(param1);
            this.myLoader = new URLLoader(this.myXMLURL);
            this.myLoader.addEventListener("complete", this.xmlLoaded);
            this.myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.xmlLoadedErr);
            this.myLoader.addEventListener(IOErrorEvent.IO_ERROR, this.xmlLoadedErr);
            return;
        }// end function

        private function xmlLoaded(event:Event) : void
        {
            this._XML = XML(this.myLoader.data.toString());
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        private function xmlLoadedErr(event:Event) : void
        {
            this._XML = XML(<data>err</data>")("<data>err</data>);
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        public function get data() : XML
        {
            return this._XML;
        }// end function

    }
}
