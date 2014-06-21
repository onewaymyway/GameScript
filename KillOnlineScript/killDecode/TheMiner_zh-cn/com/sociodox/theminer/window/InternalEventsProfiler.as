package com.sociodox.theminer.window
{
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.manager.*;
    import com.sociodox.theminer.ui.button.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class InternalEventsProfiler extends Sprite implements IWindow
    {
        private var mInternalEventsLabels:TextField;
        private var mFrameDivisionData:BitmapData = null;
        private var mFrameDivision:Bitmap = null;
        private var mInterface:Sprite = null;
        private var mBitmapBackgroundData:BitmapData = null;
        private var mBitmapBackground:Bitmap = null;
        private var mPauseButton:MenuButton;
        private var frameCount:int = 0;
        private var mEnterTime:int = 0;
        private var mBitmapCanvas:Bitmap;
        private var mLastTime:int = 0;
        private var mProfilerWasActive:Boolean = false;

        public function InternalEventsProfiler()
        {
            this.mProfilerWasActive = Configuration.PROFILE_INTERNAL_EVENTS;
            Configuration.PROFILE_INTERNAL_EVENTS = true;
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "EventProfiler", "EventProfiler Enter");
            return;
        }// end function

        private function Init() : void
        {
            var _loc_6:TextField = null;
            var _loc_8:BitmapData = null;
            this.mInterface = new Sprite();
            this.mouseEnabled = false;
            this.mBitmapBackgroundData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mBitmapCanvas = new Bitmap(this.mBitmapBackgroundData);
            addChild(this.mBitmapCanvas);
            var _loc_1:* = Stage2D.stageWidth;
            var _loc_2:* = new Sprite();
            this.mInterface.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 1);
            this.mInterface.graphics.drawRect(0, 16, _loc_1, Stage2D.stageHeight - 18);
            this.mInterface.graphics.endFill();
            this.mInterface.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 1);
            this.mInterface.graphics.drawRect(0, 17, _loc_1, 1);
            this.mInterface.graphics.endFill();
            this.mInterface.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 1);
            this.mInterface.graphics.drawRect(0, 16, _loc_1, 1);
            this.mInterface.graphics.endFill();
            var _loc_3:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_4:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.RIGHT);
            var _loc_5:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            var _loc_7:int = 20;
            this.mFrameDivisionData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight - 50 - 20, false, 0);
            this.mFrameDivision = new Bitmap(this.mFrameDivisionData);
            this.mInterface.addChild(this.mFrameDivision);
            this.mFrameDivision.x = 0;
            this.mFrameDivision.y = Stage2D.stageHeight - this.mFrameDivisionData.height;
            _loc_8 = new BitmapData(Stage2D.stageWidth, 50, false, 0);
            var _loc_9:* = new Bitmap(_loc_8);
            _loc_9.y = 20;
            this.mInterface.addChild(_loc_9);
            var _loc_10:* = new Rectangle();
            var _loc_12:int = 10;
            _loc_10.height = 10;
            _loc_10.width = _loc_12;
            this.mInternalEventsLabels = new TextField();
            this.mInternalEventsLabels.autoSize = TextFieldAutoSize.LEFT;
            this.mInternalEventsLabels.defaultTextFormat = _loc_3;
            this.mInternalEventsLabels.selectable = false;
            this.mInternalEventsLabels.filters = [_loc_5];
            var _loc_11:* = new Matrix();
            _loc_11.identity();
            _loc_10.x = 4;
            _loc_10.y = 2;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_VERIFY);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_VERIFY;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 1 * 100;
            _loc_10.y = 2;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_MARK);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_MARK;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 2 * 100;
            _loc_10.y = 2;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_REAP);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_REAP;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 3 * 100;
            _loc_10.y = 2;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_SWEEP);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_SWEEP;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4;
            _loc_10.y = 2 + 1 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_ENTERFRAME);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_ENTERFRAME;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 1 * 100;
            _loc_10.y = 2 + 1 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_TIMER);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_TIMERS;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 2 * 100;
            _loc_10.y = 2 + 1 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_PRERENDER);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_PRERENDER;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 3 * 100;
            _loc_10.y = 2 + 1 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_RENDER);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_RENDER;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 0 * 100;
            _loc_10.y = 2 + 2 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_AVM1);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_AVM1;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 1 * 100;
            _loc_10.y = 2 + 2 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_IO);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_IO;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 2 * 100;
            _loc_10.y = 2 + 2 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_MOUSE);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_MOUSE;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 4 + 3 * 100;
            _loc_10.y = 2 + 2 * 14;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_INTERNAL_FREE);
            _loc_11.tx = _loc_10.x + 12;
            _loc_11.ty = _loc_10.y - 4;
            this.mInternalEventsLabels.text = Localization.Lbl_IE_FREE;
            _loc_8.draw(this.mInternalEventsLabels, _loc_11);
            _loc_10.x = 0;
            _loc_10.y = _loc_8.height - 5;
            _loc_10.width = _loc_8.width;
            _loc_10.height = 3;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_GLOBAL_LINE_DARK);
            _loc_10.x = 0;
            _loc_10.y = _loc_8.height - 4;
            _loc_10.width = _loc_8.width;
            _loc_10.height = 1;
            _loc_8.fillRect(_loc_10, SkinManager.COLOR_GLOBAL_LINE);
            this.mPauseButton = new MenuButton(Stage2D.stage.stageWidth - 16, _loc_8.height, MenuButton.ICON_PAUSE, null, -1, Localization.Lbl_MFP_PauseRefresh, true, Localization.Lbl_MFP_ResumeRefresh);
            addChild(this.mPauseButton);
            return;
        }// end function

        public function Update() : void
        {
            if (this.mPauseButton.mIsSelected)
            {
                return;
            }
            var _loc_1:* = getTimer() - this.mLastTime;
            if (_loc_1 < 1000 / Commands.RefreshRate)
            {
                return;
            }
            this.mLastTime = getTimer();
            var _loc_2:* = SampleAnalyzer.GetInternalsEvents();
            var _loc_3:* = _loc_2.FrameTime;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            this.mFrameDivisionData.scroll(0, 4);
            _loc_5 = Math.ceil(_loc_2.mVerify.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_VERIFY);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mMark.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_MARK);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mReap.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_REAP);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mSweep.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_SWEEP);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mEnterFrame.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_ENTERFRAME);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mTimers.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_TIMER);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mPreRender.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_PRERENDER);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mRender.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_RENDER);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mFree.entryTime / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, _loc_5, 2), SkinManager.COLOR_INTERNAL_FREE);
            _loc_4 = _loc_4 + _loc_5;
            _loc_5 = Math.ceil(_loc_2.mFree.entryCount * 33 / _loc_3 * this.mFrameDivisionData.width);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4, 0, 1, 2), SkinManager.COLOR_GLOBAL_BG);
            this.mFrameDivisionData.fillRect(new Rectangle((_loc_4 + 1), 0, 1, 2), SkinManager.COLOR_GLOBAL_LINE);
            this.mFrameDivisionData.fillRect(new Rectangle(_loc_4 + 2, 0, 1, 2), SkinManager.COLOR_GLOBAL_BG);
            _loc_2.ResetFrame();
            this.Render();
            return;
        }// end function

        private function Render() : void
        {
            this.mBitmapBackgroundData.lock();
            this.mBitmapBackgroundData.floodFill(0, 0, 0);
            this.mBitmapBackgroundData.draw(this.mInterface, null);
            this.mBitmapBackgroundData.unlock(this.mBitmapBackgroundData.rect);
            this.alpha = Commands.Opacity / 10;
            return;
        }// end function

        public function Dispose() : void
        {
            Configuration.PROFILE_INTERNAL_EVENTS = this.mProfilerWasActive;
            Analytics.Track("Tab", "EventProfiler", "EventProfiler Exit", int((getTimer() - this.mEnterTime) / 1000));
            this.mInterface.graphics.clear();
            this.mInternalEventsLabels = null;
            this.mFrameDivisionData = null;
            this.mFrameDivision = null;
            this.mBitmapCanvas = null;
            this.mInterface = null;
            if (this.mBitmapBackgroundData != null)
            {
                this.mBitmapBackgroundData.dispose();
                this.mBitmapBackgroundData = null;
            }
            this.mPauseButton.Dispose();
            this.mPauseButton = null;
            this.mBitmapBackground = null;
            if (this.mFrameDivisionData != null)
            {
                this.mFrameDivisionData.dispose();
                this.mFrameDivisionData = null;
            }
            this.mFrameDivision = null;
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
