package as3reflect
{

    public class MetaDataContainer extends Object implements IMetaDataContainer
    {
        private var _metaData:Array;

        public function MetaDataContainer(param1:Array = null)
        {
            _metaData = param1 == null ? ([]) : (param1);
            return;
        }// end function

        public function addMetaData(param1:MetaData) : void
        {
            _metaData.push(param1);
            return;
        }// end function

        public function getMetaData(param1:String) : Array
        {
            var _loc_2:Array = [];
            var _loc_3:int = 0;
            while (_loc_3 < _metaData.length)
            {
                
                if (MetaData(_metaData[_loc_3]).name == param1)
                {
                    _loc_2.push(_metaData[_loc_3]);
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function get metaData() : Array
        {
            return _metaData.concat();
        }// end function

        public function hasMetaData(param1:String) : Boolean
        {
            return getMetaData(param1) != null;
        }// end function

    }
}
