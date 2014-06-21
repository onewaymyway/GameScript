package com.sociodox.theminer.window
{
    import flash.display.*;

    public interface IWindow
    {

        public function IWindow();

        function Update() : void;

        function Dispose() : void;

        function Unlink() : void;

        function Link(aParent:DisplayObjectContainer, aPos:int) : void;

    }
}
