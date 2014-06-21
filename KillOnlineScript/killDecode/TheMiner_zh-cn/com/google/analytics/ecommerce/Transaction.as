package com.google.analytics.ecommerce
{
    import com.google.analytics.utils.*;

    public class Transaction extends Object
    {
        private var _items:Array;
        private var _id:String;
        private var _affiliation:String;
        private var _total:String;
        private var _tax:String;
        private var _shipping:String;
        private var _city:String;
        private var _state:String;
        private var _country:String;
        private var _vars:Variables;

        public function Transaction(id:String, affiliation:String, total:String, tax:String, shipping:String, city:String, state:String, country:String)
        {
            this._id = id;
            this._affiliation = affiliation;
            this._total = total;
            this._tax = tax;
            this._shipping = shipping;
            this._city = city;
            this._state = state;
            this._country = country;
            this._items = new Array();
            return;
        }// end function

        public function toGifParams() : Variables
        {
            var _loc_1:* = new Variables();
            _loc_1.URIencode = true;
            _loc_1.utmt = "tran";
            _loc_1.utmtid = this.id;
            _loc_1.utmtst = this.affiliation;
            _loc_1.utmtto = this.total;
            _loc_1.utmttx = this.tax;
            _loc_1.utmtsp = this.shipping;
            _loc_1.utmtci = this.city;
            _loc_1.utmtrg = this.state;
            _loc_1.utmtco = this.country;
            _loc_1.post = ["utmtid", "utmtst", "utmtto", "utmttx", "utmtsp", "utmtci", "utmtrg", "utmtco"];
            return _loc_1;
        }// end function

        public function addItem(sku:String, name:String, category:String, price:String, quantity:String) : void
        {
            var _loc_6:Item = null;
            _loc_6 = this.getItem(sku);
            if (_loc_6 == null)
            {
                _loc_6 = new Item(this._id, sku, name, category, price, quantity);
                this._items.push(_loc_6);
            }
            else
            {
                _loc_6.name = name;
                _loc_6.category = category;
                _loc_6.price = price;
                _loc_6.quantity = quantity;
            }
            return;
        }// end function

        public function getItem(sku:String) : Item
        {
            var _loc_2:Number = NaN;
            _loc_2 = 0;
            while (_loc_2 < this._items.length)
            {
                
                if (this._items[_loc_2].sku == sku)
                {
                    return this._items[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        public function getItemsLength() : Number
        {
            return this._items.length;
        }// end function

        public function getItemFromArray(i:Number) : Item
        {
            return this._items[i];
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get affiliation() : String
        {
            return this._affiliation;
        }// end function

        public function get total() : String
        {
            return this._total;
        }// end function

        public function get tax() : String
        {
            return this._tax;
        }// end function

        public function get shipping() : String
        {
            return this._shipping;
        }// end function

        public function get city() : String
        {
            return this._city;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        public function get country() : String
        {
            return this._country;
        }// end function

        public function set id(value:String) : void
        {
            this._id = value;
            return;
        }// end function

        public function set affiliation(value:String) : void
        {
            this._affiliation = value;
            return;
        }// end function

        public function set total(value:String) : void
        {
            this._total = value;
            return;
        }// end function

        public function set tax(value:String) : void
        {
            this._tax = value;
            return;
        }// end function

        public function set shipping(value:String) : void
        {
            this._shipping = value;
            return;
        }// end function

        public function set city(value:String) : void
        {
            this._city = value;
            return;
        }// end function

        public function set state(value:String) : void
        {
            this._state = value;
            return;
        }// end function

        public function set country(value:String) : void
        {
            this._country = value;
            return;
        }// end function

    }
}
