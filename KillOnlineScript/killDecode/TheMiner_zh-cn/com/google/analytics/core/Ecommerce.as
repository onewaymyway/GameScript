package com.google.analytics.core
{
    import com.google.analytics.debug.*;
    import com.google.analytics.ecommerce.*;

    public class Ecommerce extends Object
    {
        private var _debug:DebugConfiguration;
        private var _trans:Array;

        public function Ecommerce(debug:DebugConfiguration)
        {
            this._debug = debug;
            this._trans = new Array();
            return;
        }// end function

        public function addTransaction(id:String, affiliation:String, total:String, tax:String, shipping:String, city:String, state:String, country:String) : Transaction
        {
            var _loc_9:Transaction = null;
            _loc_9 = this.getTransaction(id);
            if (_loc_9 == null)
            {
                _loc_9 = new Transaction(id, affiliation, total, tax, shipping, city, state, country);
                this._trans.push(_loc_9);
            }
            else
            {
                _loc_9.affiliation = affiliation;
                _loc_9.total = total;
                _loc_9.tax = tax;
                _loc_9.shipping = shipping;
                _loc_9.city = city;
                _loc_9.state = state;
                _loc_9.country = country;
            }
            return _loc_9;
        }// end function

        public function getTransaction(orderId:String) : Transaction
        {
            var _loc_2:Number = NaN;
            _loc_2 = 0;
            while (_loc_2 < this._trans.length)
            {
                
                if (this._trans[_loc_2].id == orderId)
                {
                    return this._trans[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        public function getTransFromArray(i:Number) : Transaction
        {
            return this._trans[i];
        }// end function

        public function getTransLength() : Number
        {
            return this._trans.length;
        }// end function

    }
}
