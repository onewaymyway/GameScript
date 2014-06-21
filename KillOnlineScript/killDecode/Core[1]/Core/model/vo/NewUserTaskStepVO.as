package Core.model.vo
{
    import flash.geom.*;

    public class NewUserTaskStepVO extends Object
    {
        public var id:uint;
        public var alt:String;
        public var type:uint;
        public var aboutData:Object;
        public var btnrec:Rectangle;
        public var alert:String;

        public function NewUserTaskStepVO(param1:uint, param2:String, param3:uint, param4:String = "", param5:Rectangle = null, param6:Object = null)
        {
            this.id = param1;
            this.alt = param2;
            this.type = param3;
            this.aboutData = param6;
            this.btnrec = param5;
            this.alert = param4;
            return;
        }// end function

        public static function AsVO(param1:Object) : NewUserTaskStepVO
        {
            var _loc_2:* = param1 as NewUserTaskStepVO;
            return _loc_2;
        }// end function

    }
}
