package com.google.analytics.core
{
    import com.google.analytics.data.*;
    import com.google.analytics.utils.*;

    public class EventInfo extends Object
    {
        private var _isEventHit:Boolean;
        private var _x10:X10;
        private var _ext10:X10;

        public function EventInfo(isEventHit:Boolean, xObject:X10, extObject:X10 = null)
        {
            this._isEventHit = isEventHit;
            this._x10 = xObject;
            this._ext10 = extObject;
            return;
        }// end function

        public function get utmt() : String
        {
            return "event";
        }// end function

        public function get utme() : String
        {
            return this._x10.renderMergedUrlString(this._ext10);
        }// end function

        public function toVariables() : Variables
        {
            var _loc_1:* = new Variables();
            _loc_1.URIencode = true;
            if (this._isEventHit)
            {
                _loc_1.utmt = this.utmt;
            }
            _loc_1.utme = this.utme;
            return _loc_1;
        }// end function

        public function toURLString() : String
        {
            var _loc_1:* = this.toVariables();
            return _loc_1.toString();
        }// end function

    }
}
