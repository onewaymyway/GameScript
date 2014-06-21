package com.google.analytics.debug
{

    public class AlertAction extends Object
    {
        private var _callback:Object;
        public var activator:String;
        public var container:Alert;
        public var name:String;

        public function AlertAction(name:String, activator:String, callback)
        {
            this.name = name;
            this.activator = activator;
            this._callback = callback;
            return;
        }// end function

        public function execute() : void
        {
            if (this._callback)
            {
                if (this._callback is Function)
                {
                    this.this._callback as Function();
                }
                else if (this._callback is String)
                {
                    var _loc_1:* = this.container;
                    _loc_1.this.container[this._callback]();
                }
            }
            return;
        }// end function

    }
}
