package com.google.analytics.debug
{
    import flash.display.*;

    public class Background extends Object
    {

        public function Background()
        {
            return;
        }// end function

        public static function drawRounded(target, g:Graphics, width:uint = 0, height:uint = 0) : void
        {
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:* = Style.roundedCorner;
            if (width > 0)
            {
            }
            if (height > 0)
            {
                _loc_5 = width;
                _loc_6 = height;
            }
            else
            {
                _loc_5 = target.width;
                _loc_6 = target.height;
            }
            if (target.stickToEdge)
            {
            }
            if (target.alignement != Align.none)
            {
                switch(target.alignement)
                {
                    case Align.top:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, 0, 0, _loc_7, _loc_7);
                        break;
                    }
                    case Align.topLeft:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, 0, 0, 0, _loc_7);
                        break;
                    }
                    case Align.topRight:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, 0, 0, _loc_7, 0);
                        break;
                    }
                    case Align.bottom:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, _loc_7, _loc_7, 0, 0);
                        break;
                    }
                    case Align.bottomLeft:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, 0, _loc_7, 0, 0);
                        break;
                    }
                    case Align.bottomRight:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, _loc_7, 0, 0, 0);
                        break;
                    }
                    case Align.left:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, 0, _loc_7, 0, _loc_7);
                        break;
                    }
                    case Align.right:
                    {
                        g.drawRoundRectComplex(0, 0, _loc_5, _loc_6, _loc_7, 0, _loc_7, 0);
                        break;
                    }
                    case Align.center:
                    {
                        g.drawRoundRect(0, 0, _loc_5, _loc_6, _loc_7, _loc_7);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else
            {
                g.drawRoundRect(0, 0, _loc_5, _loc_6, _loc_7, _loc_7);
            }
            return;
        }// end function

    }
}
