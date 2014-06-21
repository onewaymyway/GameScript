package com.sociodox.theminer.ui
{
    import com.sociodox.theminer.manager.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.text.*;

    public class ToolTip extends Sprite
    {
        private var mText:TextField = null;
        private static var mInstance:ToolTip = null;
        private static var myformat:TextFormat = null;
        private static var myglow:GlowFilter = null;
        public static var width:int = 0;
        public static var height:int = 0;

        public function ToolTip()
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            myformat = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, true);
            myglow = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.visible = false;
            this.mText = new TextField();
            this.mText.width = 800;
            this.mText.selectable = false;
            this.mText.defaultTextFormat = myformat;
            this.mText.filters = [myglow];
            this.mText.x = 2;
            addChild(this.mText);
            mInstance = this;
            return;
        }// end function

        public function SetToolTipText(text:String) : void
        {
            this.mText.text = text;
            var _loc_2:* = this.mText.textWidth + 7;
            var _loc_3:* = this.mText.textHeight + 4;
            ToolTip.width = _loc_2;
            ToolTip.height = _loc_3;
            this.graphics.clear();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.5);
            this.graphics.drawRect(0, 0, _loc_2, _loc_3);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 0.5);
            this.graphics.drawRect(1, 1, _loc_2 - 2, _loc_3 - 2);
            this.graphics.endFill();
            return;
        }// end function

        public static function UpdateSkin() : void
        {
            if (myformat != null)
            {
                myformat.color = SkinManager.COLOR_GLOBAL_TEXT;
                myglow.color = SkinManager.COLOR_GLOBAL_TEXT_GLOW;
            }
            mInstance.mText.defaultTextFormat = myformat;
            mInstance.mText.filters = [myglow];
            return;
        }// end function

        public static function get Visible() : Boolean
        {
            return mInstance.visible;
        }// end function

        public static function set Visible(isVisible:Boolean) : void
        {
            mInstance.visible = isVisible;
            return;
        }// end function

        public static function SetToolTip(text:String, aX:int, aY:int) : void
        {
            mInstance.SetToolTipText(text);
            if (aX > mInstance.stage.stageWidth - ToolTip.width)
            {
                aX = mInstance.stage.stageWidth - ToolTip.width;
            }
            if (aY > mInstance.stage.stageHeight - ToolTip.height)
            {
                aY = mInstance.stage.stageHeight - ToolTip.height;
            }
            mInstance.x = aX;
            mInstance.y = aY;
            return;
        }// end function

        public static function set Text(aText:String) : void
        {
            mInstance.SetToolTipText(aText);
            if (mInstance.x > mInstance.stage.stageWidth - ToolTip.width)
            {
                mInstance.x = mInstance.stage.stageWidth - ToolTip.width;
            }
            if (mInstance.y > mInstance.stage.stageHeight - ToolTip.height)
            {
                mInstance.y = mInstance.stage.stageHeight - ToolTip.height;
            }
            return;
        }// end function

        public static function SetPosition(aX:int, aY:int) : void
        {
            mInstance.x = aX;
            mInstance.y = aY;
            return;
        }// end function

    }
}
