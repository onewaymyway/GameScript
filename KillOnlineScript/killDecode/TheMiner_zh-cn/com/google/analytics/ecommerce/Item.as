package com.google.analytics.ecommerce
{
    import com.google.analytics.utils.*;

    public class Item extends Object
    {
        private var _id:String;
        private var _sku:String;
        private var _name:String;
        private var _category:String;
        private var _price:String;
        private var _quantity:String;

        public function Item(id:String, sku:String, name:String, category:String, price:String, quantity:String)
        {
            this._id = id;
            this._sku = sku;
            this._name = name;
            this._category = category;
            this._price = price;
            this._quantity = quantity;
            return;
        }// end function

        public function toGifParams() : Variables
        {
            var _loc_1:* = new Variables();
            _loc_1.URIencode = true;
            _loc_1.post = ["utmt", "utmtid", "utmipc", "utmipn", "utmiva", "utmipr", "utmiqt"];
            _loc_1.utmt = "item";
            _loc_1.utmtid = this._id;
            _loc_1.utmipc = this._sku;
            _loc_1.utmipn = this._name;
            _loc_1.utmiva = this._category;
            _loc_1.utmipr = this._price;
            _loc_1.utmiqt = this._quantity;
            return _loc_1;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get sku() : String
        {
            return this._sku;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function get category() : String
        {
            return this._category;
        }// end function

        public function get price() : String
        {
            return this._price;
        }// end function

        public function get quantity() : String
        {
            return this._quantity;
        }// end function

        public function set id(value:String) : void
        {
            this._id = value;
            return;
        }// end function

        public function set sku(value:String) : void
        {
            this._sku = value;
            return;
        }// end function

        public function set name(value:String) : void
        {
            this._name = value;
            return;
        }// end function

        public function set category(value:String) : void
        {
            this._category = value;
            return;
        }// end function

        public function set price(value:String) : void
        {
            this._price = value;
            return;
        }// end function

        public function set quantity(value:String) : void
        {
            this._quantity = value;
            return;
        }// end function

    }
}
