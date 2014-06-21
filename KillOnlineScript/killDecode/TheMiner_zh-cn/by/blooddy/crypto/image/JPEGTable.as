package by.blooddy.crypto.image
{
    import flash.utils.*;

    final public class JPEGTable extends Object
    {
        private static const _quantTables:Array = new Array();
        private static var _jpegTable:ByteArray;

        public function JPEGTable()
        {
            Error.throwError(ArgumentError, 2012, getQualifiedClassName(this));
            return;
        }// end function

        public static function getTable(quality:uint = 60) : ByteArray
        {
            if (quality > 100)
            {
                Error.throwError(RangeError, 2006, "quality");
            }
            if (quality < 1)
            {
                quality = 1;
            }
            var _loc_2:* = _quantTables[quality];
            if (!_loc_2)
            {
                _loc_2 = JPEGTableHelper.createQuantTable(quality);
                if (!_jpegTable)
                {
                    _jpegTable = new ByteArray();
                    _jpegTable.writeBytes(JPEGTableHelper.createZigZagTable());
                    _jpegTable.writeBytes(JPEGTableHelper.createHuffmanTable());
                    _jpegTable.writeBytes(JPEGTableHelper.createCategoryTable());
                }
            }
            var _loc_3:* = new ByteArray();
            _loc_3.writeBytes(_loc_2);
            _loc_3.writeBytes(_jpegTable);
            _loc_3.position = 0;
            return _loc_3;
        }// end function

    }
}
