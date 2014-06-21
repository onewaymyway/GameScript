package com.google.analytics.core
{

    public class OrganicReferrer extends Object
    {
        private var _engine:String;
        private var _keyword:String;

        public function OrganicReferrer(engine:String, keyword:String)
        {
            this.engine = engine;
            this.keyword = keyword;
            return;
        }// end function

        public function get engine() : String
        {
            return this._engine;
        }// end function

        public function set engine(value:String) : void
        {
            this._engine = value.toLowerCase();
            return;
        }// end function

        public function get keyword() : String
        {
            return this._keyword;
        }// end function

        public function set keyword(value:String) : void
        {
            this._keyword = value.toLowerCase();
            return;
        }// end function

        public function toString() : String
        {
            return this.engine + "?" + this.keyword;
        }// end function

    }
}
