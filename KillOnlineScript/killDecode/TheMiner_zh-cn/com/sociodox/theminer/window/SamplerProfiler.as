package com.sociodox.theminer.window
{
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.manager.*;
    import com.sociodox.theminer.ui.*;
    import com.sociodox.theminer.ui.button.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.sampler.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class SamplerProfiler extends Sprite implements IWindow
    {
        private var mBitmapBackgroundData:BitmapData = null;
        private var mBitmapLineData:BitmapData = null;
        private var mBitmapBackground:Bitmap = null;
        private var mBitmapLine:Bitmap = null;
        private var mGridLine:Rectangle = null;
        private var mClassPathColumnStartPos:int = 2;
        private var mAddedColumnStartPos:int = 250;
        private var mDeletedColumnStartPos:int = 300;
        private var mCurrentColumnStartPos:int = 370;
        private var mCumulColumnStartPos:int = 430;
        private var mBlittingTextField:TextField;
        private var mBlittingTextFieldARight:TextField;
        private var mBlittingTextFieldMatrix:Matrix = null;
        private var frameCount:int = 0;
        private var mLastTime:int = 0;
        private var mProfilerWasActive:Boolean = false;
        private var mEnterTime:int = 0;
        private var mPerFrame:MenuButton;
        private var mSaveSnapshotButton:MenuButton;
        private var mClearButton:MenuButton;
        private var mPauseButton:MenuButton;
        private var mCurrentSortButton:MenuButton;
        private var mCumulSortButton:MenuButton;
        private var mUseCumulSort:Boolean = true;
        private var mTempWidthTextfield:TextField;
        private var mFilterText:TextField;
        private var mLastLen:int = 0;
        private const SORT_ON_CUMUL:String = "Cumul";
        private const SORT_ON_CURRENT:String = "Current";
        private var mLastAlloc:int = 0;
        private var mLastCollect:int = 0;
        private var mLastGain:int = 0;
        private var mLastLost:int = 0;
        private var mLastDiff:int = 0;
        private var mLastHolder:ClassTypeStatsHolder;
        private var mLastHolders:Array;
        public static const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";

        public function SamplerProfiler()
        {
            this.mLastHolders = new Array();
            this.mProfilerWasActive = Configuration.PROFILE_MEMORY;
            Configuration.PROFILE_MEMORY = true;
            this.mTempWidthTextfield = new TextField();
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "MemoryProfiler", "MemoryProfiler Enter");
            return;
        }// end function

        private function Init() : void
        {
            this.mGridLine = new Rectangle();
            this.mouseEnabled = false;
            this.mBitmapBackgroundData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mBitmapBackground = new Bitmap(this.mBitmapBackgroundData);
            this.mGridLine.width = Stage2D.stageWidth;
            this.mGridLine.height = 1;
            this.mBitmapLineData = new BitmapData(Stage2D.stageWidth, 13, true, SkinManager.COLOR_SELECTION_OVERLAY);
            this.mBitmapLine = new Bitmap(this.mBitmapLineData);
            this.mBitmapLine.alpha = 0.7;
            this.mBitmapLine.y = -20;
            addChild(this.mBitmapBackground);
            addChild(this.mBitmapLine);
            this.mCumulColumnStartPos = Stage2D.stageWidth - 110;
            this.mCurrentColumnStartPos = this.mCumulColumnStartPos - 80;
            this.mDeletedColumnStartPos = this.mCurrentColumnStartPos - 80;
            this.mAddedColumnStartPos = this.mDeletedColumnStartPos - 80;
            var _loc_1:int = 23;
            var _loc_2:int = 16;
            this.mPauseButton = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_2, _loc_1, MenuButton.ICON_PAUSE, null, -1, Localization.Lbl_MFP_PauseRefresh, true, Localization.Lbl_MFP_ResumeRefresh);
            addChild(this.mPauseButton);
            _loc_2 = _loc_2 + 16;
            this.mClearButton = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_2, _loc_1, MenuButton.ICON_CLEAR, null, -1, Localization.Lbl_MFP_ClearCurrentData, true, Localization.Lbl_MFP_DataCleared);
            addChild(this.mClearButton);
            _loc_2 = _loc_2 + 16;
            this.mSaveSnapshotButton = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_2, _loc_1, MenuButton.ICON_CAMERA, SAVE_SNAPSHOT_EVENT, -1, Localization.Lbl_MFP_SaveALLCurrentProfilerData, true, Localization.Lbl_MFP_Saved);
            addChild(this.mSaveSnapshotButton);
            addEventListener(SAVE_SNAPSHOT_EVENT, this.OnSaveSnapshot, false, 0, true);
            _loc_2 = _loc_2 + 9;
            this.mPerFrame = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_2, _loc_1, MenuButton.ICON_MEMORY, null, -1, Localization.Lbl_RequirePro + "\n" + Localization.Lbl_MFP_AvgPerFrame, true);
            addChild(this.mPerFrame);
            _loc_2 = _loc_2 + 16;
            var _loc_3:* = Stage2D.stageWidth;
            var _loc_4:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_5:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, true);
            var _loc_6:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.RIGHT);
            var _loc_7:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mTempWidthTextfield.defaultTextFormat = _loc_4;
            this.mTempWidthTextfield.filters = [_loc_7];
            this.mTempWidthTextfield.text = Localization.Lbl_MP_HEADERS_CURRENT;
            this.mCurrentSortButton = new MenuButton(this.mCumulColumnStartPos - this.mTempWidthTextfield.textWidth, _loc_1, MenuButton.ICON_ARROW_DOWN, null, -1, Localization.Lbl_MFP_Sort, true, "");
            addChild(this.mCurrentSortButton);
            this.mTempWidthTextfield.text = Localization.Lbl_MP_HEADERS_CUMUL;
            this.mCumulSortButton = new MenuButton(Stage2D.stageWidth - this.mTempWidthTextfield.textWidth - 30, _loc_1, MenuButton.ICON_ARROW_DOWN, null, -1, Localization.Lbl_MFP_Sort, true, "");
            addChild(this.mCumulSortButton);
            this.mBlittingTextField = new TextField();
            this.mBlittingTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mBlittingTextField.defaultTextFormat = _loc_4;
            this.mBlittingTextField.selectable = false;
            this.mBlittingTextField.filters = [_loc_7];
            this.mBlittingTextField.mouseEnabled = false;
            this.mBlittingTextFieldARight = new TextField();
            this.mBlittingTextFieldARight.autoSize = TextFieldAutoSize.RIGHT;
            this.mBlittingTextFieldARight.defaultTextFormat = _loc_6;
            this.mBlittingTextFieldARight.selectable = false;
            this.mBlittingTextFieldARight.filters = [_loc_7];
            this.mBlittingTextFieldARight.mouseEnabled = false;
            this.mBlittingTextFieldMatrix = new Matrix();
            this.mBlittingTextField.text = Localization.Lbl_MP_HEADERS_QNAME;
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
            this.mFilterText = new TextField();
            this.mFilterText.addEventListener(MouseEvent.MOUSE_MOVE, this.OnFilterMouseMove, false, 0, true);
            this.mFilterText.addEventListener(MouseEvent.MOUSE_OVER, this.OnFilterMouseOver, false, 0, true);
            this.mFilterText.addEventListener(MouseEvent.MOUSE_OUT, this.OnFilterMouseOut, false, 0, true);
            this.mFilterText.selectable = true;
            this.mFilterText.backgroundColor = 4282664004;
            this.mFilterText.background = true;
            this.mFilterText.x = this.mBlittingTextFieldMatrix.tx + this.mBlittingTextField.textWidth + 10;
            this.mFilterText.y = this.mBlittingTextFieldMatrix.ty - 2;
            this.mFilterText.text = "";
            if (Configuration.SAVE_FILTERS)
            {
                if (Configuration.SAVED_FILTER_MEMORY != null)
                {
                    this.mFilterText.text = Configuration.SAVED_FILTER_MEMORY;
                }
            }
            this.mFilterText.height = 17;
            this.mFilterText.type = TextFieldType.INPUT;
            this.mFilterText.textColor = SkinManager.COLOR_GLOBAL_TEXT;
            this.mFilterText.defaultTextFormat = _loc_5;
            this.mFilterText.filters = [_loc_7];
            this.mFilterText.border = true;
            this.mFilterText.backgroundColor = 4282664004;
            this.mFilterText.background = true;
            this.mFilterText.borderColor = SkinManager.COLOR_GLOBAL_LINE_DARK;
            addChild(this.mFilterText);
            this.mCumulSortButton.OnClick(null);
            this.mUseCumulSort = true;
            return;
        }// end function

        private function OnFilterExit(event:KeyboardEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            if (event.keyCode == Keyboard.ENTER)
            {
                stage.focus = stage;
            }
            return;
        }// end function

        private function OnFilterComplete(event:Event) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            if (Configuration.SAVE_FILTERS)
            {
                Configuration.SAVED_FILTER_MEMORY = this.mFilterText.text;
                Configuration.Save();
            }
            return;
        }// end function

        private function OnFilterMouseMove(event:MouseEvent) : void
        {
            ToolTip.SetPosition(event.stageX + 12, event.stageY + 6);
            event.stopPropagation();
            event.stopImmediatePropagation();
            return;
        }// end function

        public function OnFilterMouseOver(event:MouseEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            ToolTip.Text = Localization.Lbl_MP_QNameFilter;
            ToolTip.Visible = true;
            return;
        }// end function

        public function OnFilterMouseOut(event:MouseEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            ToolTip.Visible = false;
            return;
        }// end function

        public function Update() : void
        {
            var _loc_2:ClassTypeStatsHolder = null;
            var _loc_11:String = null;
            if (this.mClearButton != null)
            {
            }
            if (this.mClearButton.mIsSelected)
            {
                SampleAnalyzer.ResetMemoryStats();
                this.mClearButton.Reset();
            }
            if (this.mUseCumulSort)
            {
            }
            if (this.mCurrentSortButton.mIsSelected)
            {
                this.mUseCumulSort = false;
                this.mCumulSortButton.Reset();
            }
            else
            {
                if (!this.mUseCumulSort)
                {
                }
                if (this.mCumulSortButton.mIsSelected)
                {
                    this.mUseCumulSort = true;
                    this.mCurrentSortButton.Reset();
                }
            }
            var _loc_1:int = -1;
            if (mouseY >= 38)
            {
            }
            if (mouseY < 38 + this.mLastLen * 14)
            {
                _loc_1 = mouseY - (mouseY + 5) % 14;
                this.mBitmapLine.y = _loc_1;
            }
            else
            {
                this.mBitmapLine.y = -20;
            }
            _loc_1 = _loc_1 - 25;
            _loc_1 = _loc_1 / 14;
            var _loc_3:* = getTimer() - this.mLastTime;
            if (_loc_3 >= 1000 / Commands.RefreshRate)
            {
            }
            if (this.mPauseButton.mIsSelected)
            {
                return;
            }
            this.mLastHolders.length = 0;
            this.mLastTime = getTimer();
            if (_loc_2 != null)
            {
                this.mLastGain = _loc_2.AllocSize - this.mLastAlloc;
                this.mLastLost = _loc_2.CollectSize - this.mLastCollect;
                this.mLastAlloc = _loc_2.AllocSize;
                this.mLastCollect = _loc_2.CollectSize;
                this.mLastDiff = this.mLastAlloc - this.mLastCollect;
            }
            this.mBitmapBackgroundData.fillRect(this.mBitmapBackgroundData.rect, SkinManager.COLOR_GLOBAL_BG);
            var _loc_4:* = SampleAnalyzer.GetClassInstanciationStats();
            if (this.mUseCumulSort)
            {
                _loc_4.sortOn(this.SORT_ON_CUMUL, Array.NUMERIC | Array.DESCENDING);
            }
            else
            {
                _loc_4.sortOn(this.SORT_ON_CURRENT, Array.NUMERIC | Array.DESCENDING);
            }
            var _loc_5:ClassTypeStatsHolder = null;
            var _loc_6:* = _loc_4.length;
            var _loc_7:* = _loc_4.length;
            var _loc_8:* = (stage.stageHeight - 25) / 15;
            if (_loc_6 > _loc_8)
            {
                _loc_6 = _loc_8;
            }
            this.mBlittingTextFieldMatrix.identity();
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mLastLen = _loc_6;
            this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
            this.mBlittingTextField.text = Localization.Lbl_MP_HEADERS_QNAME;
            this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_MP_HEADERS_ADD;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mPauseButton.x = this.mDeletedColumnStartPos - this.mBlittingTextFieldARight.textWidth;
            this.mClearButton.x = this.mPauseButton.x - 15;
            this.mSaveSnapshotButton.x = this.mClearButton.x - 15;
            this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_MP_HEADERS_DEL;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_MP_HEADERS_CURRENT;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
            this.mBlittingTextFieldARight.text = Localization.Lbl_MP_HEADERS_CUMUL;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            var _loc_9:int = -1;
            var _loc_10:int = 0;
            while (_loc_10 < _loc_6)
            {
                
                _loc_9 = _loc_9 + 1;
                if (_loc_9 >= _loc_7)
                {
                    break;
                }
                _loc_5 = _loc_4[_loc_9];
                if (_loc_5.Cumul == 0)
                {
                    _loc_10 = _loc_10 - 1;
                }
                else
                {
                    if (this.mFilterText.text != "")
                    {
                        this.mFilterText.backgroundColor = 4278207488;
                        _loc_11 = this.mFilterText.text.toLowerCase();
                        if (_loc_5.TypeName.toLowerCase().indexOf(_loc_11) == -1)
                        {
                            _loc_10 = _loc_10 - 1;
                        }
                    }
                    else
                    {
                        this.mFilterText.backgroundColor = 4282664004;
                    }
                    this.mLastHolders[_loc_10] = _loc_5;
                    this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
                    this.mBlittingTextField.text = _loc_5.TypeName;
                    this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
                    if (this.mPerFrame.mIsSelected)
                    {
                        Commands.BuyPro("AvgPerFrame");
                        this.mPerFrame.Reset();
                    }
                    this.mBlittingTextFieldARight.text = _loc_5.Added.toString();
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
                    if (this.mPerFrame.mIsSelected)
                    {
                        this.mBlittingTextFieldARight.text = (int(100 * _loc_5.Removed / SampleAnalyzer.mSamplerFrameCounter) / 100).toString();
                    }
                    else
                    {
                        this.mBlittingTextFieldARight.text = _loc_5.Removed.toString();
                    }
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
                    this.mBlittingTextFieldARight.text = _loc_5.Current.toString();
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
                    this.mBlittingTextFieldARight.text = _loc_5.Cumul.toString();
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    _loc_5.Added = 0;
                    _loc_5.Removed = 0;
                    _loc_5.AllocSize = 0;
                    _loc_5.CollectSize = 0;
                    this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
                    this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
                    this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
                }
                _loc_10 = _loc_10 + 1;
            }
            SampleAnalyzer.mSamplerFrameCounter = 0;
            this.Render();
            return;
        }// end function

        private function OnSaveSnapshot(event:Event) : void
        {
            pauseSampling();
            if (this.mSaveSnapshotButton.mIsSelected)
            {
                Commands.SaveMemorySnapshot(true);
                this.mSaveSnapshotButton.Reset();
            }
            startSampling();
            return;
        }// end function

        private function Render() : void
        {
            this.alpha = Commands.Opacity / 10;
            return;
        }// end function

        public function Dispose() : void
        {
            if (this.mFilterText)
            {
                this.mFilterText.removeEventListener(KeyboardEvent.KEY_DOWN, this.OnFilterExit);
                this.mFilterText.removeEventListener(Event.CHANGE, this.OnFilterComplete);
            }
            Configuration.PROFILE_MEMORY = this.mProfilerWasActive;
            if (!this.mProfilerWasActive)
            {
                SampleAnalyzer.ResetMemoryStats();
            }
            Analytics.Track("Tab", "MemoryProfiler", "MemoryProfiler Exit", int((getTimer() - this.mEnterTime) / 1000));
            this.mGridLine = null;
            this.mBlittingTextField = null;
            this.mBlittingTextFieldARight = null;
            this.mBlittingTextFieldMatrix = null;
            this.mBitmapBackgroundData.dispose();
            this.mBitmapBackgroundData = null;
            this.mBitmapBackground = null;
            this.mPerFrame.Dispose();
            this.mPerFrame = null;
            this.mCurrentSortButton.Dispose();
            this.mCurrentSortButton = null;
            this.mCumulSortButton.Dispose();
            this.mCumulSortButton = null;
            this.mBitmapLineData.dispose();
            this.mBitmapLineData = null;
            this.mBitmapLine = null;
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
