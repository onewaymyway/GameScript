package uas
{

    public class UStr extends Object
    {

        public function UStr()
        {
            return;
        }// end function

        public static function getObjByString(STR:String) : Object
        {
            var _loc_2:Array = null;
            var _loc_3:Object = null;
            STR = STR.split("&lt;").join("<");
            STR = STR.split("&gt;").join(">");
            STR = STR.split("¡¯").join("\'");
            if (STR.indexOf("&") > -1)
            {
                _loc_2 = STR.split("&");
                _loc_3 = new Object();
            }
            else
            {
                _loc_2 = new Array(STR);
                _loc_3 = new Object();
            }
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3[String(_loc_2[_loc_4]).substring(0, String(_loc_2[_loc_4]).indexOf("="))] = String(_loc_2[_loc_4]).substring((String(_loc_2[_loc_4]).indexOf("=") + 1)).split("£¦").join("&");
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        public static function StringByHTMLString(STR:String) : String
        {
            STR = STR.split("<").join("&lt;");
            STR = STR.split(">").join("&gt;");
            return STR;
        }// end function

    }
}
