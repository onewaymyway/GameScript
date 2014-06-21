package by.blooddy.crypto.image
{
    import flash.display.*;
    import flash.system.*;
    import flash.utils.*;

    public class JPEGEncoder extends Object
    {

        public function JPEGEncoder() : void
        {
            return;
        }// end function

        public static function encode(image:BitmapData, quality:uint = 60) : ByteArray
        {
            var _loc_7:uint = 0;
            var _loc_9:uint = 0;
            var _loc_16:uint = 0;
            var _loc_17:uint = 0;
            var _loc_18:uint = 0;
            var _loc_19:uint = 0;
            var _loc_20:uint = 0;
            var _loc_21:uint = 0;
            var _loc_22:int = 0;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:Number = NaN;
            var _loc_26:Number = NaN;
            var _loc_27:Number = NaN;
            var _loc_28:Number = NaN;
            var _loc_29:Number = NaN;
            var _loc_30:Number = NaN;
            var _loc_31:Number = NaN;
            var _loc_32:Number = NaN;
            var _loc_33:Number = NaN;
            var _loc_34:Number = NaN;
            var _loc_35:Number = NaN;
            var _loc_36:Number = NaN;
            var _loc_37:Number = NaN;
            var _loc_38:Number = NaN;
            var _loc_39:Number = NaN;
            var _loc_40:Number = NaN;
            var _loc_41:Number = NaN;
            var _loc_42:Number = NaN;
            var _loc_43:Number = NaN;
            var _loc_44:Number = NaN;
            var _loc_45:Number = NaN;
            var _loc_46:Number = NaN;
            var _loc_47:Number = NaN;
            var _loc_48:Number = NaN;
            var _loc_49:Number = NaN;
            var _loc_50:Number = NaN;
            var _loc_51:int = 0;
            var _loc_52:int = 0;
            var _loc_53:int = 0;
            var _loc_54:int = 0;
            var _loc_55:int = 0;
            var _loc_56:int = 0;
            var _loc_57:int = 0;
            if (image == null)
            {
                Error.throwError(TypeError, 2007, "image");
            }
            if (quality > 100)
            {
                Error.throwError(RangeError, 2006, "quality");
            }
            var _loc_3:* = ApplicationDomain.currentDomain.domainMemory;
            var _loc_4:* = image.width;
            var _loc_5:* = image.height;
            var _loc_6:* = new ByteArray();
            _loc_6.position = 1792;
            _loc_6.writeBytes(JPEGTable.getTable(quality));
            _loc_6.length = _loc_6.length + (680 + _loc_4 * _loc_5 * 3);
            if (_loc_6.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH)
            {
                _loc_6.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
            }
            ApplicationDomain.currentDomain.domainMemory = _loc_6;
            _loc_7 = 201611;
            _loc_7 = 201629;
            _loc_6.position = _loc_7 + 36;
            _loc_6.writeMultiByte("by.blooddy.crypto.image.JPEGEncoder", "x-ascii");
            _loc_7 = 201701;
            _loc_6.position = _loc_7 + 4;
            _loc_6.writeBytes(_loc_6, 1792, 130);
            _loc_7 = 201835;
            var _loc_8:* = image.width;
            _loc_9 = image.height;
            _loc_7 = 201854;
            _loc_6.position = _loc_7 + 4;
            _loc_6.writeBytes(_loc_6, 3010, 416);
            _loc_7 = 202274;
            var _loc_10:int = 202288;
            var _loc_11:int = 7;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            _loc_8 = 0;
            do
            {
                
                _loc_7 = 0;
                do
                {
                    
                    _loc_9 = 0;
                    _loc_16 = _loc_7 + 8;
                    _loc_17 = _loc_8 + 8;
                    do
                    {
                        
                        do
                        {
                            
                            _loc_18 = image.getPixel(_loc_7, _loc_8);
                            _loc_19 = _loc_18 >>> 16;
                            _loc_20 = _loc_18 >> 8 & 255;
                            _loc_21 = _loc_18 & 255;
                            _loc_9 = _loc_9 + 8;
                        }while (++_loc_7 < _loc_16)
                        _loc_7 = ++_loc_7 - 8;
                    }while (++_loc_8 < _loc_17)
                    _loc_8 = ++_loc_8 - 8;
                    _loc_9 = 256;
                    _loc_22 = _loc_13;
                    _loc_16 = 3426;
                    _loc_17 = 3462;
                    _loc_18 = 0;
                    do
                    {
                        
                        _loc_23 = _loc_9 + _loc_18;
                        _loc_24 = _loc_9 + _loc_18 + 8;
                        _loc_25 = _loc_9 + _loc_18 + 16;
                        _loc_26 = _loc_9 + _loc_18 + 24;
                        _loc_27 = _loc_9 + _loc_18 + 32;
                        _loc_28 = _loc_9 + _loc_18 + 40;
                        _loc_29 = _loc_9 + _loc_18 + 48;
                        _loc_30 = _loc_9 + _loc_18 + 56;
                        _loc_31 = _loc_23 + _loc_30;
                        _loc_38 = _loc_23 - _loc_30;
                        _loc_32 = _loc_24 + _loc_29;
                        _loc_37 = _loc_24 - _loc_29;
                        _loc_33 = _loc_25 + _loc_28;
                        _loc_36 = _loc_25 - _loc_28;
                        _loc_34 = _loc_26 + _loc_27;
                        _loc_35 = _loc_26 - _loc_27;
                        _loc_39 = _loc_31 + _loc_34;
                        _loc_42 = _loc_31 - _loc_34;
                        _loc_40 = _loc_32 + _loc_33;
                        _loc_41 = _loc_32 - _loc_33;
                        _loc_43 = (_loc_41 + _loc_42) * 0.707107;
                        _loc_39 = _loc_35 + _loc_36;
                        _loc_40 = _loc_36 + _loc_37;
                        _loc_41 = _loc_37 + _loc_38;
                        _loc_47 = (_loc_39 - _loc_41) * 0.382683;
                        _loc_44 = 0.541196 * _loc_39 + _loc_47;
                        _loc_46 = 1.30656 * _loc_41 + _loc_47;
                        _loc_45 = _loc_40 * 0.707107;
                        _loc_48 = _loc_38 + _loc_45;
                        _loc_49 = _loc_38 - _loc_45;
                        _loc_18 = _loc_18 + 64;
                    }while (_loc_18 < 512)
                    _loc_18 = 0;
                    do
                    {
                        
                        _loc_23 = _loc_9 + _loc_18;
                        _loc_24 = _loc_9 + _loc_18 + 64;
                        _loc_25 = _loc_9 + _loc_18 + 128;
                        _loc_26 = _loc_9 + _loc_18 + 192;
                        _loc_27 = _loc_9 + _loc_18 + 256;
                        _loc_28 = _loc_9 + _loc_18 + 320;
                        _loc_29 = _loc_9 + _loc_18 + 384;
                        _loc_30 = _loc_9 + _loc_18 + 448;
                        _loc_31 = _loc_23 + _loc_30;
                        _loc_38 = _loc_23 - _loc_30;
                        _loc_32 = _loc_24 + _loc_29;
                        _loc_37 = _loc_24 - _loc_29;
                        _loc_33 = _loc_25 + _loc_28;
                        _loc_36 = _loc_25 - _loc_28;
                        _loc_34 = _loc_26 + _loc_27;
                        _loc_35 = _loc_26 - _loc_27;
                        _loc_39 = _loc_31 + _loc_34;
                        _loc_42 = _loc_31 - _loc_34;
                        _loc_40 = _loc_32 + _loc_33;
                        _loc_41 = _loc_32 - _loc_33;
                        _loc_43 = (_loc_41 + _loc_42) * 0.707107;
                        _loc_39 = _loc_35 + _loc_36;
                        _loc_40 = _loc_36 + _loc_37;
                        _loc_41 = _loc_37 + _loc_38;
                        _loc_47 = (_loc_39 - _loc_41) * 0.382683;
                        _loc_44 = 0.541196 * _loc_39 + _loc_47;
                        _loc_46 = 1.30656 * _loc_41 + _loc_47;
                        _loc_45 = _loc_40 * 0.707107;
                        _loc_48 = _loc_38 + _loc_45;
                        _loc_49 = _loc_38 - _loc_45;
                        _loc_18 = _loc_18 + 8;
                    }while (_loc_18 < 64)
                    _loc_19 = 0;
                    do
                    {
                        
                        _loc_50 = (_loc_9 + (_loc_19 << 3)) * (1922 + (_loc_19 << 3));
                    }while (++_loc_19 < 64)
                    _loc_51 = 0;
                    _loc_52 = _loc_51 - _loc_22;
                    _loc_22 = _loc_51;
                    if (_loc_52 == 0)
                    {
                        _loc_53 = _loc_16;
                        do
                        {
                            
                            if (((_loc_16 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    else
                    {
                        _loc_18 = (32767 + _loc_52) * 3;
                        ++_loc_19 = _loc_16 + (5004 + _loc_18) * 3;
                        _loc_53 = _loc_19 + 1;
                        do
                        {
                            
                            if (((_loc_19 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                        _loc_19 = 5004 + _loc_18;
                        _loc_53 = _loc_19;
                        do
                        {
                            
                            if (((_loc_19 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    _loc_19 = 63;
                    do
                    {
                        
                        _loc_19 = _loc_19 - 1;
                        if (_loc_19 > 0)
                        {
                        }
                    }while (_loc_19 << 2 == 0)
                    if (_loc_19 != 0)
                    {
                        _loc_20 = 1;
                        while (_loc_20 <= _loc_19)
                        {
                            
                            _loc_54 = _loc_20;
                            do
                            {
                                
                                _loc_20 = _loc_20 + 1;
                                if (_loc_20 <= _loc_19)
                                {
                                }
                            }while (_loc_20 << 2 == 0)
                            _loc_55 = _loc_20 - _loc_54;
                            if (_loc_55 >= 16)
                            {
                                _loc_53 = _loc_55 >> 4;
                                _loc_56 = 1;
                                while (_loc_56 <= _loc_53)
                                {
                                    
                                    _loc_21 = _loc_17 + 720;
                                    _loc_57 = _loc_21;
                                    do
                                    {
                                        
                                        if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                        {
                                            _loc_12 = _loc_12 | 1 << _loc_11;
                                        }
                                        _loc_11--;
                                        if (_loc_11 < 0)
                                        {
                                            _loc_11 = 7;
                                            _loc_12 = 0;
                                        }
                                        _loc_57--;
                                    }while (_loc_57 >= 0)
                                    _loc_56++;
                                }
                                _loc_55 = _loc_55 & 15;
                            }
                            _loc_18 = (32767 + (_loc_20 << 2)) * 3;
                            _loc_21 = _loc_17 + (_loc_55 << 4) * 3 + (5004 + _loc_18) * 3;
                            _loc_57 = _loc_21;
                            do
                            {
                                
                                if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                {
                                    _loc_12 = _loc_12 | 1 << _loc_11;
                                }
                                _loc_11--;
                                if (_loc_11 < 0)
                                {
                                    _loc_11 = 7;
                                    _loc_12 = 0;
                                }
                                _loc_57--;
                            }while (_loc_57 >= 0)
                            _loc_21 = 5004 + _loc_18;
                            _loc_57 = _loc_21;
                            do
                            {
                                
                                if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                {
                                    _loc_12 = _loc_12 | 1 << _loc_11;
                                }
                                _loc_11--;
                                if (_loc_11 < 0)
                                {
                                    _loc_11 = 7;
                                    _loc_12 = 0;
                                }
                                _loc_57--;
                            }while (_loc_57 >= 0)
                            _loc_20 = _loc_20 + 1;
                        }
                    }
                    if (_loc_19 != 63)
                    {
                        _loc_53 = _loc_17;
                        do
                        {
                            
                            if (((_loc_17 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    _loc_13 = _loc_22;
                    _loc_9 = 768;
                    _loc_22 = _loc_14;
                    _loc_16 = 4215;
                    _loc_17 = 4251;
                    _loc_18 = 0;
                    do
                    {
                        
                        _loc_23 = _loc_9 + _loc_18;
                        _loc_24 = _loc_9 + _loc_18 + 8;
                        _loc_25 = _loc_9 + _loc_18 + 16;
                        _loc_26 = _loc_9 + _loc_18 + 24;
                        _loc_27 = _loc_9 + _loc_18 + 32;
                        _loc_28 = _loc_9 + _loc_18 + 40;
                        _loc_29 = _loc_9 + _loc_18 + 48;
                        _loc_30 = _loc_9 + _loc_18 + 56;
                        _loc_31 = _loc_23 + _loc_30;
                        _loc_38 = _loc_23 - _loc_30;
                        _loc_32 = _loc_24 + _loc_29;
                        _loc_37 = _loc_24 - _loc_29;
                        _loc_33 = _loc_25 + _loc_28;
                        _loc_36 = _loc_25 - _loc_28;
                        _loc_34 = _loc_26 + _loc_27;
                        _loc_35 = _loc_26 - _loc_27;
                        _loc_39 = _loc_31 + _loc_34;
                        _loc_42 = _loc_31 - _loc_34;
                        _loc_40 = _loc_32 + _loc_33;
                        _loc_41 = _loc_32 - _loc_33;
                        _loc_43 = (_loc_41 + _loc_42) * 0.707107;
                        _loc_39 = _loc_35 + _loc_36;
                        _loc_40 = _loc_36 + _loc_37;
                        _loc_41 = _loc_37 + _loc_38;
                        _loc_47 = (_loc_39 - _loc_41) * 0.382683;
                        _loc_44 = 0.541196 * _loc_39 + _loc_47;
                        _loc_46 = 1.30656 * _loc_41 + _loc_47;
                        _loc_45 = _loc_40 * 0.707107;
                        _loc_48 = _loc_38 + _loc_45;
                        _loc_49 = _loc_38 - _loc_45;
                        _loc_18 = _loc_18 + 64;
                    }while (_loc_18 < 512)
                    _loc_18 = 0;
                    do
                    {
                        
                        _loc_23 = _loc_9 + _loc_18;
                        _loc_24 = _loc_9 + _loc_18 + 64;
                        _loc_25 = _loc_9 + _loc_18 + 128;
                        _loc_26 = _loc_9 + _loc_18 + 192;
                        _loc_27 = _loc_9 + _loc_18 + 256;
                        _loc_28 = _loc_9 + _loc_18 + 320;
                        _loc_29 = _loc_9 + _loc_18 + 384;
                        _loc_30 = _loc_9 + _loc_18 + 448;
                        _loc_31 = _loc_23 + _loc_30;
                        _loc_38 = _loc_23 - _loc_30;
                        _loc_32 = _loc_24 + _loc_29;
                        _loc_37 = _loc_24 - _loc_29;
                        _loc_33 = _loc_25 + _loc_28;
                        _loc_36 = _loc_25 - _loc_28;
                        _loc_34 = _loc_26 + _loc_27;
                        _loc_35 = _loc_26 - _loc_27;
                        _loc_39 = _loc_31 + _loc_34;
                        _loc_42 = _loc_31 - _loc_34;
                        _loc_40 = _loc_32 + _loc_33;
                        _loc_41 = _loc_32 - _loc_33;
                        _loc_43 = (_loc_41 + _loc_42) * 0.707107;
                        _loc_39 = _loc_35 + _loc_36;
                        _loc_40 = _loc_36 + _loc_37;
                        _loc_41 = _loc_37 + _loc_38;
                        _loc_47 = (_loc_39 - _loc_41) * 0.382683;
                        _loc_44 = 0.541196 * _loc_39 + _loc_47;
                        _loc_46 = 1.30656 * _loc_41 + _loc_47;
                        _loc_45 = _loc_40 * 0.707107;
                        _loc_48 = _loc_38 + _loc_45;
                        _loc_49 = _loc_38 - _loc_45;
                        _loc_18 = _loc_18 + 8;
                    }while (_loc_18 < 64)
                    _loc_19 = 0;
                    do
                    {
                        
                        _loc_50 = (_loc_9 + (_loc_19 << 3)) * (2434 + (_loc_19 << 3));
                    }while (++_loc_19 < 64)
                    _loc_51 = 0;
                    _loc_52 = _loc_51 - _loc_22;
                    _loc_22 = _loc_51;
                    if (_loc_52 == 0)
                    {
                        _loc_53 = _loc_16;
                        do
                        {
                            
                            if (((_loc_16 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    else
                    {
                        _loc_18 = (32767 + _loc_52) * 3;
                        ++_loc_19 = _loc_16 + (5004 + _loc_18) * 3;
                        _loc_53 = _loc_19 + 1;
                        do
                        {
                            
                            if (((_loc_19 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                        _loc_19 = 5004 + _loc_18;
                        _loc_53 = _loc_19;
                        do
                        {
                            
                            if (((_loc_19 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    _loc_19 = 63;
                    do
                    {
                        
                        _loc_19 = _loc_19 - 1;
                        if (_loc_19 > 0)
                        {
                        }
                    }while (_loc_19 << 2 == 0)
                    if (_loc_19 != 0)
                    {
                        _loc_20 = 1;
                        while (_loc_20 <= _loc_19)
                        {
                            
                            _loc_54 = _loc_20;
                            do
                            {
                                
                                _loc_20 = _loc_20 + 1;
                                if (_loc_20 <= _loc_19)
                                {
                                }
                            }while (_loc_20 << 2 == 0)
                            _loc_55 = _loc_20 - _loc_54;
                            if (_loc_55 >= 16)
                            {
                                _loc_53 = _loc_55 >> 4;
                                _loc_56 = 1;
                                while (_loc_56 <= _loc_53)
                                {
                                    
                                    _loc_21 = _loc_17 + 720;
                                    _loc_57 = _loc_21;
                                    do
                                    {
                                        
                                        if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                        {
                                            _loc_12 = _loc_12 | 1 << _loc_11;
                                        }
                                        _loc_11--;
                                        if (_loc_11 < 0)
                                        {
                                            _loc_11 = 7;
                                            _loc_12 = 0;
                                        }
                                        _loc_57--;
                                    }while (_loc_57 >= 0)
                                    _loc_56++;
                                }
                                _loc_55 = _loc_55 & 15;
                            }
                            _loc_18 = (32767 + (_loc_20 << 2)) * 3;
                            _loc_21 = _loc_17 + (_loc_55 << 4) * 3 + (5004 + _loc_18) * 3;
                            _loc_57 = _loc_21;
                            do
                            {
                                
                                if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                {
                                    _loc_12 = _loc_12 | 1 << _loc_11;
                                }
                                _loc_11--;
                                if (_loc_11 < 0)
                                {
                                    _loc_11 = 7;
                                    _loc_12 = 0;
                                }
                                _loc_57--;
                            }while (_loc_57 >= 0)
                            _loc_21 = 5004 + _loc_18;
                            _loc_57 = _loc_21;
                            do
                            {
                                
                                if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                {
                                    _loc_12 = _loc_12 | 1 << _loc_11;
                                }
                                _loc_11--;
                                if (_loc_11 < 0)
                                {
                                    _loc_11 = 7;
                                    _loc_12 = 0;
                                }
                                _loc_57--;
                            }while (_loc_57 >= 0)
                            _loc_20 = _loc_20 + 1;
                        }
                    }
                    if (_loc_19 != 63)
                    {
                        _loc_53 = _loc_17;
                        do
                        {
                            
                            if (((_loc_17 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    _loc_14 = _loc_22;
                    _loc_9 = 1280;
                    _loc_22 = _loc_15;
                    _loc_16 = 4215;
                    _loc_17 = 4251;
                    _loc_18 = 0;
                    do
                    {
                        
                        _loc_23 = _loc_9 + _loc_18;
                        _loc_24 = _loc_9 + _loc_18 + 8;
                        _loc_25 = _loc_9 + _loc_18 + 16;
                        _loc_26 = _loc_9 + _loc_18 + 24;
                        _loc_27 = _loc_9 + _loc_18 + 32;
                        _loc_28 = _loc_9 + _loc_18 + 40;
                        _loc_29 = _loc_9 + _loc_18 + 48;
                        _loc_30 = _loc_9 + _loc_18 + 56;
                        _loc_31 = _loc_23 + _loc_30;
                        _loc_38 = _loc_23 - _loc_30;
                        _loc_32 = _loc_24 + _loc_29;
                        _loc_37 = _loc_24 - _loc_29;
                        _loc_33 = _loc_25 + _loc_28;
                        _loc_36 = _loc_25 - _loc_28;
                        _loc_34 = _loc_26 + _loc_27;
                        _loc_35 = _loc_26 - _loc_27;
                        _loc_39 = _loc_31 + _loc_34;
                        _loc_42 = _loc_31 - _loc_34;
                        _loc_40 = _loc_32 + _loc_33;
                        _loc_41 = _loc_32 - _loc_33;
                        _loc_43 = (_loc_41 + _loc_42) * 0.707107;
                        _loc_39 = _loc_35 + _loc_36;
                        _loc_40 = _loc_36 + _loc_37;
                        _loc_41 = _loc_37 + _loc_38;
                        _loc_47 = (_loc_39 - _loc_41) * 0.382683;
                        _loc_44 = 0.541196 * _loc_39 + _loc_47;
                        _loc_46 = 1.30656 * _loc_41 + _loc_47;
                        _loc_45 = _loc_40 * 0.707107;
                        _loc_48 = _loc_38 + _loc_45;
                        _loc_49 = _loc_38 - _loc_45;
                        _loc_18 = _loc_18 + 64;
                    }while (_loc_18 < 512)
                    _loc_18 = 0;
                    do
                    {
                        
                        _loc_23 = _loc_9 + _loc_18;
                        _loc_24 = _loc_9 + _loc_18 + 64;
                        _loc_25 = _loc_9 + _loc_18 + 128;
                        _loc_26 = _loc_9 + _loc_18 + 192;
                        _loc_27 = _loc_9 + _loc_18 + 256;
                        _loc_28 = _loc_9 + _loc_18 + 320;
                        _loc_29 = _loc_9 + _loc_18 + 384;
                        _loc_30 = _loc_9 + _loc_18 + 448;
                        _loc_31 = _loc_23 + _loc_30;
                        _loc_38 = _loc_23 - _loc_30;
                        _loc_32 = _loc_24 + _loc_29;
                        _loc_37 = _loc_24 - _loc_29;
                        _loc_33 = _loc_25 + _loc_28;
                        _loc_36 = _loc_25 - _loc_28;
                        _loc_34 = _loc_26 + _loc_27;
                        _loc_35 = _loc_26 - _loc_27;
                        _loc_39 = _loc_31 + _loc_34;
                        _loc_42 = _loc_31 - _loc_34;
                        _loc_40 = _loc_32 + _loc_33;
                        _loc_41 = _loc_32 - _loc_33;
                        _loc_43 = (_loc_41 + _loc_42) * 0.707107;
                        _loc_39 = _loc_35 + _loc_36;
                        _loc_40 = _loc_36 + _loc_37;
                        _loc_41 = _loc_37 + _loc_38;
                        _loc_47 = (_loc_39 - _loc_41) * 0.382683;
                        _loc_44 = 0.541196 * _loc_39 + _loc_47;
                        _loc_46 = 1.30656 * _loc_41 + _loc_47;
                        _loc_45 = _loc_40 * 0.707107;
                        _loc_48 = _loc_38 + _loc_45;
                        _loc_49 = _loc_38 - _loc_45;
                        _loc_18 = _loc_18 + 8;
                    }while (_loc_18 < 64)
                    _loc_19 = 0;
                    do
                    {
                        
                        _loc_50 = (_loc_9 + (_loc_19 << 3)) * (2434 + (_loc_19 << 3));
                    }while (++_loc_19 < 64)
                    _loc_51 = 0;
                    _loc_52 = _loc_51 - _loc_22;
                    _loc_22 = _loc_51;
                    if (_loc_52 == 0)
                    {
                        _loc_53 = _loc_16;
                        do
                        {
                            
                            if (((_loc_16 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    else
                    {
                        _loc_18 = (32767 + _loc_52) * 3;
                        ++_loc_19 = _loc_16 + (5004 + _loc_18) * 3;
                        _loc_53 = _loc_19 + 1;
                        do
                        {
                            
                            if (((_loc_19 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                        _loc_19 = 5004 + _loc_18;
                        _loc_53 = _loc_19;
                        do
                        {
                            
                            if (((_loc_19 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    _loc_19 = 63;
                    do
                    {
                        
                        _loc_19 = _loc_19 - 1;
                        if (_loc_19 > 0)
                        {
                        }
                    }while (_loc_19 << 2 == 0)
                    if (_loc_19 != 0)
                    {
                        _loc_20 = 1;
                        while (_loc_20 <= _loc_19)
                        {
                            
                            _loc_54 = _loc_20;
                            do
                            {
                                
                                _loc_20 = _loc_20 + 1;
                                if (_loc_20 <= _loc_19)
                                {
                                }
                            }while (_loc_20 << 2 == 0)
                            _loc_55 = _loc_20 - _loc_54;
                            if (_loc_55 >= 16)
                            {
                                _loc_53 = _loc_55 >> 4;
                                _loc_56 = 1;
                                while (_loc_56 <= _loc_53)
                                {
                                    
                                    _loc_21 = _loc_17 + 720;
                                    _loc_57 = _loc_21;
                                    do
                                    {
                                        
                                        if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                        {
                                            _loc_12 = _loc_12 | 1 << _loc_11;
                                        }
                                        _loc_11--;
                                        if (_loc_11 < 0)
                                        {
                                            _loc_11 = 7;
                                            _loc_12 = 0;
                                        }
                                        _loc_57--;
                                    }while (_loc_57 >= 0)
                                    _loc_56++;
                                }
                                _loc_55 = _loc_55 & 15;
                            }
                            _loc_18 = (32767 + (_loc_20 << 2)) * 3;
                            _loc_21 = _loc_17 + (_loc_55 << 4) * 3 + (5004 + _loc_18) * 3;
                            _loc_57 = _loc_21;
                            do
                            {
                                
                                if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                {
                                    _loc_12 = _loc_12 | 1 << _loc_11;
                                }
                                _loc_11--;
                                if (_loc_11 < 0)
                                {
                                    _loc_11 = 7;
                                    _loc_12 = 0;
                                }
                                _loc_57--;
                            }while (_loc_57 >= 0)
                            _loc_21 = 5004 + _loc_18;
                            _loc_57 = _loc_21;
                            do
                            {
                                
                                if (((_loc_21 + 1) & 1 << _loc_57) != 0)
                                {
                                    _loc_12 = _loc_12 | 1 << _loc_11;
                                }
                                _loc_11--;
                                if (_loc_11 < 0)
                                {
                                    _loc_11 = 7;
                                    _loc_12 = 0;
                                }
                                _loc_57--;
                            }while (_loc_57 >= 0)
                            _loc_20 = _loc_20 + 1;
                        }
                    }
                    if (_loc_19 != 63)
                    {
                        _loc_53 = _loc_17;
                        do
                        {
                            
                            if (((_loc_17 + 1) & 1 << _loc_53) != 0)
                            {
                                _loc_12 = _loc_12 | 1 << _loc_11;
                            }
                            _loc_11--;
                            if (_loc_11 < 0)
                            {
                                _loc_11 = 7;
                                _loc_12 = 0;
                            }
                            _loc_53--;
                        }while (_loc_53 >= 0)
                    }
                    _loc_15 = _loc_22;
                    _loc_7 = _loc_7 + 8;
                }while (_loc_7 < _loc_4)
                _loc_8 = _loc_8 + 8;
            }while (_loc_8 < _loc_5)
            if (_loc_11 >= 0)
            {
                _loc_22 = _loc_11 + 1;
                do
                {
                    
                    if (((1 << (_loc_11 + 1)) - 1 & 1 << _loc_22) != 0)
                    {
                        _loc_12 = _loc_12 | 1 << _loc_11;
                    }
                    _loc_11--;
                    if (_loc_11 < 0)
                    {
                        _loc_11 = 7;
                        _loc_12 = 0;
                    }
                    _loc_22--;
                }while (_loc_22 >= 0)
            }
            ApplicationDomain.currentDomain.domainMemory = _loc_3;
            var _loc_58:* = new ByteArray();
            _loc_58.writeBytes(_loc_6, 201609, _loc_10 - 201609 + 2);
            _loc_58.position = 0;
            return _loc_58;
        }// end function

    }
}
