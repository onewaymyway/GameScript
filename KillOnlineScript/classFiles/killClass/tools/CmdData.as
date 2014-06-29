package killClass.tools 
{
    import com.tools.JSONTools;
    
    import flash.utils.*;

    public class CmdData extends Object
    {
        public static const keyStr:String = "H789aiYo";
        public static var key:ByteArray = new ByteArray();

        public function CmdData()
        {
            return;
        }// end function

        public static function getData(data:Object) : String
        {
            var str:* = JSONTools.getJSONString(data);
            var rst:* = Base64Killer.encode(str);
            return rst;
        }// end function

        key.writeMultiByte(keyStr, "utf-8");
    }
}
