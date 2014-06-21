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
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class PerformanceProfiler extends Sprite implements IWindow
    {
        private var mBitmapBackgroundData:BitmapData = null;
        private var mBitmapLineData:BitmapData = null;
        private var mBitmapBackground:Bitmap = null;
        private var mBitmapLine:Bitmap = null;
        private var mGridLine:Rectangle = null;
        private var mClassPathColumnStartPos:int = 2;
        private var mAddedColumnStartPos:int = 250;
        private var mDeletedColumnStartPos:int = 280;
        private var mCurrentColumnStartPos:int = 370;
        private var mCumulColumnStartPos:int = 430;
        private var mBlittingTextField:TextField;
        private var mBlittingTextFieldARight:TextField;
        private var mBlittingTextFieldMatrix:Matrix = null;
        private var frameCount:int = 0;
        private var mLastTime:int = 0;
        private var mStackButtonArray:Array;
        private var mSelfSortButton:MenuButton;
        private var mTotalSortButton:MenuButton;
        private var mSaveSnapshotButton:MenuButton;
        private var mClearButton:MenuButton;
        private var mPerFrame:MenuButton;
        private var mPauseButton:MenuButton;
        private var mLastLen:int = 0;
        private var mUseSelfSort:Boolean = true;
        private var mProfilerWasActive:Boolean = false;
        private var mEnterTime:int = 0;
        private var mFilterText:TextField;
        private var mTempWidthTextfield:TextField;
        public static const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";
        public static const SAVE_FUNCTION_STACK_EVENT:String = "saveFunctionStackEvent";
        private static const ENTRY_TIME_PROPERTY:String = "entryTime";
        private static const ENTRY_TIME_TOTAL_PROPERTY:String = "entryTimeTotal";
        private static const ZERO_PERCENT:String = "0.00";
        private static const COLUMN_HEADER_FUNCTION_NAME:String = "[" + Localization.Lbl_FP_FunctionName + "]";
        private static const COLUMN_HEADER_PERCENTAGE:String = "(%)";
        private static const COLUMN_HEADER_SELF:String = "[" + Localization.Lbl_FP_Self + "] (µs)";
        private static const COLUMN_HEADER_TOTAL:String = "[" + Localization.Lbl_FP_Total + "] (µs)";
        private static const CLICK_COPY:String = "// " + Localization.Lbl_FP_ClickCopyToClipboard + "\n";

        public function PerformanceProfiler()
        {
            this.mTempWidthTextfield = new TextField();
            this.mProfilerWasActive = Configuration.PROFILE_FUNCTION;
            Configuration.PROFILE_FUNCTION = true;
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "FunctionProfiler", "FunctionProfiler Enter");
            return;
        }// end function

        private function OnFilterMouseMove(event:MouseEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            ToolTip.SetPosition(event.stageX + 12, event.stageY + 6);
            return;
        }// end function

        public function OnFilterMouseOver(event:MouseEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            ToolTip.Text = Localization.Lbl_FP_FunctionNameFilter;
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

        private function Init() : void
        {
            var _loc_11:MenuButton = null;
            this.mGridLine = new Rectangle();
            var _loc_1:int = 15;
            this.mBitmapBackgroundData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mBitmapBackground = new Bitmap(this.mBitmapBackgroundData);
            this.mBitmapLineData = new BitmapData(Stage2D.stageWidth, 13, true, SkinManager.COLOR_SELECTION_OVERLAY);
            this.mBitmapLine = new Bitmap(this.mBitmapLineData);
            this.mBitmapLine.alpha = 0.7;
            this.mBitmapLine.y = -20;
            addChild(this.mBitmapBackground);
            addChild(this.mBitmapLine);
            this.mouseEnabled = false;
            this.mGridLine.width = Stage2D.stageWidth;
            this.mGridLine.height = 1;
            this.mCumulColumnStartPos = Stage2D.stageWidth - 110;
            this.mCurrentColumnStartPos = this.mCumulColumnStartPos - 40;
            this.mDeletedColumnStartPos = this.mCurrentColumnStartPos - 100;
            this.mAddedColumnStartPos = this.mDeletedColumnStartPos - 40;
            var _loc_2:* = Stage2D.stageWidth;
            var _loc_3:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_4:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, true);
            var _loc_5:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.RIGHT);
            var _loc_6:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mBlittingTextField = new TextField();
            this.mBlittingTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mBlittingTextField.defaultTextFormat = _loc_3;
            this.mBlittingTextField.selectable = false;
            this.mBlittingTextField.filters = [_loc_6];
            this.mBlittingTextField.mouseEnabled = false;
            this.mBlittingTextFieldARight = new TextField();
            this.mBlittingTextFieldARight.autoSize = TextFieldAutoSize.RIGHT;
            this.mBlittingTextFieldARight.defaultTextFormat = _loc_5;
            this.mBlittingTextFieldARight.selectable = false;
            this.mBlittingTextFieldARight.filters = [_loc_6];
            this.mBlittingTextFieldARight.mouseEnabled = false;
            this.mBlittingTextFieldMatrix = new Matrix();
            var _loc_7:* = (Stage2D.stageHeight - 25) / 15;
            this.mStackButtonArray = new Array();
            var _loc_8:int = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_11 = new MenuButton(3, 37 + _loc_8 * 14, MenuButton.ICON_STACK, SAVE_FUNCTION_STACK_EVENT, -1, "", true, Localization.Lbl_MFP_Saved);
                this.mStackButtonArray.push(_loc_11);
                addChild(_loc_11);
                _loc_11.visible = false;
                _loc_8 = _loc_8 + 1;
            }
            addEventListener(SAVE_FUNCTION_STACK_EVENT, this.OnSaveStack);
            var _loc_9:int = 23;
            var _loc_10:int = 16;
            this.mPauseButton = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_10, _loc_9, MenuButton.ICON_PAUSE, null, -1, Localization.Lbl_MFP_PauseRefresh, true, Localization.Lbl_MFP_ResumeRefresh);
            addChild(this.mPauseButton);
            _loc_10 = _loc_10 + 16;
            this.mClearButton = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_10, _loc_9, MenuButton.ICON_CLEAR, null, -1, Localization.Lbl_MFP_ClearCurrentData, true, Localization.Lbl_MFP_DataCleared);
            addChild(this.mClearButton);
            _loc_10 = _loc_10 + 16;
            this.mSaveSnapshotButton = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_10, _loc_9, MenuButton.ICON_CAMERA, SAVE_SNAPSHOT_EVENT, -1, Localization.Lbl_MFP_SaveALLCurrentProfilerData, true, Localization.Lbl_MFP_Saved);
            addChild(this.mSaveSnapshotButton);
            _loc_10 = _loc_10 + 16;
            addEventListener(SAVE_SNAPSHOT_EVENT, this.OnSaveSnapshot);
            this.mPerFrame = new MenuButton(this.mDeletedColumnStartPos - 14 - _loc_10, _loc_9, MenuButton.ICON_PERFORMANCE, null, -1, Localization.Lbl_RequirePro + "\n" + Localization.Lbl_MFP_AvgPerFrame, true);
            addChild(this.mPerFrame);
            _loc_10 = _loc_10 + 16;
            this.mSelfSortButton = new MenuButton(this.mDeletedColumnStartPos - 14, _loc_9, MenuButton.ICON_ARROW_DOWN, null, -1, Localization.Lbl_FP_SortSelfTime, true, "");
            addChild(this.mSelfSortButton);
            this.mTotalSortButton = new MenuButton(this.mCumulColumnStartPos - 14, _loc_9, MenuButton.ICON_ARROW_DOWN, null, -1, Localization.Lbl_FP_SortTotalTime, true, "");
            addChild(this.mTotalSortButton);
            this.mBlittingTextField.text = Localization.Lbl_FP_FunctionName;
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
                if (Configuration.SAVED_FILTER_PERFORMANCE)
                {
                    this.mFilterText.text = Configuration.SAVED_FILTER_PERFORMANCE;
                }
            }
            this.mFilterText.height = 17;
            this.mFilterText.type = TextFieldType.INPUT;
            this.mFilterText.textColor = SkinManager.COLOR_GLOBAL_TEXT;
            this.mFilterText.defaultTextFormat = _loc_4;
            this.mFilterText.filters = [_loc_6];
            this.mFilterText.border = true;
            this.mFilterText.borderColor = SkinManager.COLOR_GLOBAL_LINE_DARK;
            addChild(this.mFilterText);
            this.mSelfSortButton.OnClick(null);
            this.mUseSelfSort = true;
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
                Configuration.SAVED_FILTER_PERFORMANCE = this.mFilterText.text;
                Configuration.Save();
            }
            return;
        }// end function

        private function OnSaveSnapshot(event:Event) : void
        {
            pauseSampling();
            if (this.mSaveSnapshotButton.mIsSelected)
            {
                Commands.SavePerformanceSnapshot(true);
                this.mSaveSnapshotButton.Reset();
            }
            startSampling();
            return;
        }// end function

        private function OnSaveStack(event:Event) : void
        {
            var _loc_4:MenuButton = null;
            var _loc_5:String = null;
            var _loc_2:* = this.mStackButtonArray.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this.mStackButtonArray[_loc_3];
                if (_loc_4 != null)
                {
                }
                if (_loc_4.mIsSelected)
                {
                    _loc_5 = String(_loc_4.mInternalEvent.mStackFrame);
                    while (_loc_5.indexOf(",") != -1)
                    {
                        
                        _loc_5 = _loc_5.replace(",", "\n");
                    }
                    System.setClipboard(_loc_5);
                }
                if (_loc_4 != null)
                {
                    _loc_4.Reset();
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function OnCopyStack(event:Event) : void
        {
            System.setClipboard(event.target.mInternalEvent.mStackFrame);
            return;
        }// end function

        public function Update() : void
        {
            var _loc_10:MenuButton = null;
            var _loc_11:Number = NaN;
            var _loc_12:String = null;
            if (this.mClearButton.mIsSelected)
            {
                SampleAnalyzer.ResetPerformanceStats();
                this.mClearButton.Reset();
            }
            if (this.mUseSelfSort)
            {
            }
            if (this.mTotalSortButton.mIsSelected)
            {
                this.mUseSelfSort = false;
                this.mSelfSortButton.Reset();
            }
            else
            {
                if (!this.mUseSelfSort)
                {
                }
                if (this.mSelfSortButton.mIsSelected)
                {
                    this.mUseSelfSort = true;
                    this.mTotalSortButton.Reset();
                }
            }
            if (mouseY >= 38)
            {
            }
            if (mouseY < 38 + this.mLastLen * 14)
            {
                this.mBitmapLine.y = mouseY - (mouseY + 5) % 14;
            }
            else
            {
                this.mBitmapLine.y = -20;
            }
            var _loc_1:* = getTimer() - this.mLastTime;
            if (_loc_1 >= 1000 / Commands.RefreshRate)
            {
            }
            if (this.mPauseButton.mIsSelected)
            {
                return;
            }
            this.mLastTime = getTimer();
            this.mBitmapBackgroundData.fillRect(this.mBitmapBackgroundData.rect, SkinManager.COLOR_GLOBAL_BG);
            var _loc_2:* = SampleAnalyzer.GetFunctionTimes();
            if (this.mUseSelfSort)
            {
                _loc_2.sortOn(ENTRY_TIME_PROPERTY, Array.NUMERIC | Array.DESCENDING);
            }
            else
            {
                _loc_2.sortOn(ENTRY_TIME_TOTAL_PROPERTY, Array.NUMERIC | Array.DESCENDING);
            }
            var _loc_3:* = this.mStackButtonArray.length;
            var _loc_4:* = _loc_2.length;
            var _loc_5:int = 0;
            var _loc_6:InternalEventEntry = null;
            _loc_3 = _loc_2.length;
            var _loc_7:int = 0;
            this.mLastLen = _loc_3;
            _loc_5 = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_6 = _loc_2[_loc_5];
                if (_loc_6.needSkip)
                {
                }
                else
                {
                    _loc_7 = _loc_7 + _loc_6.entryTime;
                }
                _loc_5 = _loc_5 + 1;
            }
            var _loc_8:* = (stage.stageHeight - 25) / 15;
            if (_loc_3 > _loc_8)
            {
                _loc_3 = _loc_8;
            }
            this.mBlittingTextFieldMatrix.identity();
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
            this.mBlittingTextField.text = COLUMN_HEADER_FUNCTION_NAME;
            this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_PERCENTAGE;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_SELF;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mTempWidthTextfield.text = COLUMN_HEADER_SELF;
            this.mSelfSortButton.x = this.mDeletedColumnStartPos - 18;
            this.mPauseButton.x = this.mSelfSortButton.x - 15;
            this.mClearButton.x = this.mPauseButton.x - 15;
            this.mSaveSnapshotButton.x = this.mClearButton.x - 15;
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_TOTAL;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_PERCENTAGE;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mTotalSortButton.x = this.mCumulColumnStartPos - 18;
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            _loc_5 = 0;
            while (_loc_5 < _loc_3)
            {
                
                if (_loc_5 >= this.mStackButtonArray.length)
                {
                    _loc_10 = new MenuButton(3, 37 + _loc_5 * 14, MenuButton.ICON_STACK, SAVE_FUNCTION_STACK_EVENT, -1, "", true, Localization.Lbl_MFP_Saved);
                    this.mStackButtonArray.push(_loc_10);
                    addChild(_loc_10);
                    _loc_10.visible = false;
                }
                else
                {
                    this.mStackButtonArray[_loc_5].visible = false;
                }
                _loc_5 = _loc_5 + 1;
            }
            var _loc_9:int = -1;
            _loc_5 = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_9 = _loc_9 + 1;
                if (_loc_9 >= _loc_4)
                {
                    break;
                }
                _loc_6 = _loc_2[_loc_9];
                if (_loc_6.needSkip)
                {
                    _loc_5 = _loc_5 - 1;
                }
                else
                {
                    if (this.mFilterText.text != "")
                    {
                        this.mFilterText.backgroundColor = 4278207488;
                        _loc_12 = this.mFilterText.text.toLowerCase();
                        if (_loc_6.qName.toLowerCase().indexOf(_loc_12) == -1)
                        {
                            _loc_5 = _loc_5 - 1;
                        }
                    }
                    else
                    {
                        this.mFilterText.backgroundColor = 4282664004;
                    }
                    this.mStackButtonArray[_loc_5].visible = true;
                    if (this.mStackButtonArray[_loc_5].mInternalEvent != _loc_6)
                    {
                        this.mStackButtonArray[_loc_5].SetToolTipText(CLICK_COPY + _loc_6.mStack);
                        this.mStackButtonArray[_loc_5].mInternalEvent = _loc_6;
                    }
                    this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos + 16;
                    this.mBlittingTextField.text = _loc_6.qName;
                    this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
                    _loc_11 = int(_loc_6.entryTime / _loc_7 * 10000) / 100;
                    if (_loc_11 == 0)
                    {
                        this.mBlittingTextFieldARight.text = ZERO_PERCENT;
                    }
                    else
                    {
                        this.mBlittingTextFieldARight.text = String(_loc_11);
                    }
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
                    if (this.mPerFrame.mIsSelected)
                    {
                        Commands.BuyPro("AvgPerFrame");
                        this.mPerFrame.Reset();
                    }
                    this.mBlittingTextFieldARight.text = _loc_6.entryTime.toString();
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
                    this.mBlittingTextFieldARight.text = _loc_6.entryTimeTotal.toString();
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
                    _loc_11 = int(_loc_6.entryTimeTotal / _loc_7 * 10000) / 100;
                    if (_loc_11 == 0)
                    {
                        this.mBlittingTextFieldARight.text = ZERO_PERCENT;
                    }
                    else
                    {
                        this.mBlittingTextFieldARight.text = String(_loc_11);
                    }
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
                    this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
                    this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
                }
                _loc_5 = _loc_5 + 1;
            }
            this.Render();
            return;
        }// end function

        private function Render() : void
        {
            if (this.alpha != Commands.Opacity / 10)
            {
                this.alpha = Commands.Opacity / 10;
            }
            return;
        }// end function

        public function Dispose() : void
        {
            var _loc_1:MenuButton = null;
            Configuration.PROFILE_FUNCTION = this.mProfilerWasActive;
            Analytics.Track("Tab", "FunctionProfiler", "FunctionProfiler Exit", int((getTimer() - this.mEnterTime) / 1000));
            if (!this.mProfilerWasActive)
            {
                SampleAnalyzer.ResetPerformanceStats();
            }
            for each (_loc_1 in this.mStackButtonArray)
            {
                
                _loc_1.Dispose();
            }
            this.mPerFrame.Dispose();
            this.mClearButton.Dispose();
            this.mSaveSnapshotButton.Dispose();
            removeChild(this.mClearButton);
            removeChild(this.mSaveSnapshotButton);
            this.mStackButtonArray = null;
            this.mGridLine = null;
            this.mBlittingTextField = null;
            this.mBlittingTextFieldARight = null;
            this.mBlittingTextFieldMatrix = null;
            this.mBitmapBackgroundData.dispose();
            this.mBitmapBackgroundData = null;
            this.mBitmapBackground = null;
            this.mBitmapLineData.dispose();
            this.mBitmapLineData = null;
            this.mBitmapLine = null;
            this.mSelfSortButton.Dispose();
            this.mSelfSortButton = null;
            this.mTotalSortButton.Dispose();
            this.mTotalSortButton = null;
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
