package com.sociodox.theminer.window
{
    import __AS3__.vec.*;
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

    public class UserEvent extends Sprite implements IWindow
    {
        private var mBitmapBackgroundData:BitmapData = null;
        private var mBitmapLineData:BitmapData = null;
        private var mBitmapBackground:Bitmap = null;
        private var mBitmapLine:Bitmap = null;
        private var mGridLine:Rectangle = null;
        private var mProgressCenterPosition:int = 2;
        private var mAddedColumnStartPos:int = 250;
        private var mTextColumn:int = 280;
        private var mUserData2Column:int = 280;
        private var mCurrentColumnStartPos:int = 370;
        private var mUserData1Column:int = 430;
        private var mBlittingTextField:TextField;
        private var mBlittingTextFieldCenter:TextField;
        private var mBlittingTextFieldARight:TextField;
        private var mBlittingTextFieldMatrix:Matrix = null;
        private var mSaveSnapshotButton:MenuButton;
        private var mActivateFilterButton:MenuButton;
        private var frameCount:int = 0;
        private var mLastTime:int = 0;
        private var mStackButtonArray:Array;
        private var mEnterTime:int = 0;
        private var mFilterText:TextField;
        private var mEventMgr:UserEventManager = null;
        private var mLastLen:int = 0;
        private var mLastAlpha:Number = 1;
        private var mProgressBarRect:Rectangle;
        public static const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";
        public static const LOADER_STREAM:String = Localization.Lbl_L_URLStream;
        public static const LOADER_URLLOADER:String = Localization.Lbl_L_URLLoader;
        public static const LOADER_DISPLAY_LOADER:String = Localization.Lbl_L_Loader;
        public static const LOADER_COMPLETED:String = Localization.Lbl_L_Success;
        public static const LOADER_NOT_COMPLETED:String = Localization.Lbl_L_Failed;
        private static const DEFAULT_TEXT:String = "-";
        public static const SAVE_FUNCTION_STACK_EVENT:String = "saveFunctionStackEvent";
        private static const ZERO_PERCENT:String = "0.00";
        private static const COLUMN_HEADER_PROGRESS:String = Localization.Lbl_UserEvents_Status;
        private static const COLUMN_HEADER_URL:String = Localization.Lbl_UserEvents_Info;
        private static const COLUMN_HEADER_STATUS:String = Localization.Lbl_UserEvents_Value1;
        private static const COLUMN_HEADER_SIZE:String = Localization.Lbl_UserEvents_Value2;
        private static const NEW_LINE:String = "\n";

        public function UserEvent()
        {
            this.mProgressBarRect = new Rectangle(20, 0, 100, 11);
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "UserEvent", "UserEvent Enter");
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
            this.mBitmapLine.y = -20;
            addChild(this.mBitmapBackground);
            addChild(this.mBitmapLine);
            this.mouseEnabled = false;
            this.mGridLine.width = Stage2D.stageWidth;
            this.mGridLine.height = 1;
            this.mProgressCenterPosition = 20;
            this.mUserData1Column = 70;
            this.mUserData2Column = 130;
            this.mTextColumn = 235;
            this.mAddedColumnStartPos = 100;
            var _loc_2:* = Stage2D.stageWidth;
            var _loc_3:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_4:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, true);
            var _loc_5:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.RIGHT);
            var _loc_6:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.CENTER);
            var _loc_7:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mBlittingTextField = new TextField();
            this.mBlittingTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mBlittingTextField.defaultTextFormat = _loc_3;
            this.mBlittingTextField.selectable = false;
            this.mBlittingTextField.filters = [_loc_7];
            this.mBlittingTextFieldARight = new TextField();
            this.mBlittingTextFieldARight.autoSize = TextFieldAutoSize.RIGHT;
            this.mBlittingTextFieldARight.defaultTextFormat = _loc_5;
            this.mBlittingTextFieldARight.selectable = false;
            this.mBlittingTextFieldARight.filters = [_loc_7];
            this.mBlittingTextFieldCenter = new TextField();
            this.mBlittingTextFieldCenter.autoSize = TextFieldAutoSize.CENTER;
            this.mBlittingTextFieldCenter.defaultTextFormat = _loc_6;
            this.mBlittingTextFieldCenter.selectable = false;
            this.mBlittingTextFieldCenter.filters = [_loc_7];
            this.mBlittingTextFieldMatrix = new Matrix();
            var _loc_8:int = 21;
            this.mSaveSnapshotButton = new MenuButton(16, _loc_8, MenuButton.ICON_CAMERA, SAVE_SNAPSHOT_EVENT, -1, Localization.Lbl_MFP_SaveALLCurrentProfilerData, true, Localization.Lbl_MFP_Saved);
            addChild(this.mSaveSnapshotButton);
            addEventListener(SAVE_SNAPSHOT_EVENT, this.OnSaveSnapshot);
            this.mActivateFilterButton = new MenuButton(16 + 15, _loc_8, MenuButton.ICON_FILTER, null, -1, Localization.Lbl_L_ShowLoadersWithErrors, true, Localization.Lbl_Done);
            addChild(this.mActivateFilterButton);
            var _loc_9:* = (Stage2D.stageHeight - 25) / 15;
            this.mStackButtonArray = new Array();
            var _loc_10:int = 0;
            while (_loc_10 < _loc_9)
            {
                
                _loc_11 = new MenuButton(3, 37 + _loc_10 * 14, MenuButton.ICON_CLIPBOARD, SAVE_FUNCTION_STACK_EVENT, -1, "", true, Localization.Lbl_MFP_Saved);
                this.mStackButtonArray.push(_loc_11);
                addChild(_loc_11);
                _loc_11.visible = false;
                _loc_10 = _loc_10 + 1;
            }
            addEventListener(SAVE_FUNCTION_STACK_EVENT, this.OnSaveStack);
            this.mBlittingTextField.text = Localization.Lbl_LP_FileNameFilter;
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mBlittingTextFieldMatrix.tx = this.mTextColumn;
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
                if (Configuration.SAVED_FILTER_USEREVENT)
                {
                    this.mFilterText.text = Configuration.SAVED_FILTER_USEREVENT;
                }
            }
            this.mFilterText.height = 17;
            this.mFilterText.type = TextFieldType.INPUT;
            this.mFilterText.textColor = SkinManager.COLOR_GLOBAL_TEXT;
            this.mFilterText.defaultTextFormat = _loc_4;
            this.mFilterText.filters = [_loc_7];
            this.mFilterText.border = true;
            this.mFilterText.addEventListener(KeyboardEvent.KEY_DOWN, this.OnFilterComplete, false, 0, true);
            this.mFilterText.borderColor = SkinManager.COLOR_GLOBAL_LINE;
            addChild(this.mFilterText);
            return;
        }// end function

        public function SetManager(aUserMgr:UserEventManager) : void
        {
            this.mEventMgr = aUserMgr;
            return;
        }// end function

        private function OnFilterComplete(event:KeyboardEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            if (event.keyCode == Keyboard.ENTER)
            {
                stage.focus = stage;
            }
            if (Configuration.SAVE_FILTERS)
            {
                Configuration.SAVED_FILTER_USEREVENT = this.mFilterText.text;
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
            ToolTip.Text = Localization.Lbl_LP_FileNameFilter;
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

        private function OnSaveSnapshot(event:Event) : void
        {
            pauseSampling();
            if (this.mSaveSnapshotButton.mIsSelected)
            {
                this.SaveLoaderSnapshot();
                this.mSaveSnapshotButton.Reset();
            }
            startSampling();
            return;
        }// end function

        private function SaveLoaderSnapshot() : void
        {
            var _loc_4:UserEventEntry = null;
            var _loc_5:String = null;
            var _loc_1:* = this.mEventMgr.GetUserEvents();
            _loc_1.sort(this.EventSort);
            var _loc_2:* = new ByteArray();
            var _loc_3:* = _loc_1.length;
            _loc_5 = "Name";
            _loc_5 = _loc_5 + "\tValue1";
            _loc_5 = _loc_5 + "\tValue2";
            _loc_5 = _loc_5 + "\tInfo";
            _loc_5 = _loc_5 + "\tStatus";
            _loc_5 = _loc_5 + "\tProgress";
            _loc_5 = _loc_5 + "\tError\n";
            _loc_2.writeUTFBytes(_loc_5);
            for each (_loc_4 in _loc_1)
            {
                
                if (_loc_4 == null)
                {
                    continue;
                }
                _loc_5 = _loc_4.Name;
                _loc_5 = _loc_5 + ("\t" + _loc_4.Value1);
                _loc_5 = _loc_5 + ("\t" + _loc_4.Value1);
                _loc_5 = _loc_5 + ("\t" + _loc_4.Info);
                _loc_5 = _loc_5 + ("\t" + _loc_4.StatusLabel);
                _loc_5 = _loc_5 + ("\t" + _loc_4.StatusProgress);
                _loc_5 = _loc_5 + ("\t" + _loc_4.IsError + "\n");
                _loc_2.writeUTFBytes(_loc_5);
            }
            _loc_2.position = 0;
            System.setClipboard(_loc_2.readUTFBytes(_loc_2.length));
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
                    if (_loc_4.mUserEvent != null)
                    {
                        _loc_5 = "";
                        _loc_5 = _loc_5 + ("UserEvent::\tName: " + _loc_4.mUserEvent.Name);
                        _loc_5 = _loc_5 + (",\t Value1: " + _loc_4.mUserEvent.Value1);
                        _loc_5 = _loc_5 + (",\t Value2: " + _loc_4.mUserEvent.Value1);
                        _loc_5 = _loc_5 + (",\t mEventInfo: " + _loc_4.mUserEvent.Info);
                        _loc_5 = _loc_5 + (",\t StatusLabel: " + _loc_4.mUserEvent.StatusLabel);
                        _loc_5 = _loc_5 + (",\t StatusProgress: " + (int(_loc_4.mUserEvent.StatusProgress * 10000) / 100).toString() + Localization.Lbl_LA_Percent);
                        System.setClipboard(_loc_5);
                    }
                }
                if (_loc_4 != null)
                {
                    _loc_4.Reset();
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function Update() : void
        {
            var _loc_9:String = null;
            if (mouseY >= 40)
            {
            }
            if (mouseY < 40 + this.mLastLen * 14)
            {
                this.mBitmapLine.y = mouseY - mouseY % 14 - 3;
            }
            else
            {
                this.mBitmapLine.y = -20;
            }
            var _loc_1:* = getTimer() - this.mLastTime;
            if (_loc_1 < 1000 / Commands.RefreshRate)
            {
                return;
            }
            this.mLastTime = getTimer();
            this.mBitmapBackgroundData.fillRect(this.mBitmapBackgroundData.rect, SkinManager.COLOR_GLOBAL_BG);
            var _loc_2:* = this.mStackButtonArray.length;
            var _loc_3:int = 0;
            var _loc_4:* = this.mEventMgr.GetUserEvents();
            _loc_4.sort(this.EventSort);
            var _loc_5:* = _loc_4.length;
            _loc_2 = _loc_4.length;
            var _loc_6:* = (stage.stageHeight - 25) / 15;
            this.mBlittingTextFieldMatrix.identity();
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mBlittingTextFieldMatrix.tx = this.mProgressCenterPosition;
            this.mBlittingTextFieldCenter.text = COLUMN_HEADER_PROGRESS;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldCenter, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mTextColumn;
            this.mBlittingTextField.text = COLUMN_HEADER_URL;
            this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mUserData1Column;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_STATUS;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mUserData2Column;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_SIZE;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            var _loc_7:UserEventEntry = null;
            var _loc_8:int = -1;
            _loc_6 = Math.min(_loc_6, this.mStackButtonArray.length);
            _loc_3 = 0;
            while (_loc_3 < _loc_6)
            {
                
                this.mStackButtonArray[_loc_3].visible = false;
                _loc_3 = _loc_3 + 1;
            }
            _loc_3 = 0;
            while (_loc_3 < _loc_6)
            {
                
                _loc_8 = _loc_8 + 1;
                if (_loc_8 >= _loc_5)
                {
                    break;
                }
                _loc_7 = _loc_4[_loc_8];
                if (_loc_7.Visible == false)
                {
                    _loc_3 = _loc_3 - 1;
                }
                else
                {
                    if (this.mFilterText.text != "")
                    {
                        _loc_9 = this.mFilterText.text.toLowerCase();
                        if (_loc_7.Name != null)
                        {
                        }
                        if (_loc_7.Name.toLowerCase().indexOf(_loc_9) == -1)
                        {
                            if (_loc_7.Info != null)
                            {
                            }
                        }
                        if (_loc_7.Info.toLowerCase().indexOf(_loc_9) == -1)
                        {
                            _loc_3 = _loc_3 - 1;
                            ;
                        }
                    }
                    if (_loc_7.Id == -1)
                    {
                    }
                    else
                    {
                        if (this.mActivateFilterButton.mIsSelected)
                        {
                            if (!_loc_7.IsError)
                            {
                                _loc_3 = _loc_3 - 1;
                                ;
                            }
                        }
                        this.mStackButtonArray[_loc_3].visible = true;
                        this.DrawProgress(_loc_4[_loc_8], 38 + _loc_3 * 14);
                        if (this.mStackButtonArray[_loc_3].mUrl != _loc_7.Name)
                        {
                            this.mStackButtonArray[_loc_3].SetToolTipText(Localization.Lbl_FP_ClickCopyToClipboard);
                            this.mStackButtonArray[_loc_3].mUrl = _loc_7.Name;
                            this.mStackButtonArray[_loc_3].mUserEvent = _loc_7;
                        }
                        else if (_loc_7.IsError)
                        {
                            this.mStackButtonArray[_loc_3].mUserEvent = _loc_7;
                            this.mStackButtonArray[_loc_3].mUrl = _loc_7.Name;
                            this.mStackButtonArray[_loc_3].SetToolTipText(Localization.Lbl_FP_ClickCopyToClipboard + NEW_LINE + _loc_7.Name);
                        }
                        this.mBlittingTextFieldMatrix.tx = this.mProgressCenterPosition;
                        if (_loc_7.IsError)
                        {
                            this.mBlittingTextFieldCenter.text = "X";
                        }
                        else if (_loc_7.StatusLabel != null)
                        {
                            this.mBlittingTextFieldCenter.text = _loc_7.StatusLabel;
                        }
                        else if (_loc_7.StatusProgress == -1)
                        {
                            this.mBlittingTextFieldCenter.text = "";
                        }
                        else
                        {
                            this.mBlittingTextFieldCenter.text = (int(_loc_7.StatusProgress * 10000) / 100).toString() + Localization.Lbl_LA_Percent;
                        }
                        this.mBitmapBackgroundData.draw(this.mBlittingTextFieldCenter, this.mBlittingTextFieldMatrix);
                        this.mBlittingTextFieldMatrix.tx = this.mUserData1Column;
                        if (_loc_7.Value1 == null)
                        {
                            this.mBlittingTextFieldARight.text = "";
                        }
                        else
                        {
                            this.mBlittingTextFieldARight.text = _loc_7.Value1;
                        }
                        this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                        this.mBlittingTextFieldMatrix.tx = this.mUserData2Column;
                        if (_loc_7.Value2 == null)
                        {
                            this.mBlittingTextFieldARight.text = "";
                        }
                        else
                        {
                            this.mBlittingTextFieldARight.text = _loc_7.Value2;
                        }
                        this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                        this.mBlittingTextFieldMatrix.tx = this.mTextColumn;
                        if (_loc_7.Name == null)
                        {
                            this.mBlittingTextField.text = UserEvent.DEFAULT_TEXT;
                        }
                        else if (_loc_7.Info)
                        {
                            this.mBlittingTextField.text = _loc_7.Name + " :: " + _loc_7.Info;
                        }
                        else
                        {
                            this.mBlittingTextField.text = _loc_7.Name;
                        }
                        this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
                        this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
                        this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
                        this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            this.Render();
            return;
        }// end function

        private function EventSort(aEntryA:UserEventEntry, aEntryB:UserEventEntry) : int
        {
            if (aEntryA.Priority > aEntryB.Priority)
            {
                return -1;
            }
            if (aEntryA.Priority < aEntryB.Priority)
            {
                return 1;
            }
            if (aEntryA.Id > aEntryB.Id)
            {
                return -1;
            }
            if (aEntryA.Id < aEntryB.Id)
            {
                return 1;
            }
            return 0;
        }// end function

        private function Render() : void
        {
            var _loc_1:* = Commands.Opacity / 10;
            if (_loc_1 != this.mLastAlpha)
            {
                this.mLastAlpha = _loc_1;
                this.alpha = _loc_1;
            }
            return;
        }// end function

        private function DrawProgress(uee:UserEventEntry, positionY:int) : void
        {
            var _loc_4:Number = NaN;
            this.mProgressBarRect.y = positionY;
            this.mProgressBarRect.width = 100;
            var _loc_3:* = SkinManager.COLOR_LOADER_DISPLAYLOADER_COMPLETED;
            if (uee.IsError)
            {
                _loc_3 = SkinManager.COLOR_LOADER_FALIED;
            }
            else if (uee.StatusProgress == -1)
            {
                _loc_3 = uee.StatusColor;
                this.mProgressBarRect.width = 100;
            }
            else
            {
                _loc_3 = uee.StatusColor;
                _loc_4 = uee.StatusProgress;
                if (_loc_4 > 1)
                {
                    _loc_4 = 1;
                }
                this.mProgressBarRect.width = 100 * _loc_4;
            }
            this.mBitmapBackgroundData.fillRect(this.mProgressBarRect, _loc_3);
            return;
        }// end function

        public function Dispose() : void
        {
            var _loc_1:MenuButton = null;
            if (this.mFilterText)
            {
                this.mFilterText.removeEventListener(KeyboardEvent.KEY_DOWN, this.OnFilterComplete);
            }
            for each (_loc_1 in this.mStackButtonArray)
            {
                
                _loc_1.Dispose();
            }
            Analytics.Track("Tab", "UserEvent", "UserEvent Exit", int((getTimer() - this.mEnterTime) / 1000));
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
            this.mBitmapBackground = null;
            this.mBitmapLine = null;
            this.mGridLine = null;
            this.mBlittingTextFieldCenter = null;
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
