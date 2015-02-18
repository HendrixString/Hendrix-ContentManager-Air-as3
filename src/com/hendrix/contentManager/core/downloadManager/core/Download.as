package com.hendrix.contentManager.core.downloadManager.core
{ 
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLStream;
  import flash.utils.ByteArray;
  
  public class Download
  {
    
    protected var _url:               String    = null;
    protected var _fileName:          String    = null;
    protected var _urlLoader:         URLLoader = null;
    protected var _urlStream:         URLStream = null;
    protected var _bytes:             ByteArray = null;
    protected var _id:                String    = null;
    
    protected var _progressCallBack:  Function  = null;
    protected var _progress:          Number    = 0;
    protected var _status:            DownloadStatus    = null;
    protected var _isFileExists:      Boolean   = false;
    protected var _numTries:          uint      = 0;
    
    public function Download($url:String, $progressCallBack:Function  = null, $id:String  = null)
    {
      _id               = $id ? $id : (new Date()).toString();
      _url              = $url;
      _progressCallBack = $progressCallBack;
      _bytes            = new ByteArray;
      _numTries         = DownloadManagerSettings.MAX_DOWNLOAD_TRIES_PER_FAILURE;
      
      var arr:  Array   = _url.split("/");
      _fileName         = arr[arr.length - 1];
      
    }
    
    public function downloadFile():void
    {
      _numTries += 1;
      
      trace("starting loading");
      
      _urlStream  = new URLStream();
      _urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
      _urlStream.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
      _urlStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, false);
      _urlStream.load(new URLRequest(_url));
    }
    
    protected function onProgress(event:ProgressEvent):void
    {
      var percentLoaded:Number = event.bytesLoaded/event.bytesTotal;
      percentLoaded = Math.round(percentLoaded * 100)*0.9; // 0% to 70%
      _progress     = percentLoaded;
      
      if(_progressCallBack is Function)
        _progressCallBack(percentLoaded);
    }
    
    protected function onIOError(e: IOErrorEvent): void
    {
      _status = new DownloadStatus(DownloadStatus.STATUS_FAILED, _id);
      var loader: URLLoader = e.target as URLLoader;
      
      if (loader != null) {
        loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
      }
      trace("ERROR: " + e.toString());
    }
    
    protected function urlLoaderCompleteHandler(e:Event):void 
    {
      trace("complete loading");
      //_bytes  = _urlLoader.data as ByteArray;
      _urlStream.readBytes(_bytes,  0,  _urlStream.bytesAvailable);
      _status = new DownloadStatus(DownloadStatus.STATUS_DOWNLOAD_SUCCEED, _id);
    }
    
    public function dispose():void
    {
      _bytes.clear();
      _urlStream.close();
      _urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
      _urlStream.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
      _urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
      _progressCallBack = null;
    }
    
    public function get url():String
    {
      return _url;
    }
    
    public function get status():DownloadStatus
    {
      return _status;
    }
    
    public function get numTries():uint
    {
      return _numTries;
    }
    
    public function get bytes():ByteArray
    {
      return _bytes;
    }
    
    public function get id():String
    {
      return _id;
    }
    
    
  }
}