package com.sociodox.theminer.window
{
    import com.sociodox.theminer.manager.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class Overdraw extends Sprite implements IWindow
    {
        private var mRenderTargetData:BitmapData = null;
        private var mRenderTargetDataAlpha:BitmapData = null;
        private var mRenderTargetDataAlphaNotVisible:BitmapData = null;
        private var mRenderTargetDataRect:Rectangle = null;
        private var mRenderTarget:Bitmap = null;
        private var currentRenderTarget:Sprite;
        private var mInfos:TextField;
        private var mTimer:Timer;
        private var mDOTotal:int = 0;
        private var mMaxDepth:int = 0;
        private var mEnterTime:int = 0;
        private var mLastTick:int = 0;
        private static const COLOR_ALPHA:Number = 0.3;

        public function Overdraw()
        {
            this.currentRenderTarget = new Sprite();
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "OverdrawProfiler", "OverdrawProfiler Enter");
            return;
        }// end function

        private function Init() : void
        {
            var _loc_2:Sprite = null;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.mRenderTargetData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataAlpha = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataAlphaNotVisible = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataAlpha.fillRect(this.mRenderTargetDataAlpha.rect, 150994943);
            this.mRenderTargetDataAlphaNotVisible.fillRect(this.mRenderTargetDataAlpha.rect, 671088640 + (SkinManager.COLOR_OVERDRAW_NOTVISIBLE & 16777215));
            this.mRenderTargetDataRect = this.mRenderTargetData.rect;
            this.mRenderTarget = new Bitmap();
            this.mRenderTarget.bitmapData = this.mRenderTargetData;
            this.addChild(this.mRenderTarget);
            var _loc_1:* = Stage2D.stageWidth;
            _loc_2 = new Sprite();
            _loc_2.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 0.4);
            _loc_2.graphics.drawRect(0, 0, _loc_1, 17);
            _loc_2.graphics.endFill();
            _loc_2.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 0.6);
            _loc_2.graphics.drawRect(0, 1, _loc_1, 1);
            _loc_2.graphics.endFill();
            _loc_2.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.8);
            _loc_2.graphics.drawRect(0, 0, _loc_1, 1);
            _loc_2.graphics.endFill();
            addChild(_loc_2);
            _loc_2.y = Stage2D.stageHeight - _loc_2.height;
            var _loc_3:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_4:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mInfos = new TextField();
            this.mInfos.autoSize = TextFieldAutoSize.LEFT;
            this.mInfos.defaultTextFormat = _loc_3;
            this.mInfos.selectable = false;
            this.mInfos.text = "";
            this.mInfos.filters = [_loc_4];
            this.mInfos.x = 2;
            addChild(this.mInfos);
            this.mInfos.y = Stage2D.stageHeight - _loc_2.height;
            return;
        }// end function

        public function Dispose() : void
        {
            this.mInfos = null;
            Analytics.Track("Tab", "OverdrawProfiler", "OverdrawProfiler Exit", int((getTimer() - this.mEnterTime) / 1000));
            if (this.mRenderTarget != null)
            {
                this.mRenderTarget.bitmapData = null;
                this.mRenderTarget = null;
            }
            if (this.mRenderTargetData != null)
            {
                this.mRenderTargetData.dispose();
                this.mRenderTargetData = null;
            }
            this.mRenderTargetDataRect = null;
            while (this.numChildren > 0)
            {
                
                this.removeChildAt(0);
            }
            this.currentRenderTarget = null;
            return;
        }// end function

        public function Update() : void
        {
            var _loc_1:String = null;
            if (getTimer() - this.mLastTick >= 1000)
            {
                this.mLastTick = getTimer();
                _loc_1 = Localization.Lbl_O_DisplayObjectOnStage + "[ " + this.mDOTotal + " ]\t" + Localization.Lbl_O_MaxDepth + "[ " + this.mMaxDepth + " ]";
                this.mInfos.text = _loc_1;
            }
            this.mRenderTargetData.fillRect(this.mRenderTargetData.rect, SkinManager.COLOR_GLOBAL_BG | 4278190080);
            this.mMaxDepth = 0;
            this.mDOTotal = 0;
            this.mRenderTargetData.lock();
            this.ParseStage(Stage2D);
            this.mRenderTargetData.unlock();
            return;
        }// end function

        private function ParseStage(obj:DisplayObjectContainer, depth:int = 1) : void
        {
            var _loc_6:DisplayObject = null;
            var _loc_7:Rectangle = null;
            if (obj != null)
            {
            }
            if (obj == parent)
            {
                return;
            }
            if (this.mMaxDepth < depth)
            {
                this.mMaxDepth = depth;
            }
            var _loc_3:* = new ColorTransform(1, 1, 1, 1, 12, 12, 12, 12);
            var _loc_4:* = new Point();
            var _loc_5:int = 0;
            while (_loc_5 < obj.numChildren)
            {
                
                var _loc_8:String = this;
                var _loc_9:* = this.mDOTotal + 1;
                _loc_8.mDOTotal = _loc_9;
                _loc_6 = obj.getChildAt(_loc_5);
                if (_loc_6 == null)
                {
                }
                else
                {
                    _loc_7 = _loc_6.getRect(Stage2D);
                    _loc_4.x = _loc_7.x;
                    _loc_4.y = _loc_7.y;
                    if (_loc_6.visible != false)
                    {
                    }
                    if (_loc_6.alpha == 0)
                    {
                        this.mRenderTargetData.copyPixels(this.mRenderTargetDataAlphaNotVisible, _loc_7, _loc_4, null, null, true);
                    }
                    else
                    {
                        this.mRenderTargetData.copyPixels(this.mRenderTargetDataAlpha, _loc_7, _loc_4, null, null, true);
                    }
                    this.ParseStage(_loc_6 as DisplayObjectContainer, (depth + 1));
                }
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        public function Unlink() : void
        {
            if (this.parent != null)
            {
                this.parent.removeChild(this);
            }
            return;
        }// end function

        public function Link(aParent:DisplayObjectContainer, aPos:int) : void
        {
            aParent.addChildAt(this, aPos);
            return;
        }// end function

    }
}
