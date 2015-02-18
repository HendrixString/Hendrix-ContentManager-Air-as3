package com.hendrix.contentManager.core.interfaces
{
  public interface IIdProcess extends IId
  {
    function process():void;
    function complete():void;
    function dispose():void;
  }
}