package com.hendrix.contentManager.core.types
{
  import com.hendrix.collection.common.interfaces.IIdDisposable;
  import com.hendrix.processManager.core.types.BaseProcess;
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.geom.Matrix;
  import flash.net.URLRequest;
  import flash.system.ImageDecodingPolicy;
  import flash.system.LoaderContext;
  
  
  /**
   * 
   * @author Tomer Shalev
   * 
   */
  public class BitmapLoader extends BaseProcess implements IIdDisposable
  {
    private var _bmp:           BitmapData    = null;
    private var _loader:        Loader        = null;
    private var _loaderContext: LoaderContext = null;
    
    private var _ur:            URLRequest    = null;
    
    private var _src:           String        = null;
    
    private var _isLoading:     Boolean       = false;
    
    private var _resizedWidth:  uint          = 0;  
    
    private var _mat:           Matrix        = null;
    
    public function BitmapLoader(imageDecodingPolicy:String = ImageDecodingPolicy.ON_LOAD)
    {           
      _loader                             = new Loader();
      _ur                                 = new URLRequest();
      _loaderContext                      = new LoaderContext();
      
      _mat                                = new Matrix();
      
      _loaderContext.imageDecodingPolicy  = imageDecodingPolicy;
      
      _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, img_onLoaded);
      _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, img_onFailed);
    }
    
    public function get bmp():BitmapData
    {
      return _bmp;
    }
    
    public function set bmp(value:BitmapData):void
    {
      _bmp = value;
    }
    
    protected function img_onFailed(event:IOErrorEvent):void
    {
      _isLoading  = false;
      trace("failed image with id: " + id);
      notifyComplete();
    }
    
    private function img_onLoaded(e:Event):void
    {
      _isLoading                              = false;
      
      trace("got image with id: " + id);
      _bmp                                    = (_loader.content as Bitmap).bitmapData;
      
      if(_resizedWidth && (_bmp.width > _resizedWidth*1.1))
        resizeBitmap();
      
      // unload the bitmap and deref it's bitmapdata
      //(_loader.content as Bitmap).bitmapData  = null;
      
      _loader.unload();
      
      notifyComplete();
    }
    
    private function resizeBitmap():void
    {
      var wOrig:          uint    = (_loader.content as Bitmap).bitmapData.width;
      var hOrig:          uint    = (_loader.content as Bitmap).bitmapData.height;
      var arWidthBitmap:  Number  = _resizedWidth / wOrig;
      
      _mat.identity();
      _mat.scale(arWidthBitmap, arWidthBitmap);
      
      _bmp                        = new BitmapData(uint(wOrig * arWidthBitmap), uint(hOrig * arWidthBitmap), false);
      
      _bmp.draw((_loader.content as Bitmap).bitmapData, _mat, null, null, null, true);
      
      (_loader.content as Bitmap).bitmapData.dispose();
    }
    
    override public function notifyComplete():void
    {
      if(_onComplete is Function)
        _onComplete(this);
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete);
      
      //_loader.close();
      
      _bmp = null;
      
      _loader.load(_ur, _loaderContext);
      _isLoading  = true;
    }
    
    override public function dispose():void
    {
      stop();
      
      _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, img_onLoaded);
      _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, img_onFailed);
      
      _loaderContext = null;
      
      _loader = null;
      
      super.dispose();
      disposeBitmap();
      _ur = null;
      
      _src  = null;
      
      super.dispose();
    }
    
    public function disposeBitmap():void
    {
      if(_bmp) {
        _bmp.dispose();
        _bmp = null;
      }
    }
    
    override public function stop():void
    {
      if(_isLoading) {
        try{
          _loader.close();
        }
        catch(err:Error){
          trace(err);
        }
        //_loader.unload();
      }
      
      _isLoading = false;
      
    }
    
    public function get bitmap():                 BitmapData  { return _bmp;  }
    
    public function get src():                    String      { return _src;  }
    public function set src(value:String):        void    
    { 
      _src    = value;
      _ur.url = _src;
    }
    
    public function get resizedWidth():           uint        { return _resizedWidth; }
    public function set resizedWidth(value:uint): void
    {
      _resizedWidth = value;
    }
    
    
  }
}