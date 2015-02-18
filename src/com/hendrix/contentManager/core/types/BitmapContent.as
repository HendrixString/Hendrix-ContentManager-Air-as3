package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.system.ImageDecodingPolicy;
  import flash.system.LoaderContext;
  import flash.utils.ByteArray;
  
  public class BitmapContent extends BaseContent
  {
    private var _bitmap:  Bitmap  = null;
    private var _loader:  Loader  = null;
    
    
    public function BitmapContent($id:String, $content:ByteArray)
    {
      super($id, $content);
      
      _type                     = LocalResource.TYPE_BITMAP;
    }
    
    private function onImgloaded(e:Event):void
    {
      e.target.removeEventListener(Event.COMPLETE, onImgloaded);
      
      _bitmap = new Bitmap(e.target.content.bitmapData);
      
      _loader.unload();
      
      notifyComplete();
      
      super.dispose();
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete);
      
      _loader = new Loader();
      var loaderContext:LoaderContext = new LoaderContext();
      loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
      
      _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgloaded);
      _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderFailed);
      _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
      _loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderFailed);
      _loader.loadBytes(_contentBinary, loaderContext);
    }
    
    protected function onImgloaded2(event:Event):void
    {
      // TODO Auto-generated method stub
      trace("loaded");
    }
    
    protected function onLoaderProgress(event:ProgressEvent):void
    {
      // TODO Auto-generated method stub
      _id
      trace("progress " + event.bytesLoaded/event.bytesTotal);
    }
    
    protected function onLoaderFailed(event:IOErrorEvent):void
    {
      // TODO Auto-generated method stub
      trace(event.errorID + " : " + event.text);
    }
    
    public function get bitmap():Bitmap
    {
      return _bitmap;
    }
    
    override public function dispose():void
    {
      super.dispose();
      _bitmap.bitmapData.dispose();
      _bitmap = null;
    }
    
    override public function get content():Object
    {
      return bitmap.bitmapData;
    }
    
  }
}