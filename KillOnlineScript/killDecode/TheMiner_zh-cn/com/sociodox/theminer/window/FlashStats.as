package com.sociodox.theminer.window
{
    import __AS3__.vec.*;
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.manager.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class FlashStats extends Bitmap implements IWindow
    {
        private var mMemoryUseBitmapData:BitmapData = null;
        private var mBitmapBackgroundData:BitmapData = null;
        private var mBitmapBackground:Bitmap = null;
        private var mGridLine:Rectangle = null;
        private var mTypeColumnStartPos:int = 2;
        private var mCurrentColumnStartPos:int = 120;
        private var mMinColumnStartPos:int = 190;
        private var mMaxColumnStartPos:int = 240;
        private var mBlittingTextField:TextField;
        private var mBlittingTextFieldARight:TextField;
        private var mTextFieldMaxMemGraphARight:TextField;
        private var mBlittingTextFieldMatrix:Matrix = null;
        private var frameCount:int = 0;
        private var mLastTime:int = 0;
        private var statsLastFrame:FrameStatistics;
        private var timer:int;
        private var ms_prev:int;
        private var fps:int = 0;
        private var mDrawGraphics:Sprite;
        private var mDrawGraphicsMatrix:Matrix;
        private var mGraphPos:Point;
        private var mCurrentMaxMemGraph:int = 0;
        private var mEnterTime:int = 0;
        private var lastGraphHeight:int = 0;
        private var mProfilerWasActive:Boolean = false;
        public static var stats:FrameStatistics = new FrameStatistics();
        public static var mMemoryValues:Vector.<int> = null;
        public static var mMemoryMaxValues:Vector.<int> = null;
        public static var mMemoryGC:Vector.<int> = null;
        public static var mSamplingCount:int = 300;
        public static var mSamplingStartIdx:int = 0;
        public static var IsStaticInitialized:Boolean = InitStatic();
        public static var HasGC:Boolean = false;

        public function FlashStats()
        {
            this.mProfilerWasActive = Configuration.PROFILE_MEMGRAPH;
            Configuration.PROFILE_MEMGRAPH = true;
            this.Init();
            this.mEnterTime = getTimer();
            return;
        }// end function

        private function Init() : void
        {
            Analytics.Track("Tab", "FlashStats", "FlashStats Enter");
            this.statsLastFrame = new FrameStatistics();
            this.mGridLine = new Rectangle();
            var _loc_1:int = 15;
            var _loc_2:int = 0;
            while (_loc_2 < mSamplingCount)
            {
                
                if (!this.mProfilerWasActive)
                {
                    mMemoryMaxValues[_loc_2] = -1;
                    mMemoryValues[_loc_2] = -1;
                }
                if (mMemoryMaxValues[_loc_2] > stats.MemoryMax)
                {
                    stats.MemoryMax = mMemoryMaxValues[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            this.mBitmapBackgroundData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mMemoryUseBitmapData = new BitmapData(Stage2D.stageWidth, 128, false, SkinManager.COLOR_STATS_BG);
            this.mGraphPos = new Point(0, Stage2D.stageHeight - 128);
            this.mDrawGraphics = new Sprite();
            this.mDrawGraphicsMatrix = new Matrix(1, 0, 0, 1, Stage2D.stageWidth - 5);
            this.mDrawGraphics.graphics.lineStyle(3, 4294901760);
            this.mGridLine.width = Stage2D.stageWidth;
            this.mGridLine.height = 1;
            this.bitmapData = this.mBitmapBackgroundData;
            var _loc_3:* = Stage2D.stageWidth;
            var _loc_4:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_5:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.RIGHT);
            var _loc_6:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mBlittingTextField = new TextField();
            this.mBlittingTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mBlittingTextField.defaultTextFormat = _loc_4;
            this.mBlittingTextField.selectable = false;
            this.mBlittingTextField.filters = [_loc_6];
            this.mBlittingTextFieldARight = new TextField();
            this.mBlittingTextFieldARight.autoSize = TextFieldAutoSize.RIGHT;
            this.mBlittingTextFieldARight.defaultTextFormat = _loc_5;
            this.mBlittingTextFieldARight.selectable = false;
            this.mBlittingTextFieldARight.filters = [_loc_6];
            this.mTextFieldMaxMemGraphARight = new TextField();
            this.mTextFieldMaxMemGraphARight.autoSize = TextFieldAutoSize.LEFT;
            this.mTextFieldMaxMemGraphARight.defaultTextFormat = _loc_4;
            this.mTextFieldMaxMemGraphARight.selectable = false;
            this.mTextFieldMaxMemGraphARight.filters = [_loc_6];
            this.mBlittingTextFieldMatrix = new Matrix();
            this.fps = Stage2D.frameRate;
            stats.MemoryFree = System.freeMemory / 1024;
            stats.MemoryPrivate = System.privateMemory / 1024;
            stats.MemoryCurrent = System.totalMemory / 1024;
            this.statsLastFrame.Copy(stats);
            this.mCurrentMaxMemGraph = stats.MemoryCurrent;
            return;
        }// end function

        public function Update() : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            this.timer = getTimer();
            var _loc_1:* = this.timer - this.mLastTime;
            var _loc_8:String = this;
            var _loc_9:* = this.fps + 1;
            _loc_8.fps = _loc_9;
            if (_loc_1 < 1000 / Commands.RefreshRate)
            {
                return;
            }
            stats.FpsCurrent = this.fps * (1000 / _loc_1);
            this.mLastTime = this.timer;
            this.mBitmapBackgroundData.fillRect(this.mBitmapBackgroundData.rect, SkinManager.COLOR_GLOBAL_BG);
            stats.MemoryFree = System.freeMemory / 1024;
            stats.MemoryPrivate = System.privateMemory / 1024;
            stats.MemoryCurrent = System.totalMemory / 1024;
            this.mTextFieldMaxMemGraphARight.text = stats.MemoryMax.toString();
            if (stats.MemoryCurrent < stats.MemoryMin)
            {
                stats.MemoryMin = stats.MemoryCurrent;
            }
            if (stats.MemoryCurrent > stats.MemoryMax)
            {
                stats.MemoryMax = stats.MemoryCurrent;
            }
            if (stats.FpsCurrent < stats.FpsMin)
            {
                stats.FpsMin = stats.FpsCurrent;
            }
            if (stats.FpsCurrent > stats.FpsMax)
            {
                stats.FpsMax = stats.FpsCurrent;
            }
            this.mBlittingTextFieldMatrix.identity();
            this.mBlittingTextFieldMatrix.ty = 20;
            if (Configuration.PROFILE_MEMGRAPH)
            {
                this.mDrawGraphics.graphics.clear();
                _loc_2 = stage.stageWidth / mSamplingCount;
                _loc_3 = 0;
                _loc_4 = 0;
                _loc_5 = 0;
                this.mDrawGraphics.graphics.lineStyle(5, 4294901760);
                _loc_6 = mSamplingStartIdx;
                _loc_7 = mSamplingCount * _loc_2;
                this.mDrawGraphics.graphics.moveTo(_loc_7, 0);
                _loc_3 = 0;
                while (_loc_3 < mSamplingCount)
                {
                    
                    _loc_4 = mMemoryMaxValues[_loc_6 % mSamplingCount];
                    _loc_6 = _loc_6 + 1;
                    if (_loc_4 == -1)
                    {
                    }
                    else
                    {
                        _loc_5 = 127 - _loc_4 / stats.MemoryMax * 148;
                        if (_loc_5 < 0)
                        {
                            _loc_5 = 0;
                        }
                        if (_loc_5 > 127)
                        {
                            _loc_5 = 127;
                        }
                        this.mDrawGraphics.graphics.lineTo(_loc_7, _loc_5);
                        _loc_7 = _loc_7 - _loc_2;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                this.mDrawGraphics.graphics.lineStyle(1, 4294967295);
                _loc_6 = mSamplingStartIdx;
                _loc_7 = mSamplingCount * _loc_2;
                _loc_3 = 0;
                while (_loc_3 < mSamplingCount)
                {
                    
                    _loc_4 = mMemoryGC[_loc_6 % mSamplingCount];
                    _loc_6 = _loc_6 + 1;
                    _loc_7 = _loc_7 - _loc_2;
                    if (_loc_4 == -1)
                    {
                    }
                    else
                    {
                        _loc_5 = _loc_4 / stats.MemoryMax * 128;
                        this.mDrawGraphics.graphics.moveTo(_loc_7, 64 - (_loc_5 / 2 + 1));
                        this.mDrawGraphics.graphics.lineTo(_loc_7, 64 + (_loc_5 / 2 + 1));
                    }
                    _loc_3 = _loc_3 + 1;
                }
                this.mDrawGraphics.graphics.lineStyle(3, SkinManager.COLOR_STATS_CURRENT);
                _loc_6 = mSamplingStartIdx;
                _loc_7 = mSamplingCount * _loc_2;
                this.mDrawGraphics.graphics.moveTo(_loc_7, 128);
                _loc_3 = 0;
                while (_loc_3 < mSamplingCount)
                {
                    
                    _loc_4 = mMemoryValues[_loc_6 % mSamplingCount];
                    _loc_6 = _loc_6 + 1;
                    if (_loc_4 == -1)
                    {
                    }
                    else
                    {
                        _loc_5 = 128 - _loc_4 / stats.MemoryMax * 126;
                        this.mDrawGraphics.graphics.lineTo(_loc_7, _loc_5);
                        _loc_7 = _loc_7 - _loc_2;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                this.mMemoryUseBitmapData.fillRect(this.mMemoryUseBitmapData.rect, SkinManager.COLOR_STATS_BG);
                this.mMemoryUseBitmapData.draw(this.mDrawGraphics);
            }
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_FS_Current;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_FS_Min;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMaxColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_FS_Max;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_fps;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.FpsCurrent.toString() + " / " + Stage2D.frameRate;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.FpsMin.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMaxColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.FpsMax.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_TotalMemoryKo;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.MemoryCurrent.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.MemoryMin.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMaxColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.MemoryMax.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_FreeMemoryKo;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.MemoryFree.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_PrivateMemoryKo;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = stats.MemoryPrivate.toString();
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_FlashVersion;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = Capabilities.version;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
            this.mBlittingTextFieldARight.text = Capabilities.isDebugger ? (Localization.Lbl_FS_Debug) : (Localization.Lbl_FS_Release);
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_AVMVersion;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = System.vmVersion;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_TheMinerVersion;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = "1.4.01";
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
            this.mBlittingTextFieldARight.text = "NC";
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_FS_StageSize;
            this.bitmapData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = this.stage.stageWidth + " x " + this.stage.stageHeight;
            this.bitmapData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.bitmapData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            this.Render();
            this.statsLastFrame.Copy(stats);
            this.fps = 0;
            return;
        }// end function

        private function Render() : void
        {
            this.bitmapData.copyPixels(this.mMemoryUseBitmapData, this.mMemoryUseBitmapData.rect, this.mGraphPos);
            this.mBitmapBackgroundData.copyPixels(SkinManager.mSkinBitmapData, SkinManager.mDebugGraphScrollRect, this.mGraphPos);
            this.mBlittingTextFieldMatrix.tx = Stage2D.stageWidth - this.mTextFieldMaxMemGraphARight.textWidth - 5;
            this.mBlittingTextFieldMatrix.ty = Stage2D.stageHeight - this.mMemoryUseBitmapData.rect.height - 15;
            this.bitmapData.draw(this.mTextFieldMaxMemGraphARight, this.mBlittingTextFieldMatrix);
            this.alpha = Commands.Opacity / 10;
            return;
        }// end function

        public function Dispose() : void
        {
            Configuration.PROFILE_MEMGRAPH = this.mProfilerWasActive;
            Analytics.Track("Tab", "FlashStats", "FlashStats Exit", int((getTimer() - this.mEnterTime) / 1000));
            this.mMemoryUseBitmapData.dispose();
            this.mMemoryUseBitmapData = null;
            this.mBitmapBackgroundData.dispose();
            this.mBitmapBackgroundData = null;
            this.mBitmapBackground = null;
            this.mGridLine = null;
            this.mBlittingTextField = null;
            this.mBlittingTextFieldARight = null;
            this.mBlittingTextFieldMatrix = null;
            this.mTextFieldMaxMemGraphARight = null;
            this.statsLastFrame = null;
            this.mDrawGraphics = null;
            this.mDrawGraphicsMatrix = null;
            this.mGraphPos = null;
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

        private static function InitStatic() : Boolean
        {
            mMemoryValues = new Vector.<int>(mSamplingCount);
            mMemoryMaxValues = new Vector.<int>(mSamplingCount);
            mMemoryGC = new Vector.<int>(mSamplingCount);
            var _loc_1:int = 0;
            while (_loc_1 < mSamplingCount)
            {
                
                mMemoryValues[_loc_1] = -1;
                mMemoryMaxValues[_loc_1] = -1;
                mMemoryGC[_loc_1] = -1;
                _loc_1 = _loc_1 + 1;
            }
            return true;
        }// end function

    }
}
