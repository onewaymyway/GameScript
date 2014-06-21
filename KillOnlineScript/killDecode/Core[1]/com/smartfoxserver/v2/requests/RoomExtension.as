package com.smartfoxserver.v2.requests
{

    public class RoomExtension extends Object
    {
        private var _id:String;
        private var _className:String;
        private var _propertiesFile:String;

        public function RoomExtension(param1:String, param2:String)
        {
            this._id = param1;
            this._className = param2;
            this._propertiesFile = "";
            return;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get className() : String
        {
            return this._className;
        }// end function

        public function get propertiesFile() : String
        {
            return this._propertiesFile;
        }// end function

        public function set propertiesFile(param1:String) : void
        {
            this._propertiesFile = param1;
            return;
        }// end function

    }
}
