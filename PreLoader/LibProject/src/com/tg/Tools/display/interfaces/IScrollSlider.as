package com.tg.Tools.display.interfaces
{
  /**
   * @author luli&ww
   */
  public interface IScrollSlider {
    function get value():Number;
    function set value(value:Number):void;
    function get thumbNeedResize():Boolean;
    function get thumbScale():Number;
    function set thumbScale(value:Number):void;
    function get max():Number;
    function get min():Number;
    function setParameter(min:Number, max:Number, value:Number):void;
    function destory():void;
  }
}
