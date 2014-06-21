package uas
{

    public class UStr extends Object
    {

        public function UStr()
        {
            return;
        }// end function

        public static function getObjByString(param1:String) : Object
        {
            var _loc_2:Array = null;
            var _loc_3:Object = null;
            param1 = param1.split("&lt;").join("<");
            param1 = param1.split("&gt;").join(">");
            param1 = param1.split("’").join("\'");
            if (param1.indexOf("&") > -1)
            {
                _loc_2 = param1.split("&");
                _loc_3 = new Object();
            }
            else
            {
                _loc_2 = new Array(param1);
                _loc_3 = new Object();
            }
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3[String(_loc_2[_loc_4]).substring(0, String(_loc_2[_loc_4]).indexOf("="))] = String(_loc_2[_loc_4]).substring((String(_loc_2[_loc_4]).indexOf("=") + 1)).split("＆").join("&");
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        public static function StringByHTMLString(param1:String) : String
        {
            param1 = param1.split("<").join("&lt;");
            param1 = param1.split(">").join("&gt;");
            return param1;
        }// end function

    }
}
