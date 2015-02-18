package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  import com.hendrix.contentManager.core.types.BaseContent;
  
  import flash.display.Loader;
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.system.LoaderContext;
  import flash.utils.ByteArray;
  
  public class SWFContent extends BaseContent
  {
    private var _swfMovieClip:MovieClip = null;
    private var _loader:Loader = null;
    
    public function SWFContent($id:String, $content:ByteArray, $onFinishedProcessing:Function=null)
    {
      super($id, $content, $onFinishedProcessing);
      
      _type = LocalResource.TYPE_SWF;
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete, $onError);
      
      var loaderContext: LoaderContext = new LoaderContext();
      loaderContext.allowLoadBytesCodeExecution = true; 
      
      _loader = new Loader();
      _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoadComplete); 
      
      _loader.loadBytes(_contentBinary, loaderContext);
    }
    
    override public function dispose():void
    {
      _loader = null;
      
      super.dispose();
    }
    
    protected function onSwfLoadComplete(event:Event):void
    {
      _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoadComplete);
      _swfMovieClip = _loader.content as MovieClip;
      
      notifyComplete();
    }
    
    public function get swfBinary():ByteArray
    {
      return _contentBinary;
    }
    
    public function get swfMovieClip():MovieClip
    {
      return _swfMovieClip;
    }
    
  }
  
}