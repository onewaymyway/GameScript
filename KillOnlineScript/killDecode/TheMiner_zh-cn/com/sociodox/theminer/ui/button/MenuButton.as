package com.sociodox.theminer.ui.button
{
    import com.sociodox.theminer.*;
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.event.*;
    import com.sociodox.theminer.manager.*;
    import com.sociodox.theminer.ui.*;
    import com.sociodox.theminer.window.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.sampler.*;

    public class MenuButton extends Sprite
    {
        private var mBitmapViewport:Bitmap;
        private var mViewportRect:Rectangle;
        private var mIconOver:Bitmap;
        private var mIconSelected:Bitmap;
        private var mIconOut:Bitmap;
        public var mToolTipText:String;
        private var mToggleText:String;
        private var mToggleEventName:String;
        public var mIsSelected:Boolean = false;
        public var mAction:int = -1;
        private var mIsToggle:Boolean = true;
        public var mInternalEvent:InternalEventEntry = null;
        public var mUrl:String = null;
        public var mLD:LoaderData = null;
        public var mUserEvent:UserEventEntry = null;
        public var mUseListeners:Boolean = true;
        public static const ICON_CAMERA:int = 0;
        public static const ICON_HELP:int = 12;
        public static const ICON_ARROW_DOWN:int = 24;
        public static const ICON_ARROW_UP:int = 36;
        public static const ICON_EVENTS:int = 48;
        public static const ICON_LIFE_CYCLE:int = 60;
        public static const ICON_MOUSE:int = 72;
        public static const ICON_OVERDRAW:int = 84;
        public static const ICON_STATS:int = 96;
        public static const ICON_MINIMIZE:int = 108;
        public static const ICON_CONFIG:int = 120;
        public static const ICON_CLIPBOARD:int = 132;
        public static const ICON_SOCKET:int = 144;
        public static const ICON_MONSTER:int = 156;
        public static const ICON_LOADER:int = 168;
        public static const ICON_CLEAR:int = 180;
        public static const ICON_STACK:int = 192;
        public static const ICON_PERFORMANCE:int = 204;
        public static const ICON_GC:int = 216;
        public static const ICON_MEMORY:int = 228;
        public static const ICON_SAVEDISK:int = 240;
        public static const ICON_PROMPT:int = 252;
        public static const ICON_LINK:int = 264;
        public static const ICON_GRADIENT:int = 276;
        public static const ICON_STAR:int = 288;
        public static const ICON_LOG:int = 300;
        public static const ICON_MAGNIFY:int = 312;
        public static const ICON_CUBE:int = 324;
        public static const ICON_ATTACH:int = 336;
        public static const ICON_FLOPPY:int = 348;
        public static const ICON_PAUSE:int = 360;
        public static const ICON_SKIN:int = 372;
        public static const ICON_FILTER:int = 384;
        public static const ICON_CLICK_AUDIO:int = 396;
        private static var mMinimizedScrollRect:Rectangle = new Rectangle(0, 0, 32, 16);

        public function MenuButton(posX:int, posY:int, iconYOffset:int, toggleEventName:String, aAction:int, tooltipText:String, aIsToggle:Boolean = true, aToggleText:String = null, aUseListeners:Boolean = true, aShowTooltip:Boolean = true)
        {
            this.mBitmapViewport = new Bitmap(SkinManager.mSkinBitmapData);
            this.mViewportRect = new Rectangle(12, iconYOffset, 12, 12);
            this.mBitmapViewport.scrollRect = this.mViewportRect;
            this.addChild(this.mBitmapViewport);
            this.mToggleText = aToggleText;
            this.mIsToggle = aIsToggle;
            this.mAction = aAction;
            this.mouseChildren = false;
            this.mToggleEventName = toggleEventName;
            this.mToolTipText = tooltipText;
            x = posX;
            y = posY;
            this.mUseListeners = aUseListeners;
            if (aUseListeners)
            {
                if (aShowTooltip)
                {
                    addEventListener(MouseEvent.MOUSE_MOVE, this.OnMouseMove, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_OVER, this.OnMouseOver, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_OUT, this.OnMouseOut, false, 0, true);
                }
                addEventListener(MouseEvent.CLICK, this.OnClick, false, 0, true);
            }
            else if (aShowTooltip)
            {
                if (aShowTooltip)
                {
                    addEventListener(MouseEvent.MOUSE_MOVE, this.OnMouseMove, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_OVER, this.OnMouseOver, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_OUT, this.OnMouseOut, false, 0, true);
                }
            }
            return;
        }// end function

        private function OnMouseMove(event:MouseEvent) : void
        {
            var _loc_2:Boolean = false;
            if (!Configuration._PROFILE_MEMORY)
            {
            }
            if (!Configuration._PROFILE_FUNCTION)
            {
            }
            if (!Configuration._PROFILE_LOADERS)
            {
            }
            if (Configuration._PROFILE_INTERNAL_EVENTS)
            {
                _loc_2 = true;
            }
            else if (Commands.mIsCollectingSamplesData)
            {
                _loc_2 = true;
            }
            if (_loc_2)
            {
                pauseSampling();
            }
            ToolTip.SetPosition(event.stageX + 12, event.stageY + 6);
            event.stopPropagation();
            event.stopImmediatePropagation();
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public function ShowIcon(type:int) : void
        {
            if (type >= 0)
            {
            }
            if (type < 3)
            {
                this.mViewportRect.x = 12 * type;
                this.mBitmapViewport.scrollRect = this.mViewportRect;
            }
            return;
        }// end function

        public function OnClick(event:MouseEvent) : void
        {
            var _loc_3:Event = null;
            var _loc_4:Event = null;
            var _loc_5:Event = null;
            var _loc_6:Event = null;
            var _loc_7:Event = null;
            var _loc_8:Event = null;
            var _loc_9:Event = null;
            var _loc_2:Boolean = false;
            if (!Configuration._PROFILE_MEMORY)
            {
            }
            if (!Configuration._PROFILE_FUNCTION)
            {
            }
            if (!Configuration._PROFILE_LOADERS)
            {
            }
            if (Configuration._PROFILE_INTERNAL_EVENTS)
            {
                _loc_2 = true;
            }
            else if (Commands.mIsCollectingSamplesData)
            {
                _loc_2 = true;
            }
            if (_loc_2)
            {
                pauseSampling();
            }
            if (event != null)
            {
                event.stopPropagation();
                event.stopImmediatePropagation();
            }
            this.mViewportRect.x = 0;
            this.mBitmapViewport.scrollRect = this.mViewportRect;
            if (this.mIsSelected)
            {
                this.mIsSelected = false;
                if (this.mToggleText != null)
                {
                    this.SetToolTipText(this.mToolTipText);
                }
                if (this.mToggleEventName == Commands.SAVE_RECORDING_EVENT)
                {
                    _loc_3 = new Event(Commands.SAVE_RECORDING_EVENT, true);
                    dispatchEvent(_loc_3);
                }
                else if (this.mToggleEventName == Commands.SAVE_RECORDING_TRACE_EVENT)
                {
                    _loc_4 = new Event(Commands.SAVE_RECORDING_TRACE_EVENT, true);
                    dispatchEvent(_loc_4);
                }
                else if (this.mToggleEventName == Configuration.LOAD_SKIN_EVENT)
                {
                }
                else if (this.mToggleEventName == Commands.TOGGLE_MINIMIZE)
                {
                }
                else if (this.mAction != -1)
                {
                    TheMiner.Do(this.mAction);
                }
                if (_loc_2)
                {
                    startSampling();
                }
                return;
            }
            if (this.mIsToggle)
            {
                this.mIsSelected = true;
                if (this.mIsSelected)
                {
                }
                if (this.mToggleText != null)
                {
                    ToolTip.Text = this.mToggleText;
                }
            }
            if (this.mToggleEventName != null)
            {
                if (this.mToggleEventName === ChangeToolEvent.CHANGE_TOOL_EVENT)
                {
                    TheMiner.Do(this.mAction);
                    OptionInterface.ResetMenu(this);
                }
                else if (this.mToggleEventName === Commands.TOGGLE_QUIT)
                {
                }
                else if (this.mToggleEventName === Commands.SAVE_RECORDING_EVENT)
                {
                }
                else if (this.mToggleEventName === Commands.SAVE_RECORDING_TRACE_EVENT)
                {
                }
                else if (this.mToggleEventName === Configuration.LOAD_SKIN_EVENT)
                {
                    _loc_5 = new Event(Configuration.LOAD_SKIN_EVENT, true);
                    dispatchEvent(_loc_5);
                }
                else if (this.mToggleEventName === Commands.TOGGLE_MINIMIZE)
                {
                    OptionInterface.ResetMenu(null);
                    OptionInterface.Hide();
                    TheMiner.Do(TheMinerActionEnum.CLOSE_PROFILERS);
                }
                else if (this.mToggleEventName === Commands.SAVE_SNAPSHOT_EVENT)
                {
                    _loc_6 = new Event(Commands.SAVE_SNAPSHOT_EVENT, true);
                    dispatchEvent(_loc_6);
                }
                else if (this.mToggleEventName === PerformanceProfiler.SAVE_FUNCTION_STACK_EVENT)
                {
                    _loc_7 = new Event(PerformanceProfiler.SAVE_FUNCTION_STACK_EVENT, true);
                    dispatchEvent(_loc_7);
                }
                else if (this.mToggleEventName === LoaderProfiler.SAVE_FILE_EVENT)
                {
                    _loc_8 = new Event(LoaderProfiler.SAVE_FILE_EVENT, true);
                    dispatchEvent(_loc_8);
                }
                else if (this.mToggleEventName === LoaderProfiler.GO_TO_LINK)
                {
                    _loc_9 = new Event(LoaderProfiler.GO_TO_LINK, true);
                    dispatchEvent(_loc_9);
                }
                else
                {
                    if (this.mToggleEventName === Commands.SCREEN_CAPTURE_EVENT)
                    {
                        dispatchEvent(new Event(Commands.SCREEN_CAPTURE_EVENT, true));
                    }
                    TheMiner.Do();
                    OptionInterface.ResetMenu(null);
                }
            }
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public function OnMouseOver(event:MouseEvent) : void
        {
            var _loc_2:Boolean = false;
            if (!Configuration._PROFILE_MEMORY)
            {
            }
            if (!Configuration._PROFILE_FUNCTION)
            {
            }
            if (!Configuration._PROFILE_LOADERS)
            {
            }
            if (Configuration._PROFILE_INTERNAL_EVENTS)
            {
                _loc_2 = true;
            }
            else if (Commands.mIsCollectingSamplesData)
            {
                _loc_2 = true;
            }
            if (_loc_2)
            {
                pauseSampling();
            }
            event.stopPropagation();
            event.stopImmediatePropagation();
            if (this.mViewportRect.x == 12 * 1)
            {
                this.mViewportRect.x = 12 * 2;
                this.mBitmapViewport.scrollRect = this.mViewportRect;
            }
            if (this.mIsSelected)
            {
            }
            if (this.mToggleText != null)
            {
                ToolTip.Text = this.mToggleText;
            }
            else
            {
                ToolTip.Text = this.mToolTipText;
            }
            ToolTip.Visible = true;
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public function SetToolTipText(text:String) : void
        {
            this.mToolTipText = text;
            if (this.mViewportRect.x == 0)
            {
                ToolTip.Text = text;
            }
            return;
        }// end function

        public function OnMouseOut(event:MouseEvent) : void
        {
            var _loc_2:Boolean = false;
            if (!Configuration._PROFILE_MEMORY)
            {
            }
            if (!Configuration._PROFILE_FUNCTION)
            {
            }
            if (!Configuration._PROFILE_LOADERS)
            {
            }
            if (Configuration._PROFILE_INTERNAL_EVENTS)
            {
                _loc_2 = true;
            }
            else if (Commands.mIsCollectingSamplesData)
            {
                _loc_2 = true;
            }
            if (_loc_2)
            {
                pauseSampling();
            }
            event.stopPropagation();
            event.stopImmediatePropagation();
            ToolTip.Visible = false;
            if (this.mIsSelected)
            {
                return;
            }
            this.mViewportRect.x = 12 * 1;
            this.mBitmapViewport.scrollRect = this.mViewportRect;
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public function Reset() : void
        {
            this.mIsSelected = false;
            this.mViewportRect.x = 12 * 1;
            this.mBitmapViewport.scrollRect = this.mViewportRect;
            return;
        }// end function

        public function Dispose() : void
        {
            if (this.mIconOver != null)
            {
                if (this.mIconOver.bitmapData != null)
                {
                    this.mIconOver.bitmapData.dispose();
                }
                this.mIconOver = null;
            }
            if (this.mIconSelected != null)
            {
                if (this.mIconSelected.bitmapData != null)
                {
                    this.mIconSelected.bitmapData.dispose();
                }
                this.mIconSelected = null;
            }
            if (this.mIconOut != null)
            {
                if (this.mIconOut.bitmapData != null)
                {
                    this.mIconOut.bitmapData.dispose();
                }
                this.mIconOut = null;
            }
            this.mToolTipText = null;
            this.mToggleText = null;
            this.mToggleEventName = null;
            this.mUserEvent = null;
            this.mLD = null;
            this.mAction = -1;
            this.mInternalEvent = null;
            this.mUrl = null;
            return;
        }// end function

    }
}
