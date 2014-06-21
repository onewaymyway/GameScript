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

    public class LoaderProfiler extends Sprite implements IWindow
    {
        private var mBitmapBackgroundData:BitmapData = null;
        private var mBitmapLineData:BitmapData = null;
        private var mBitmapBackground:Bitmap = null;
        private var mBitmapLine:Bitmap = null;
        private var mGridLine:Rectangle = null;
        private var mProgressCenterPosition:int = 18;
        private var mAddedColumnStartPos:int = 266;
        private var mURLColPosition:int = 296;
        private var mSizeColPosition:int = 296;
        private var mCurrentColumnStartPos:int = 386;
        private var mHTTPStatusColPosition:int = 446;
        private var mBlittingTextField:TextField;
        private var mBlittingTextFieldCenter:TextField;
        private var mBlittingTextFieldARight:TextField;
        private var mBlittingTextFieldMatrix:Matrix = null;
        private var mSaveSnapshotButton:MenuButton;
        private var mActivateFilterButton:MenuButton;
        private var frameCount:int = 0;
        private var mLastTime:int = 0;
        private var mStackButtonArray:Array;
        private var mSaveButtonArray:Array;
        private var mLinkButtonArray:Array;
        private var mLoaderDict:Dictionary;
        private var mEnterTime:int = 0;
        private var mFilterText:TextField;
        private var mLastLen:int = 0;
        private var mProgressBarRect:Rectangle;
        public static const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";
        public static const LOADER_STREAM:String = Localization.Lbl_L_URLStream;
        public static const LOADER_URLLOADER:String = Localization.Lbl_L_URLLoader;
        public static const LOADER_DISPLAY_LOADER:String = Localization.Lbl_L_Loader;
        public static const LOADER_COMPLETED:String = Localization.Lbl_L_Success;
        public static const LOADER_NOT_COMPLETED:String = Localization.Lbl_L_Failed;
        private static const FIRST_EVENT_PROPERTY:String = "mFirstEvent";
        public static const SAVE_FUNCTION_STACK_EVENT:String = "saveFunctionStackEvent";
        public static const SAVE_FILE_EVENT:String = "saveFileEvent";
        public static const GO_TO_LINK:String = "GoToLink";
        private static const ZERO_PERCENT:String = "0.00";
        private static const SORT_ON_KEY:String = "mFirstEvent";
        private static const COLUMN_HEADER_PROGRESS:String = Localization.Lbl_L_Progress;
        private static const COLUMN_HEADER_URL:String = Localization.Lbl_L_Url;
        private static const COLUMN_HEADER_STATUS:String = Localization.Lbl_L_Status;
        private static const COLUMN_HEADER_SIZE:String = Localization.Lbl_L_Size;
        private static const NEW_LINE:String = "\n";

        public function LoaderProfiler()
        {
            this.mProgressBarRect = new Rectangle(20 + 16, 0, 100, 11);
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "LoaderProfiler", "LoaderProfiler Enter");
            return;
        }// end function

        private function Init() : void
        {
            var _loc_11:MenuButton = null;
            var _loc_12:MenuButton = null;
            var _loc_13:MenuButton = null;
            this.mGridLine = new Rectangle();
            var _loc_1:int = 15;
            this.mLoaderDict = new Dictionary(true);
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
            this.mProgressCenterPosition = 20 + 16;
            this.mHTTPStatusColPosition = 70 + 16;
            this.mSizeColPosition = 130 + 16;
            this.mURLColPosition = 235 + 16;
            this.mAddedColumnStartPos = 100 + 16;
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
            this.mSaveButtonArray = new Array();
            this.mLinkButtonArray = new Array();
            var _loc_10:int = 0;
            while (_loc_10 < _loc_9)
            {
                
                _loc_11 = new MenuButton(3, 37 + _loc_10 * 14, MenuButton.ICON_CLIPBOARD, SAVE_FUNCTION_STACK_EVENT, -1, "", true, Localization.Lbl_MFP_Saved);
                this.mStackButtonArray.push(_loc_11);
                addChild(_loc_11);
                _loc_11.visible = false;
                _loc_12 = new MenuButton(3 + 16, 37 + _loc_10 * 14, MenuButton.ICON_FLOPPY, SAVE_FILE_EVENT, -1, "", true);
                this.mSaveButtonArray.push(_loc_12);
                addChild(_loc_12);
                _loc_12.visible = false;
                _loc_13 = new MenuButton(3 + 16, 37 + _loc_10 * 14, MenuButton.ICON_LINK, GO_TO_LINK, -1, "", true);
                this.mLinkButtonArray.push(_loc_13);
                addChild(_loc_13);
                _loc_13.visible = false;
                _loc_10 = _loc_10 + 1;
            }
            addEventListener(SAVE_FUNCTION_STACK_EVENT, this.OnSaveStack);
            addEventListener(SAVE_FILE_EVENT, this.OnFileSave);
            addEventListener(GO_TO_LINK, this.OnGoTo);
            this.mBlittingTextField.text = Localization.Lbl_LP_FileNameFilter;
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mBlittingTextFieldMatrix.tx = this.mURLColPosition;
            this.mFilterText = new TextField();
            this.mFilterText.addEventListener(MouseEvent.MOUSE_MOVE, this.OnFilterMouseMove, false, 0, true);
            this.mFilterText.addEventListener(MouseEvent.MOUSE_OVER, this.OnFilterMouseOver, false, 0, true);
            this.mFilterText.addEventListener(MouseEvent.MOUSE_OUT, this.OnFilterMouseOut, false, 0, true);
            this.mFilterText.selectable = true;
            this.mFilterText.x = this.mBlittingTextFieldMatrix.tx + this.mBlittingTextField.textWidth + 10;
            this.mFilterText.y = this.mBlittingTextFieldMatrix.ty - 2;
            this.mFilterText.text = "";
            if (Configuration.SAVE_FILTERS)
            {
                if (Configuration.SAVED_FILTER_LOADER)
                {
                    this.mFilterText.text = Configuration.SAVED_FILTER_LOADER;
                }
            }
            this.mFilterText.height = 17;
            this.mFilterText.type = TextFieldType.INPUT;
            this.mFilterText.textColor = SkinManager.COLOR_GLOBAL_TEXT;
            this.mFilterText.defaultTextFormat = _loc_4;
            this.mFilterText.filters = [_loc_7];
            this.mFilterText.border = true;
            this.mFilterText.borderColor = SkinManager.COLOR_GLOBAL_LINE_DARK;
            this.mFilterText.backgroundColor = 4282664004;
            this.mFilterText.background = true;
            addChild(this.mFilterText);
            return;
        }// end function

        private function OnGoTo(event:Event) : void
        {
            var _loc_4:MenuButton = null;
            var _loc_2:* = this.mLinkButtonArray.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this.mLinkButtonArray[_loc_3];
                if (_loc_4 != null)
                {
                }
                if (_loc_4.mIsSelected)
                {
                }
                if (_loc_4.mLD)
                {
                    Commands.BuyPro("SWFSaver");
                }
                if (_loc_4 != null)
                {
                    _loc_4.Reset();
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function OnFileSave(event:Event) : void
        {
            var _loc_4:MenuButton = null;
            var _loc_2:* = this.mSaveButtonArray.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this.mSaveButtonArray[_loc_3];
                if (_loc_4 != null)
                {
                }
                if (_loc_4.mIsSelected)
                {
                }
                if (_loc_4.mLD)
                {
                }
                if (_loc_4.mLD.mLoadedData)
                {
                    Commands.BuyPro("SWFSaver");
                }
                if (_loc_4 != null)
                {
                    _loc_4.Reset();
                }
                _loc_3 = _loc_3 + 1;
            }
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
                Configuration.SAVED_FILTER_LOADER = this.mFilterText.text;
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
            var _loc_4:LoaderData = null;
            var _loc_1:* = LoaderAnalyser.GetInstance().GetLoadersData();
            _loc_1.sortOn(FIRST_EVENT_PROPERTY, Array.NUMERIC | Array.DESCENDING);
            var _loc_2:* = new ByteArray();
            var _loc_3:* = _loc_1.length;
            for each (_loc_4 in _loc_1)
            {
                
                if (_loc_4.mFirstEvent == -1)
                {
                    continue;
                }
                if (_loc_4.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_2.writeUTFBytes(LOADER_DISPLAY_LOADER);
                }
                else if (_loc_4.mType == LoaderData.URL_STREAM)
                {
                    _loc_2.writeUTFBytes(LOADER_STREAM);
                }
                else if (_loc_4.mType == LoaderData.URL_LOADER)
                {
                    _loc_2.writeUTFBytes(LOADER_URLLOADER);
                }
                _loc_2.writeByte(9);
                _loc_2.writeUTFBytes(_loc_4.mLoadedBytes.toString());
                _loc_2.writeByte(9);
                if (_loc_4.mIsFinished)
                {
                    _loc_2.writeUTFBytes(LOADER_COMPLETED);
                }
                else
                {
                    _loc_2.writeUTFBytes(LOADER_NOT_COMPLETED);
                }
                _loc_2.writeByte(9);
                if (_loc_4.mUrl == null)
                {
                    _loc_2.writeUTFBytes(Localization.Lbl_L_NoUrlFound);
                }
                else
                {
                    _loc_2.writeUTFBytes(_loc_4.mUrl);
                }
                _loc_2.writeByte(9);
                if (_loc_4.mIOError)
                {
                    _loc_2.writeByte(9);
                    _loc_2.writeUTFBytes(_loc_4.mIOError.toString());
                }
                if (_loc_4.mSecurityError)
                {
                    _loc_2.writeByte(9);
                    _loc_2.writeUTFBytes(_loc_4.mSecurityError.toString());
                }
                _loc_2.writeByte(13);
                _loc_2.writeByte(10);
            }
            _loc_2.position = 0;
            System.setClipboard(_loc_2.readUTFBytes(_loc_2.length));
            return;
        }// end function

        private function OnSaveStack(event:Event) : void
        {
            var _loc_4:MenuButton = null;
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
                    if (_loc_4.mUrl != null)
                    {
                    }
                    if (_loc_4.mUrl != "")
                    {
                        System.setClipboard(_loc_4.mUrl);
                    }
                    else
                    {
                        if (_loc_4.mLD != null)
                        {
                        }
                        if (_loc_4.mLD.mIOError)
                        {
                            System.setClipboard(_loc_4.mLD.mIOError.toString());
                        }
                        else
                        {
                            if (_loc_4.mLD != null)
                            {
                            }
                            if (_loc_4.mLD.mSecurityError)
                            {
                                System.setClipboard(_loc_4.mLD.mSecurityError.toString());
                            }
                        }
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
            var _loc_4:* = LoaderAnalyser.GetInstance().GetLoadersData();
            _loc_4.sortOn(SORT_ON_KEY, Array.NUMERIC | Array.DESCENDING);
            var _loc_5:* = _loc_4.length;
            _loc_2 = _loc_4.length;
            var _loc_6:* = (stage.stageHeight - 25) / 15;
            this.mBlittingTextFieldMatrix.identity();
            this.mBlittingTextFieldMatrix.ty = 20;
            this.mBlittingTextFieldMatrix.tx = this.mProgressCenterPosition;
            this.mBlittingTextFieldCenter.text = COLUMN_HEADER_PROGRESS;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldCenter, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mURLColPosition;
            this.mBlittingTextField.text = COLUMN_HEADER_URL;
            this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mHTTPStatusColPosition;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_STATUS;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mSizeColPosition;
            this.mBlittingTextFieldARight.text = COLUMN_HEADER_SIZE;
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
            var _loc_7:LoaderData = null;
            var _loc_8:int = -1;
            _loc_3 = 0;
            while (_loc_3 < _loc_6)
            {
                
                this.mStackButtonArray[_loc_3].visible = false;
                this.mSaveButtonArray[_loc_3].visible = false;
                this.mLinkButtonArray[_loc_3].visible = false;
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
                if (this.mFilterText.text != "")
                {
                    this.mFilterText.backgroundColor = 4278207488;
                    _loc_9 = this.mFilterText.text.toLowerCase();
                    if (_loc_7.mUrl != null)
                    {
                    }
                    if (_loc_7.mUrl.toLowerCase().indexOf(_loc_9) == -1)
                    {
                        _loc_3 = _loc_3 - 1;
                    }
                }
                else
                {
                    this.mFilterText.backgroundColor = 4282664004;
                }
                if (_loc_7.mFirstEvent == -1)
                {
                }
                else
                {
                    if (this.mActivateFilterButton.mIsSelected)
                    {
                        if (_loc_7.mIOError == null)
                        {
                        }
                        if (_loc_7.mSecurityError == null)
                        {
                            _loc_3 = _loc_3 - 1;
                            ;
                        }
                    }
                    this.mStackButtonArray[_loc_3].visible = true;
                    if (_loc_7.mLoadedData)
                    {
                        this.mSaveButtonArray[_loc_3].visible = true;
                        this.mSaveButtonArray[_loc_3].SetToolTipText(Localization.Lbl_RequirePro + "\n" + Localization.Lbl_LD_SaveEncriptionFreeSWF);
                    }
                    else
                    {
                        if (_loc_7.mUrl != null)
                        {
                        }
                        if (_loc_7.mIOError == null)
                        {
                        }
                        if (_loc_7.mUrl != Localization.Lbl_LA_NoUrlStream)
                        {
                        }
                        if (_loc_7.mUrl != Localization.Lbl_L_NoUrlFound)
                        {
                        }
                        if (_loc_7.mUrl != Localization.Lbl_LA_NoUrlLoader)
                        {
                            this.mLinkButtonArray[_loc_3].visible = true;
                            this.mLinkButtonArray[_loc_3].SetToolTipText(Localization.Lbl_RequirePro + "\n" + Localization.Lbl_LD_GoToLink);
                        }
                    }
                    this.DrawProgress(_loc_4[_loc_8], 38 + _loc_3 * 14);
                    if (this.mStackButtonArray[_loc_3].mUrl != _loc_7.mUrl)
                    {
                        this.mStackButtonArray[_loc_3].SetToolTipText(Localization.Lbl_FP_ClickCopyToClipboard + " " + _loc_7.mUrl);
                        this.mStackButtonArray[_loc_3].mUrl = _loc_7.mUrl;
                        this.mStackButtonArray[_loc_3].mLD = _loc_7;
                        this.mSaveButtonArray[_loc_3].mLD = _loc_7;
                        this.mLinkButtonArray[_loc_3].mLD = _loc_7;
                    }
                    else if (_loc_7.mIOError)
                    {
                        this.mStackButtonArray[_loc_3].mLD = _loc_7;
                        this.mSaveButtonArray[_loc_3].mLD = _loc_7;
                        this.mLinkButtonArray[_loc_3].mLD = _loc_7;
                        this.mStackButtonArray[_loc_3].mUrl = _loc_7.mUrl;
                        this.mStackButtonArray[_loc_3].SetToolTipText(Localization.Lbl_FP_ClickCopyToClipboard + NEW_LINE + _loc_7.mIOError.text + NEW_LINE + _loc_7.mIOError);
                    }
                    else if (_loc_7.mSecurityError)
                    {
                        this.mStackButtonArray[_loc_3].SetToolTipText(Localization.Lbl_FP_ClickCopyToClipboard + _loc_7.mSecurityError.text + NEW_LINE + _loc_7.mSecurityError);
                    }
                    this.mBlittingTextFieldMatrix.tx = this.mProgressCenterPosition;
                    this.mBlittingTextFieldCenter.text = _loc_7.mProgressText;
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldCenter, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mHTTPStatusColPosition;
                    if (_loc_7.mHTTPStatusText == null)
                    {
                        this.mBlittingTextFieldARight.text = LoaderData.LOADER_DEFAULT_HTTP_STATUS;
                    }
                    else
                    {
                        this.mBlittingTextFieldARight.text = _loc_7.mHTTPStatusText;
                    }
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mSizeColPosition;
                    this.mBlittingTextFieldARight.text = _loc_7.mLoadedBytesText;
                    this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.tx = this.mURLColPosition;
                    if (_loc_7.mUrl == null)
                    {
                        this.mBlittingTextField.text = LoaderData.LOADER_DEFAULT_URL;
                    }
                    else
                    {
                        this.mBlittingTextField.text = _loc_7.mUrl;
                    }
                    this.mBitmapBackgroundData.draw(this.mBlittingTextField, this.mBlittingTextFieldMatrix);
                    this.mBlittingTextFieldMatrix.ty = this.mBlittingTextFieldMatrix.ty + 14;
                    this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
                    this.mBitmapBackgroundData.fillRect(this.mGridLine, SkinManager.COLOR_GLOBAL_LINE);
                }
                _loc_3 = _loc_3 + 1;
            }
            this.Render();
            return;
        }// end function

        private function Render() : void
        {
            this.alpha = Commands.Opacity / 10;
            return;
        }// end function

        private function DrawProgress(ld:LoaderData, positionY:int) : void
        {
            this.mProgressBarRect.y = positionY;
            this.mProgressBarRect.width = 100;
            var _loc_3:* = SkinManager.COLOR_LOADER_DISPLAYLOADER_COMPLETED;
            if (ld.mType == LoaderData.SWF_LOADED)
            {
                _loc_3 = SkinManager.COLOR_LOADER_SWF;
            }
            else
            {
                if (ld.mIOError == null)
                {
                }
                if (ld.mSecurityError != null)
                {
                    _loc_3 = SkinManager.COLOR_LOADER_FALIED;
                }
                else if (ld.mProgress == 0)
                {
                    _loc_3 = SkinManager.COLOR_LOADER_PROGRESS;
                }
                else if (ld.mType == LoaderData.DISPLAY_LOADER)
                {
                    this.mProgressBarRect.width = 100 * ld.mProgress;
                }
                else if (ld.mType == LoaderData.URL_STREAM)
                {
                    _loc_3 = SkinManager.COLOR_LOADER_URLSTREAM_COMPLETED;
                }
                else
                {
                    _loc_3 = SkinManager.COLOR_LOADER_URLLOADER_COMPLETED;
                }
            }
            this.mBitmapBackgroundData.fillRect(this.mProgressBarRect, _loc_3);
            return;
        }// end function

        public function Dispose() : void
        {
            var _loc_1:MenuButton = null;
            var _loc_2:MenuButton = null;
            var _loc_3:MenuButton = null;
            if (this.mFilterText)
            {
                this.mFilterText.removeEventListener(KeyboardEvent.KEY_DOWN, this.OnFilterExit);
                this.mFilterText.removeEventListener(Event.CHANGE, this.OnFilterComplete);
            }
            for each (_loc_1 in this.mStackButtonArray)
            {
                
                _loc_1.Dispose();
            }
            for each (_loc_2 in this.mSaveButtonArray)
            {
                
                _loc_2.Dispose();
            }
            for each (_loc_3 in this.mLinkButtonArray)
            {
                
                _loc_3.Dispose();
            }
            Analytics.Track("Tab", "LoaderProfiler", "LoaderProfiler Exit", int((getTimer() - this.mEnterTime) / 1000));
            this.mStackButtonArray = null;
            this.mSaveButtonArray = null;
            this.mLinkButtonArray = null;
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
            this.mLoaderDict = null;
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
